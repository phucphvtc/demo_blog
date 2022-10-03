class UsersController < ApplicationController
  before_action :admin_user, only: %i[index destroy]
  before_action :authorize, only: %i[show update destroy]

  def index
    @user = User.all
    render json: @user
  end

  def create
    user = User.new(user_params)
    if user.save
      token = encode_token({ user_id: user.id })
      render json: { user:, token: }, status: :ok
    else
      render json: user.errors.messages, status: 422
    end
  end

  def show
    # authorized_user

    # Neu khong dung ID thi khong duoc show
    user = User.find(params[:id])
    render json: user, each_serializer: nil
    # if user == @current_user || @current_user.admin
    #   token = encode_token({ user_id: user.id })
    #   render json: { user:, token: }, status: :ok, each_serializer: BuildSerializer
    # else
    #   render json: {
    #     message: 'Khong co quyen xem in4 nguoi khac'
    #   }
    # end
  end

  def update
    @user = User.find(params[:id])
    if @user == @current_user || @current_user.admin
      @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

  def user_params
    params.permit(:email, :password, :admin)
  end

  def admin_user
    authorized_user
    unless @current_user.admin?
      render json: {
        message: 'May khong phai Admin'
      }
    end
  end

end
