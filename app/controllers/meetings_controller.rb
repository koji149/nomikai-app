require 'uri'

class MeetingsController < ApplicationController

  before_action :authenticate

  def index
    if params[:latitude].present? && params[:longitude].present?
      current_lat = params[:latitude]
      current_lng = params[:longitude]

      #半径500m以内の募集を現在地から近い順に12件取り出す
      sql = <<-"EOS"
      SELECT
        id, bar, lat, lng,
        (
          6371 * acos(
            cos(radians(#{current_lat}))
            * cos(radians(lat))
            * cos(radians(lng) - radians(#{current_lng}))
            + sin(radians(#{current_lat}))
            * sin(radians(lat))
          )
        ) AS distance
      FROM
        spots
      HAVING
        distance <= 10
      ORDER BY
        distance
      LIMIT 12
      ;
      EOS
      
      # sqlを実行
      @meetings = ActiveRecord::Base.connection.select_all(sql)
      @sum_meetings = @meetings.length
      @area_name = "近くの募集一覧"
    end

    if params[:area]
      area_num = params[:area]
      case area_num
        when 11 then
          @area_name = "埼玉の募集一覧"
        when 13 then
          @area_name = "東京の募集一覧"
        when 27 then
          @area_name = "大阪の募集一覧"
        when 40 then
          @area_name = "福岡の募集一覧"
      end
      @meetings = Meeting.where(area: area_num).order(updated_at: :desc).page(params[:page]).per(10)
    else
      @meetings = Meeting.all.order(updated_at: :desc).page(params[:page]).per(10)
      @area_name = "全募集一覧"
    end
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

    if params.require(:meeting).permit(:bar)
    address = params.require(:meeting).permit(:bar)
    address = address.gsub(" ", "")
    geo_url = ENV['GEO_URL']
    geo_key = ENV['GEO_KEY']

    geo_data = {
      address: address,
      key: geo_key
    }

    geo_client = HTTPClient.new
    geo_request = geo_client.get(geo_url, geo_data)
    @geo_response = JSON.parse(geo_request.body)
    p @geo_response
      if latitude.present? && longitude.present?
        latitude = @geo_response["results"][0]["geometry"]["location"]["lat"]
        longitude = @geo_response["results"][0]["geometry"]["location"]["lng"]
        @meeting.lat = latitude
        @meeting.lng = longitude
      end
    else
      @meeting.lat = 3
      @meeting.lng = 3
    end

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

    def authenticate
      redirect_to new_user_session_path unless user_signed_in?
      flash[:danger] = "ログインをしてください"
    end

end
