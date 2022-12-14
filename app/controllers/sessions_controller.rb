class SessionsController < ApplicationController
  # def login
  #   @user = User.find_by(email: params[:email])
  #   if @user && @user.authenticate(params[:password])
  #     token = encode_token({ user_id: @user.id })
  #     render json: { user: @user, token: }, status: :ok
  #   else
  #     render json: { error: 'invalid name or password' }, status: :unprocessable_entity
  #   end
  # end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      if !@user.confirmation_token?
        token = encode_token({ user_id: @user.id })
        render json: { user: @user, token: }, status: :ok
      else
        render json: { message: 'Account not activated'}
      end
    else
      render json: { error: 'invalid name or password' }, status: :unprocessable_entity
    end
  end
end
