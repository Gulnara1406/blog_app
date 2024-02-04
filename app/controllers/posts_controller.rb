class PostsController < ApplicationController
  before_action :set_post, only: [:update, :show, :destroy, :edit]
  before_action :authenticate_user!, only:[:create]
  def create
    @post = current_user.posts.build(post_params)
    @post.user = current_user
    @post.user_id = current_user.id if current_user 

    if @post.save
      redirect_to post_path(@post), notice: "Пост опубликован!"
    else
      flash[:alert] = "Добавьте текст для публикации"
      redirect_to new_post_path
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      @post.update(post_params)
      redirect_to post_path(@post), notice: "Публикация обновлена!"
    end
    
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.user_id == current_user.id 
      @post.destroy
      redirect_to posts_path, notice: "Публикация удалена!"
    else
      redirect_to posts_path, notice: "Вы не можете удалить чужую публикацию"
    end
  end

  def show
    @post = Post.find(params[:id])

    unless session[:viewed_posts]&.include?(@post.id)
      @post.increment!(:views)
      session[:viewed_posts] ||= []
      session[:viewed_posts] << @post.id
    end
  end

  def index
    @post = Post.new
    @posts = Post.includes(:user).all
  end

  def new
    @post = Post.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authenticate_user!
    unless current_user
      flash[:alert] = "Необходимо авторизоваться для создания публикации"
      redirect_to root_path
    end
  end
end
