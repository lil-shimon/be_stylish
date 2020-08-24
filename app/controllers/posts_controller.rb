class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to post_path(@post), notice: "successfully created"
    else
      render :new 
  end
  end

  def show 
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id]) 
    if @post.user.id != current_user.id
      redirect_to posts_path, alert: "you cannot edit this post because you do not have rights"
    end
  end

  def update
    @post = Post.find(params[:id])
    Refile.attachment_url(@post, :image)
    if @post.update(post_params)
       redirect_to post_path(@post), notice: "sucessfully updated"
    else
      render :edit 
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to user_path(post.user), notice: "deleted that post" 
  end



  private 
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end

