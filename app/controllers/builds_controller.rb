class BuildsController < ApplicationController
  before_action :authorize, only: %i[create update index check]

  # kiem tra xem da hoan thanh build cu chua

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

  # done
  # def create
  #   @build = Build.where(user_id: @current_user)
  #                 .where(main: nil)
  #                 .or(Build.where(cpu: nil))
  #                 .or(Build.where(hdd: nil))
  #                 .or(Build.where(psu: nil))
  #                 .or(Build.where(cooler: nil))
  #                 .or(Build.where(ssd: nil))
  #                 .or(Build.where(ram: nil))
  #                 .or(Build.where(gpu: nil))
  #   if @build.count != 0
  #     render json: { build: @build, message: 'ban can hoan thanh cong viec cu' }
  #   else
  #     @build = @current_user.builds.build(build_params)
  #     @build.save
  #     render json: @build, each_serializer: nil
  #   end
  #   # render json: @current_user
  # end
  ##############################
  def create
    @build = Build.where(user_id: @current_user)
    @build.each do |b|
      if b.check_complete == true
        next
      else
        @message = 'Chua hoan thanh'
        render json: {
          message: 'Ban chua hoan tat build cu'
        }
        break
      end
    end

    unless @message
      @build = @current_user.builds.build(build_params)
      @build.save
      render json: @build, each_serializer: nil
    end
  end

  # Show nhung builds da hoan thanh
  def index
    @build = Build.where(user_id: @current_user)
                  .where.not(cpu: blank?)
                  .where.not(main: blank?)
                  .where.not(psu: blank?)
                  .where.not(cooler: blank?)
                  .where.not(ssd: blank?)
                  .where.not(ram: blank?)
                  .where.not(gpu: blank?)
                  .where.not(hdd: blank?)
    render json: @build
  end

  # Kiem tra tung build da hoan thanh chua
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

  # Kiem tra Build chua hoan thanh
  def check
    @build = Build.where(user_id: @current_user)
    @build.each do |b|
      if b.check_complete == false
        render json: b
      end
    end
  end

  private

  def build_params
    params.permit(:cpu, :main, :psu, :cooler, :ssd, :ram, :gpu, :hdd)
  end
end
