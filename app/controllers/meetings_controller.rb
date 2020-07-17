class MeetingsController < ApplicationController

  before_action :authenticate

  def index
    @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
    @sum_meetings = @meetings.length
  end

  def show
      @meeting = Meeting.find(params[:id])
    unless params.has_key?(:user)
      render "join"
      return
    else
      @user_twitter = User.find(params[:user])
      user_name = @user_twitter.username
      date = @meeting.date.strftime("%Y年 %m月 %d日")
      time = @meeting.time.strftime("%H:%M:%S")
      text = "アフターキャンパスです。\n「https://twitter.com/#{user_name}」さんから参加リクエストが届きました！\n「https://twitter.com/#{user_name}」さんはあなたの返事を待っています。早速連絡しましょう！\n\n募集情報------\n
      募集日時：\n#{date}#{time}\n
      お店：#{@meeting.bar}\n
      お店のURL：#{@meeting.url}
      "
      TwitterService.new(@meeting.user.uid, text).call
      return
    end
  end
  
  def new
    @meeting = Meeting.new
  end
  
  def create
    @meeting = Meeting.new(creat_params)
    if @meeting.save
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
      params.require(:meeting).permit(:area, :date, :time, :bar, :url, :explain, :image).merge(user_id: current_user.id)
    end

    def authenticate
      redirect_to new_user_session_path unless user_signed_in?
      flash[:danger] = "ログインをしてください"
    end

end
