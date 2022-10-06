class CommentsController < ApplicationController
  before_action :find_commentable, only: :create
  before_action :authorize, only: %i[create update destroy]
  before_action :correct_user, only: %i[edit update destroy]

  def index
    @comment = Comment.all
    render json: @comment
  end

  def show
    @comment = Comment.find(params[:id])

    render json: @comment
  end


  def create
    # render json: @current_user
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = @current_user.id
    if @comment.save
      render json: { comment: @comment }, status: :ok
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      render json: { comment: @comment }, status: :ok
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render json: { message: 'xoa thanh cong' }, status: :ok
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.permit(:body)
  end

  # Kiem tra comment o dau
  def find_commentable
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id])
    elsif params[:post_id]
      @commentable = Post.find_by_id(params[:post_id])
    end
  end

  # Khong cho xoa cmt
  def correct_user
    # authorized_user
    @comment = @current_user.comments.find_by(id: params[:id])
    if @comment.nil?
      render json: { message: @comment.errors.full_messages, messages: 'Khong xoa duoc' }, status: :unauthorized
    end
  end
end
