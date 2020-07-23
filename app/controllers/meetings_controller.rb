class MeetingsController < ApplicationController

  include AjaxHelper 

  layout 'meeting'

  before_action :authenticate, except: [:index]

  def index
    if params[:latitude].present? && params[:longitude].present?
      current_lat = params[:latitude]
      current_lng = params[:longitude]
      @meetings = Meeting.all.within(3, origin: [current_lat, current_lng]).order(updated_at: :desc).page(params[:page]).per(12)
      @sum_meetings = @meetings.length
      @area_name = "近くの募集一覧"
    elsif params[:area]
      area_num = params[:area]
      
      if area_num == "11" 
          @area_name = "埼玉の募集一覧"
        elsif area_num == "13"
          @area_name = "東京の募集一覧"
        elsif area_num == "27"
          @area_name = "大阪の募集一覧"
        elsif area_num == "40"
          @area_name = "福岡の募集一覧"
        else
      end
      @meetings = Meeting.where(area: area_num).order(updated_at: :desc).page(params[:page]).per(12)
      @sum_meetings = @meetings.length
    else
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(12)
      @area_name = "全募集一覧"
      @sum_meetings = @meetings.length
    end
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
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(12)
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
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(12)
      @sum_meetings = @meetings.length
      flash.now[:notice] = "更新に成功しました。"
    else
      render action: :edit
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    if @meeting.destroy
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(12)
      @sum_meetings = @meetings.length
      flash.now[:notice] = "削除に成功しました。"
    else
      render action: :index
    end
  end

  private

    def creat_params
      params.require(:meeting).permit(:area, :date, :time, :bar, :url, :explain, :image).merge(user_id: current_user.id)
    end

    def authenticate
      unless user_signed_in?
        respond_to do |format|
          format.js { render ajax_redirect_to(new_user_session_path) }
          flash.now[:alert] = "ログインが必要です。"
        end 
      end
    end
end
