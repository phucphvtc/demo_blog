class UsersController < ApplicationController
  before_action :authorize, only: %i[show update destroy index]
  before_action :admin_user, only: %i[index destroy]

  def index
    @user = User.all
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token}, status: :ok
    else
      render json: @user.errors.messages, status: 422
    end
  end

  def show
    # authorized_user

    # Neu khong dung ID thi khong duoc show
    @user = User.find(params[:id])
    if @user == @current_user || @current_user.admin
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token}, status: :ok
    else
      render json: {
        message: 'Khong co quyen xem in4 nguoi khac'
      }
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: { user: @user, message: 'update thanh cong' }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  # Confirm email, active account
  def confirm
    token = params[:token].to_s
    @user = User.find_by(confirmation_token: token)
    if @user.present? && @user.confirmation_sent_at + 30.days > Time.now.utc
      @user.confirmation_token = nil
      @user.confirmed_at = Time.now.utc
      @user.save
      render json: { status: 'User confirmed successfully' }, status: :ok
    else
      render json: { status: 'Invalid token' }, status: :not_found
    end
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
