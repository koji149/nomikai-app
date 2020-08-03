class BarsController < ApplicationController
  require 'httpclient'
  require 'json'

  layout 'bar'

  before_action :params_exist?, only: [:getposition]

  def top
    @top_description = "「どこ行く？」池袋、新宿、新大久保・大久保、高田馬場、渋谷、秋葉原、上野...予算3000円で楽しめる居酒屋、ダイニングバー、バーを紹介"
  end

  def getposition
    uri = ENV['URI']
    key = ENV['KEY']

      @range = 5
      @genre = "G001,G002,G012"
      @wifi = 0
      @non_smoking = 0
      @lat = params[:latitude]
      @lng = params[:longitude]

    data = {
      key: key,
      lat: @lat,
      lng: @lng,
      range: @range,
      genre: @genre,
      wifi: @wifi,
      non_smoking: @non_smoking,
      format: "json",
      count: 100
    }
    client = HTTPClient.new
    request =  client.get('https://webservice.recruit.co.jp/hotpepper/gourmet/v1/', data)
    @response = JSON.parse(request.body)
    @items = @response["results"]["shop"]
    @sum_items = @response["results"]["shop"].length
    @first_item = @response["results"]["shop"].first
    if @items.empty?
      @explain = "近くのお店が見つかりませんでした。。。\nトップページから地域を選択するか、場所を移動して再実行してください"
    else
      @items = Kaminari.paginate_array(@items).page(params[:page]).per(12)
    end

  end

  def privacy
    @host = request.host

  end

  private

    def params_exist?
      unless params[:category] && params[:explain]
      redirect_to root_path 
      end
    end
end
