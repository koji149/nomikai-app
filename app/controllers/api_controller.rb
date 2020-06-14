class ApiController < ApplicationController
  def success
    render status: 200, json: { status: 200, message: "Success" }
  end
end
