class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
  end

  def index
    @posts = Post.all.order("created_at DESC")
  end

  def new
    @post = Post.new
  end

  def create
    # require以降の意味：　postsデータベースのcontent, place, user_id以外の項目を更新しない
    # mergeとは追加の設定をするメソッド、入力欄にない項目を取り扱うときに使う
    @post = Post.new(params.require(:post).permit(:content, :place, :user_id).merge(:user_id => current_user.id))
    @user = User.find(@post.user_id)
    if @post.save

    else
      # 登録に失敗した場合は、一覧画面に遷移しない
      render("/posts/new")
    end
  end

  def edit
    @post = Post.find(params[:id])

    if @post.user_id != current_user.id
      redirect_to "/posts"
      flash[:alert] = "無効なユーザー"
    end
  end

  def update
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    if @post.user_id == current_user.id
      @post.update(params.require(:post).permit(:content, :place))
    else
      redirect_to "/posts"
      flash[:alert] = "無効なユーザー"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @user = User.find(@post.user_id)
    if @post.user_id == current_user.id
      @post.destroy
    else
      redirect_to "/posts"
      flash[:alert] = "無効なユーザー"
    end
  end

end
