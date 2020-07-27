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
      return
    elsif params[:user_id] && user_signed_in?
      user_id = params[:user_id]
      @meetings = Meeting.where(user_id: user_id).order(updated_at: :desc).page(params[:page]).per(12)
      @area_name = "My募集一覧"
      @sum_meetings = @meetings.length
      return
    else
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(12)
      @area_name = "全募集一覧"
      @sum_meetings = @meetings.length
    end
  end

  def show
    @meeting = Meeting.find(params[:id])
    if params.has_key?(:detail)
      render "detail"
      return
    end
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
      respond_to do |format|
        # format.jsとして、flashメッセージはブロック内に記述します 
        format.js { flash.now[:success] = "投稿を更新しました。" } 
      end
    else
      render action: :edit
    end
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    unless params.has_key?(:status)
      render "destroyconfirm"
      return
    else
      if @meeting.destroy
        @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(12)
        @sum_meetings = @meetings.length

        respond_to do |format|
          # format.jsとして、flashメッセージはブロック内に記述します 
          format.js { flash.now[:success] = "投稿を削除しました。" } 
        end

      else
        render action: :index
      end
    end
  end

  private

    def creat_params
      params.require(:meeting).permit(:area, :date, :time, :bar, :url, :explain, :image).merge(user_id: current_user.id)
    end

    def authenticate
      unless user_signed_in?
        respond_to do |format|
          flash[:error] = "ログインが必要です。"
          format.js { render ajax_redirect_to(new_user_session_path) }
        end 
      end
    end
end
