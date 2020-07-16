class ErrorsController < ApplicationController

  layout 'application'
  rescue_from ActionController::RoutingError, with: :error404
  rescue_from ActiveRecord::RecordNotFound, with: :error404
  rescue_from StandardError, with: :error500


  def error404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    render template: 'errors/404', status: 404
  end

  def error500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render template: 'errors/500', status: 500
  end

  def show; raise env["action_dispatch.exception"]; end

end
