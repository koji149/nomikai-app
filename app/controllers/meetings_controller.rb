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
      time = @meeting.time.strftime("%H時 %M分")
      text = "アフターキャンパスです。\n「https://twitter.com/#{user_name}」さんから参加リクエストが届きました！\n「https://twitter.com/#{user_name}」さんはあなたの返事を待っています。早速連絡しましょう！\n\n------募集情報------\n
      募集日時：\n#{date}　#{time}\n
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
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
    else
      render action: :new
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
      render action: :edit
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    if @meeting.destroy
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
      @sum_meetings = @meetings.length
      flash.now[:success] = "削除に成功しました"
    else
      render action: :index
    end
  end

  private
    def creat_params
      params.require(:meeting).permit(:area, :date, :time, :bar, :url, :explain, :image).merge(user_id: current_user.id)
    end
end
