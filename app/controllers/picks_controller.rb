class PicksController < ApplicationController
  # GET /picks
  # GET /picks.xml
  def index
    @picks = Pick.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @picks }
    end
  end

  # GET /picks/1
  # GET /picks/1.xml
  def show
    @pick = Pick.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pick }
    end
  end

  # GET /picks/new
  # GET /picks/new.xml
  def new
    @pick = Pick.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pick }
    end
  end

  # GET /picks/1/edit
  def edit
    @pick = Pick.find(params[:id])
  end

  # POST /picks
  # POST /picks.xml
  def create
    @pick = Pick.new(params[:pick])

    respond_to do |format|
      if @pick.save
        flash[:notice] = 'Pick was successfully created.'
        format.html { redirect_to(@pick) }
        format.xml  { render :xml => @pick, :status => :created, :location => @pick }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pick.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /picks/1
  # PUT /picks/1.xml
  def update
    @pick = Pick.find(params[:id])

    respond_to do |format|
      if @pick.update_attributes(params[:pick])
        flash[:notice] = 'Pick was successfully updated.'
        format.html { redirect_to(@pick) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pick.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /picks/1
  # DELETE /picks/1.xml
  def destroy
    @pick = Pick.find(params[:id])
    @pick.destroy

    respond_to do |format|
      format.html { redirect_to(picks_url) }
      format.xml  { head :ok }
    end
  end
end
