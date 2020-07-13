class MeetingsController < ApplicationController

  before_action :authenticate

  def index
    @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
    @sum_meetings = @meetings.length
  end

  def show
    @meeting = Meeting.find(params[:id])

  end
  def new
    @meeting = Meeting.new
  end
  
  def create
    @meeting = Meeting.new(creat_params)
    @meeting.user_id = current_user.id
    unless params[:image]
      @meeting.image.attach("bar1839361_640.jpg")
    end
    if @meeting.save
      redirect_to meetings_path
    else
      flash.now[:danger] = "募集の作成に失敗しました"
      render 'meetings/index' # failed_pathに遷移する
    end
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    @meeting = Meeting.find(params[:id])
    
    if @meeting.update(creat_params)
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
      @sum_meetings = @meetings.length
    else
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    if @meeting.destroy
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
      @sum_meetings = @meetings.length
      flash.now[:success] = "削除に成功しました"
    else
      flash.now[:danger] = "削除に失敗しました"
    end
  end

  private
    def creat_params
      params.require(:meeting).permit(:area, :date, :time, :bar, :url, :explain, :image)
    end

    def authenticate
      redirect_to new_user_session_path unless user_signed_in?
      flash[:danger] = "ログインをしてください"
    end
end
