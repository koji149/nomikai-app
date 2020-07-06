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
    @user.update(params.require(:user).permit(:image, :name, :gender, :university, :comment, :twitter, :instagram, :other_link))# POINT
    if image = params[:user][:image]
      @comment.image.attach(image)
    end
    if video = params[:user][:video]
      @comment.image.attach(video)
    end
    redirect_to @user
  end
  private

    def set_user
      @user = User.find(params[:id])
    end
end
