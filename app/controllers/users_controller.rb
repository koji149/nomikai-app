class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])

    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(creat_params)# POINT
      flash[:success] = "修正を反映しました"
      redirect_to @user
    else
      flash.now[:danger] = "更新に失敗しました"
      render 'users/edit'
    end
  end
  private

    def set_user
      @user = User.find(params[:id])
    end

    def creat_params
      params.require(:user).permit(:name, :gender, :university, :comment, :twitter, :instagram, :other_link, :image)
    end
end
