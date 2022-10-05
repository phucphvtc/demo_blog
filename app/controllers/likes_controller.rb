class LikesController < ApplicationController
  before_action :find_liketable, only: :create
  before_action :authorize, only: %i[create update destroy]

  # def create
  #   @like = @liketable.likes.build
  #   @like.user_id = @current_user.id
  #   @like.update(liked: @like.liked + 1)
  #   if @like.save
  #     render json: { messages: 'Liked' }
  #   else
  #     render json: @like.errors.full_messages, status: 422
  #   end
  #   # render json: @like
  # end

  # def destroy
  #   @like = Like.find_by(params[:id])
  #   @like.destroy

  #   render json: { messages: 'unlike' }
  # end

  def create
    @like = @liketable.likes
    if @like.count == 0
      @like = @liketable.likes.build
      @like.user_id = @current_user.id
      @like.update(liked: @like.liked + 1)
      @like.save
      render json: { messages: 'Liked' }
    else
      @like = Like.find_by(params[:id])
      @like.destroy
      render json: { message: 'Unlike' }
    end
    #   if @liketable.likes.count == 0
    #     @like = @liketable.likes.build
    #     @like.user_id = @current_user.id
    #     @like.update(liked: @like.liked + 1)
    #     @like.save
    #     render json: { messages: 'Liked' }
    #   else
    #     @message = 'Unlike'
    #   end

    #   unless @message
    #     @like = Like.find_by(params[:id])
    #     @like.destroy
    #     render json: { messages: 'unlike' }
    #   end
  end

  private

  def like_params
    params.permit(:liked)
  end

  def find_liketable
    if params[:comment_id]
      @liketable = Comment.find_by_id(params[:comment_id])
    elsif params[:post_id]
      @liketable = Post.find_by_id(params[:post_id])
    end
  end
end
