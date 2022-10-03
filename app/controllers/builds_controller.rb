class BuildsController < ApplicationController
  before_action :authorize, only: %i[create update]

  # kiem tra xem da hoan thanh build cu chua
  # Cach1: Dung SQL
  # def create
  #  @build = Build.where(user_id: @current_user,complete: "0")
  #   # render json: @user
  #   if @user.count == 1
  #     render json: { message: 'ban can hoan thanh cong viec cu' }
  #   else
  #     @build = @current_user.builds.build(build_params)
  #     @build.save
  #     render json: @build
  #   end
  # end

  # Cach2: Viet function
  def index
    build = Build.all
    render json: build, each_serializer: nil
  end

  def create
    @build = Build.where(user_id: @current_user,complete: "0")
    render json: @build
  end

  def show
    @build = Build.find_by(id: params[:id])
    render json: @build.check_complete
  end

  def update
    @build = Build.find(params[:id])
    if @build.update(build_params)
      render json: { build: @build, message: 'cap nhat thanh cong' }
    else
      render json: { build: @build.errors.messages, message: 'cap nhat that bai' }
    end
  end

  private

  def build_params
    params.permit(:cpu, :main, :psu, :cooler, :ssd, :ram, :gpu, :hdd)
  end
end
