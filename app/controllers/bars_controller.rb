class BarsController < ApplicationController
  require 'httpclient'
  require 'json'


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
    elsif params[:latitude]
      @lat = params[:latitude]
      @lng = params[:longitude]
      @range = 1
      @area_name = "あなたのちかく"
      @category = "あなたのちかく"
      @genre = "G001,G002,G012"
      @budget = "B001,B002"
      @wifi = 0
      @non_smoking = 1
      @explain ="あなたのちかく"
      @free_drink = 1

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
    else
      @area_name = params[:area_name]
      @category = params[:category]
      @genre = "G001,G002,G012"
      @m_area = params[:m_area]
      @budget = "B001,B002"
      @wifi = 0
      @non_smoking = 1
      @explain = params[:explain]
      @free_drink = 1
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
    end

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
    @key = ENV['GKEY']
    @url = "https://maps.googleapis.com/maps/api/js?key=#{@key}"
  end
  private

    def params_exist?
      unless params[:category] && params[:explain]
      redirect_to root_path 
      end
    end
end
