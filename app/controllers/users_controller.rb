class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]

  def show
    @user = User.find(params[:id])
  end

  def edit
    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(params.require(:user).permit(:image, :name, :gender, :university, :comment, :twitter, :instagram, :other_link))# POINT
      if image = params[:user][:image]
        @comment.image.attach(image)
      end
      if video = params[:user][:video]
        @comment.image.attach(video)
      end
      flash[:success] = "修正を反映しました"
      redirect_to @user
    else
      flash.now[:danger] = "更新に失敗しました。"
      render 'users/edit'
    end
  end
  private

    def set_user
      @user = User.find(params[:id])
    end
end
