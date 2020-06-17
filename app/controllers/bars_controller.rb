class BarsController < ApplicationController
  require 'httpclient'
  require 'json'

  before_action :params_exist?, only: [:index]


  def top

  end
  def index

    p params
    uri = ENV['uri']
    key = ENV['key']

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
      @wifi = 1
      @non_smoking = 1
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
      count: 50
    }

    client = HTTPClient.new
    request =  client.get(uri,data)
    @response = JSON.parse(request.body)
    @items = @response["results"]["shop"]
    @items =  Kaminari.paginate_array(@items).page(params[:page]).per(12)
  end

  private

    def params_exist?
      unless params[:category] && params[:explain]
      redirect_to root_path 
      end
    end
end
