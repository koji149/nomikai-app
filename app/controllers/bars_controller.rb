class BarsController < ApplicationController
  require 'httpclient'
  require 'json'

  before_action :params_exist?, only: [:index, :getposition]

  def top
    @top_description = "「どこ行く？」池袋、新宿、新大久保・大久保、高田馬場、渋谷、秋葉原、上野...予算3000円で楽しめる居酒屋、ダイニングバー、バーを紹介"
  end

  def index
    uri = ENV['URI']
    key = ENV['KEY']

    if params[:genre]
      @area_name = params[:area_name]
      @category = params[:category]
      @genre = params[:genre]
      @m_area = params[:m_area]
      @budget = params[:budget]
      @wifi = params[:wifi]
      @non_smoking = params[:non_smoking]
      @explain = params[:explain]
      @free_drink = params[:free_drink]
    else
      @area_name = params[:area_name]
      @category = params[:category]
      @genre = "G001,G002,G012"
      @m_area = params[:m_area]
      @budget = "B001,B002"
      @wifi = 0
      @non_smoking = 0
      @explain = params[:explain]
      @free_drink = 1
    end

    data = {
      key: key,
      free_drink: @free_drink,
      budget: @budget,
      genre: @genre,
      middle_area: @m_area,
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
    @index_description = "#{@first_item["name"]}、予算#{@first_item["budget"]["name"]}、飲み放題#{@first_item["free_drink"].slice(0,2)}、#{@first_item["mobile_access"]}...他#{@sum_items}件"
    @items = Kaminari.paginate_array(@items).page(params[:page]).per(12)
  end

  def getposition
    uri = ENV['URI']
    key = ENV['KEY']
    if params["latitude"] == true && params["longitude"] == true
      @lat = params["latitude"]
      @lng = params["longitude"]
    else
      @lat = @lat
      @lng = @lng
    end

    if params[:genre]
      @range = 2
      @area_name = params[:area_name]
      @category = params[:category]
      @genre = params[:genre]
      @budget = params[:budget]
      @wifi = params[:wifi]
      @non_smoking = params[:non_smoking]
      @explain = params[:explain]
      @free_drink = params[:free_drink]
    else
      @range = 2
      @area_name = params[:area_name]
      @category = params[:category]
      @genre = "G001,G002,G012"
      @budget = "B001,B002"
      @wifi = 0
      @non_smoking = 0
      @explain = params[:explain]
      @free_drink = 1
      @lat = params["latitude"]
    　@lng = params["longitude"]
    end

    data = {
      key: key,
      lat: @lat,
      lng: @lng,
      range: @range,
      free_drink: @free_drink,
      budget: @budget,
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
      @index_description = "#{@first_item["name"]}、予算#{@first_item["budget"]["name"]}、飲み放題#{@first_item["free_drink"].slice(0,2)}、#{@first_item["mobile_access"]}...他#{@sum_items}件"
      @items = Kaminari.paginate_array(@items).page(params[:page]).per(12)
    end
  end

  private

    def params_exist?
      unless params[:category] && params[:explain]
      redirect_to root_path 
      end
    end
end
