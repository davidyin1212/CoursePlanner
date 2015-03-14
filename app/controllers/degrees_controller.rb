class DegreesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_degree, only: [:show, :edit, :update, :destroy]

  # GET /degrees
  # GET /degrees.json
  def index
    @degrees = Degree.all
  end

  # GET /degrees/1
  # GET /degrees/1.json
  def show
  end

  # GET /degrees/new
  def new
    @courses = Course.all
    @degree = Degree.new
  end

  # GET /degrees/1/edit
  def edit
    @courses = Course.all
  end

  # POST /degrees
  # POST /degrees.json
  def create
    @degree = Degree.new(degree_params)
    @degree.update({:degree_requirements => ""})

    respond_to do |format|
      if @degree.save
        format.html { redirect_to @degree, notice: 'Degree was successfully created.' }
        format.json { render :show, status: :created, location: @degree }
      else
        format.html { render :new }
        format.json { render json: @degree.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /degrees/1
  # PATCH/PUT /degrees/1.json
  def update
    respond_to do |format|
      if @degree.update(degree_params)
        format.html { redirect_to @degree, notice: 'Degree was successfully updated.' }
        format.json { render :show, status: :ok, location: @degree }
      else
        format.html { render :edit }
        format.json { render json: @degree.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /degrees/1
  # DELETE /degrees/1.json
  def destroy
    @degree.destroy
    respond_to do |format|
      format.html { redirect_to degrees_url, notice: 'Degree was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /degrees/1
  # PATCH/PUT /degrees/1.json
  def edit_page
    set_degree
    @courses = Course.all
  end
	  
  def addReq
    #Add requirement to degree
    set_degree
    @degree.update({:degree_requirements => params[:req]})
    respond_to do |format|
      format.json {head :ok}
    end
  end

  helper_method :addReq

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_degree
      @degree = Degree.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def degree_params
      params.require(:degree).permit(:degree_name, :degree_type, :degree_requirements)
    end
end
	
