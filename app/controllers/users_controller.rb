class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  # def index
  #   @users = User.all
    
  # end

  # GET /users/1
  # GET /users/1.json
  def show
    @courses = Course.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    # user_params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def addDegreePage
    @degrees = Degree.all

    @user = User.find(params[:id])
  end

  def addDegree
    @degree = Degree.find(params[:id])

    # Actually adding link between degree and user
    @user = User.find(params[:user_id])
    if not @degree.users.exists?(@user)
      @degree.users << @user
    end
    redirect_to @user

  end

  def remDegree
    @user = User.find(params[:user_id])
    @degree = Degree.find(params[:degree_id])

    @degree.users.delete(@user);

    redirect_to @user
  end

  def addCoursePage
    @courses = Course.all

    @user = User.find(params[:id])
  end

  def addCourse
    @course = Course.find(params[:id])

    # Actually adding link between degree and user
    @user = User.find(params[:user_id])
    if not @course.users.exists?(@user)
      @course.users << @user
    end
    redirect_to @user

  end

  def remCourse
    @user = User.find(params[:user_id])
    @course = Course.find(params[:course_id])

    @course.users.delete(@user);

    redirect_to @user
  end

  def displayCourses

      @mycourses = User.find(params[:user_id]).courses.all
      #if Winter or Fall
      @mycourses.each do |mycourse|
        for meeting in mycourse.Wintersections["L0101"][3]
          puts(meeting)
        end

      end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

end
