class ErrorsController < ApplicationController

  layout 'application'

  unless Rails.env.development?
  rescue_from StandardError, with: :error500
  rescue_from ActionController::RoutingError, with: :error404
  rescue_from ActiveRecord::RecordNotFound, with: :error404
  end

  def error404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    render template: 'errors/error404', status: 404
  end

  def error500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render template: 'errors/error500', status: 500
  end

  def show
    raise
  end
end
