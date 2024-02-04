class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create 
    @post = Post.includes(comments: :user).find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save 
      redirect_to @post, notice: 'Комментарий успешно добавлен'
    else
      redirect_to post_path(@post), notice: 'Введите текст комментария'
    end
  end

  def show
    @post = Post.includes(comments: :user).find(params[:id])
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end
  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

  def authenticate_user!
    unless current_user
      flash[:alert] = "Вам нужно авторизироваться чтобы оставить комментарий"
      redirect_to root_path
    end
  end
end
