class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]
  before_action :authorize, only: %i[create update destroy]
  before_action :admin_user, only: %i[destroy]

  def index
    # @posts = Post.all
    @posts = Post.paginate(page: params[:page], per_page: 10)
    render json: @posts
  end

  def create
    # authorized_user
    # render json: @current_user
    @post = @current_user.posts.build(post_params)
    if @post.save
      render json: @post, status: :ok
    else
      render json: @post.errors.messages, status: 422
    end
  end

  def show
    # render json: @current_user.admin
    @post = Post.find(params[:id])
    if @user == @current_user || @current_user.admin
      render json: @post, status: :ok
    else
      render json: { messages: 'khong co quyen xem' }
    end
  end

  def update
    if @post.update(post_params)
      render json: { post: @post, messages: 'Cap nhat thanh cong' }, status: :ok
    else
      render json: { messages: 'That bai' }, stauts: 422
    end
  end

  def destroy
    if @user == @current_user || @current_user.admin
      @post.destroy
      render json: { messages: 'xoa thanh cong' }, status: :ok
    else
      render json: { messages: 'khong co quyen xoa' }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :content)
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
