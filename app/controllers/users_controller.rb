class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]

  def show
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    @user.update params.require(:user).permit(:name, :sex) # POINT
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
