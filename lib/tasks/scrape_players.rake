require 'rubygems'
require 'net/http'
require 'hpricot'
require 'cgi'

# NOTES
# there are a lot of gotchas on parsing/scraping yahoo! stats
# batter and pitching stats are displayed differently and at different URLs
# some stats are combined in one table cell and need further regex parsing

# http://baseball.fantasysports.yahoo.com/b1/17633/players?status=A&pos=B&cut_type=33&stat1=S_S_2010&myteam=0&sort=OR&sdir=1&count=25

LEAGUE_ID = 17633 # change this to your new league number
# path = "/b1/#{LEAGUE_ID}/players?status=A&pos=B&cut_type=33&stat1=S_S_2010&sort=OR&sdir=1&count=25"
path = "/b1/#{LEAGUE_ID}/players?status=A&pos=B&cut_type=33&stat1=S_S_2010&myteam=0&sort=OR&sdir=1&count=0"
SITE = "http://baseball.fantasysports.yahoo.com"
# Cookies are hard. find the Yahoo! cookies for B, Y and T
# you need your own, otherwise you can't grab for your league
Y_COOKIE = "B=a6f0sd56olptb&b=4&d=KKDnTGtpYEKQNNEcM2nBJ5BPPuX2gvUwRMCnCg--&s=02&i=XNHJH5hjAhNAFzxz8sB6;Y=v=1&n=4t90ciibh0ajb&l=af4ffb440hj7b8dad4j/o&p=m242tgi4f33f0200&r=0u&lg=en-US&intl=us&np=1;T=z=2euiNB2yVnNBIKjLXyVUo.LNjU2MAY1Mjc2NTE1MTM-&a=YAE&sk=DAAKUpaCj7GEHV&ks=EAAnCRtaHBFFAntVmaV6eKcpg--~E&d=c2wBTVRJeE53RXlOVEF4TWpZeU5qUS0BYQFZQUUBZwFPUVJYQ09SSlBSNDJVUzZZR1FLT0NSQUJFNAFvawFaVzAtAWFsAWtwZXBwbGUBdGlwAWp4MmtTRAF6egEyZXVpTkJBN0U-"

DEBUG = true

class String
  def escape_single_quotes
    self.gsub(/[']/, '\\\\\'')
  end
end

def get_player_page(s, p, c)
  req = nil
  res = nil
  u = s + p
  url = URI.parse(u)
  req = Net::HTTP::Post.new(url.path)
  req['Cookie']= c
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req, url.query)
  }
end

def distill_hitters_page(res)
  # TODO players needs to be an array of hashes
  p = Array.new
  player = Hash.new
  doc = Hpricot(res.body)
  ['odd first','odd', 'even','odd last'].each do |group|
    f = "tr[@class=" + group + "]"
    (doc/f).each do |line|
      name = (line/"a[@class='name']").inner_html
      x = (line/"td")
      # TODO need to further parse URL to find player key
      url = (x[0]/"a").first[:href]
      url =~ /\/(\d+)$/
      yahoo_ref = $1
      # TODO find pos and team from X[0]
      detail = (x[0]/"[@class='detail']/").inner_html
      detail =~ /\((.*) - (.*)\)/
      pos = $2
      team = $1
      pos.gsub!(/\,/," ")
      # puts url + " : " + yahoo_ref.to_s
      # TODO separate HAB
      hab = x[8].inner_html
      hab =~ /(.*)\/(.*)/
      hit = $1
      ab = $2
      # find out status
      status = (line/"span[@class='status']").inner_html
      player = { 'yahoo_ref' => yahoo_ref,
        'orank' => x[5].inner_html,
        'rank' => x[6].inner_html,
        'H' => hit,
        'AB' => ab,
        'R' => x[9].inner_html,
        'HR' => x[10].inner_html,
        'RBI' => x[11].inner_html,
        'SB' => x[12].inner_html,
        'team' => team,
        'pos' => pos,
        'player' => name.escape_single_quotes,
        'status' => status,
        'AVG' => x[13].inner_html }
      if player['rank'].match('-')
        player['rank'] = '1500'
#        puts "#{player['player']} had a zero rank"
      end
      p << player
    end
  end  
  # TODO return the array of players
  return p
end

def distill_pitchers_page(res)
  # TODO players needs to be an array of hashes
  p = Array.new
  player = Hash.new
  doc = Hpricot(res.body)
  ['odd first','odd', 'even','odd last'].each do |group|
    f = "tr[@class=" + group + "]"
    (doc/f).each do |line|
      name = (line/"a[@class='name']").inner_html
      x = (line/"td")
      # TODO need to further parse URL to find player key
      url = (x[0]/"a").first[:href]
      url =~ /\/(\d+)$/
      yahoo_ref = $1
      # TODO find pos and team from X[0]
      detail = (x[0]/"[@class='detail']/").inner_html
      detail =~ /\((.*) - (.*)\)/
      pos = $2
      team = $1
      status = (line/"span[@class='status']").inner_html
      pos.gsub!(/\,/," ")
      player = { 'yahoo_ref' => yahoo_ref,
        'orank' => x[5].inner_html,
        'rank' => x[6].inner_html,
        'IP' => x[8].inner_html,
        'W' => x[9].inner_html,
        'SV' => x[10].inner_html,
        'K' => x[11].inner_html,
        'ERA' => x[12].inner_html,
        'team' => team,
        'pos' => pos,
        'player' => name.escape_single_quotes,
        'status' => status,
        'WHIP' => x[13].inner_html }
      if player['rank'].match('-')
        player['rank'] = '1500'
#        puts "#{player['player']} had a zero rank"
      end
      p << player
    end
  end  
  # TODO return the array of players
  return p
end

def get_next_page_path(res)
  begin
    doc = Hpricot(res.body)
    (doc/"ul#playerspagenav1"/"li[@class='last ']"/"a").first[:href]
  rescue 
    return nil
  end
end

def spit(players)
  # this is old method for printing out SQL
  categories = ["orank", "yahoo_ref", "player", "team", "pos", "rank", "IP", "W", "SV", "K", "ERA", "WHIP", "R", "HR", "RBI", "SB", "AVG", "AB"]
  case format
  when 'sql'
    stats = Array.new
    players.each do |p|
      s = Array.new
      categories.sort.each do |c|
        s << "'" + p[c].to_s + "'"
      end
    stats << "(#{s.join(",")})"
    end
    print "INSERT DELAYED INTO players ("
    print categories.sort.join(",").to_s
    print ") VALUES "
    print stats.join(',')
  end
end

def insert_players_into_db(players)
  players.each do |p|
    # puts "#{p['player']}"
    new_player = Player.create(:orank => p['orank'], :yahoo_ref => p['yahoo_ref'], :player => p['player'], :team => p['team'], :pos => p['pos'], :rank => p['rank'], :IP => p['IP'], :W => p['W'], :SV => p['SV'], :K => p['K'], :ERA => p['ERA'], :WHIP => p['WHIP'], :R => p['R'], :HR => p['HR'], :RBI => p['RBI'], :SB => p['SB'], :AVG => p['AVG'], :AB => p['AB'], :status => p['status'])
    if new_player.save
      puts "#{p['player']} saved"
    else
      new_player.touch
      puts "#{p['player']} updated"
    end
  end
end

desc "scrapes players and player stats from Y!"
task :scrape_players => :environment do
  until path.nil? do
    page = get_player_page(SITE, path, Y_COOKIE)
    path = nil
    insert_players_into_db(distill_hitters_page(page))
    path = get_next_page_path(page)
    page = nil
  end
  path = "/b1/#{LEAGUE_ID}/players?status=A&pos=P&stat1=S_S_2010&sort=OR"
  until path.nil? do
    page = get_player_page(SITE, path, Y_COOKIE)
    path = nil
    insert_players_into_db(distill_pitchers_page(page))
    path = get_next_page_path(page)
    page = nil
  end
end

desc "find players not updated today"
task :find_stale_players => :environment do
  stale = Player.all(:conditions => "date(updated_at) != CURRENT_DATE")
  stale.each do |p|
    puts "#{p.id}. #{p.player} (#{p.team})"
  end
end