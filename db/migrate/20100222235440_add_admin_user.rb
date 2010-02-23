class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.create(:login => 'commish', :team => 'coyotes', :role => 'admin',
      :password => 'b1gb0y', :email => 'dummy@mtbcalendar.com', :draft_order => 1,
      :password_confirmation => 'b1gb0y')
  end

  def self.down
    User.destroy(User.find_by_login('commish'))
  end
end
