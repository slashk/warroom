class RetaineesController < ApplicationController
  # GET /retainees
  # GET /retainees.xml
  def index
    @retainees = Retainee.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @retainees }
    end
  end

  # GET /retainees/1
  # GET /retainees/1.xml
  def show
    @retainee = Retainee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @retainee }
    end
  end

  # GET /retainees/new
  # GET /retainees/new.xml
  def new
    @retainee = Retainee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @retainee }
    end
  end

  # GET /retainees/1/edit
  def edit
    @retainee = Retainee.find(params[:id])
  end

  # POST /retainees
  # POST /retainees.xml
  def create
    @retainee = Retainee.new(params[:retainee])

    respond_to do |format|
      if @retainee.save
        flash[:notice] = 'Retainee was successfully created.'
        format.html { redirect_to(@retainee) }
        format.xml  { render :xml => @retainee, :status => :created, :location => @retainee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @retainee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /retainees/1
  # PUT /retainees/1.xml
  def update
    @retainee = Retainee.find(params[:id])

    respond_to do |format|
      if @retainee.update_attributes(params[:retainee])
        flash[:notice] = 'Retainee was successfully updated.'
        format.html { redirect_to(@retainee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @retainee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /retainees/1
  # DELETE /retainees/1.xml
  def destroy
    @retainee = Retainee.find(params[:id])
    @retainee.destroy

    respond_to do |format|
      format.html { redirect_to(retainees_url) }
      format.xml  { head :ok }
    end
  end
end
