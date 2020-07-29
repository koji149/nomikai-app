class ApplicationController < ActionController::Base
  before_action :redirect_root_domain
  before_action :ensure_domain
  before_action :configure_permitted_parameters, if: :devise_controller?
  add_flash_types :success, :info, :warning, :danger


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name]) # 新規登録時(sign_up時)にnameというキーのパラメーターを追加で許可する
  end


  #def routing_error
    #raise ActionController::RoutingError, params[:path]
  #end

  def after_sign_in_path_for(resource)
    flash[:success]
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    flash[:success]
    root_path
  end

  def after_sign_up_path_for(resource)
    flash[:success]
    user_path(resource)
  end

  private

  def redirect_root_domain
    return unless request.host === 'after-campus.com'
    redirect_to("#{request.protocol}www.after-campus.com#{request.fullpath}", status: 301)
  end

  def ensure_domain
    return unless /\.herokuapp.com/ =~ request.host

    FQDN = 'www.after-campus.com'
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{FQDN}#{port}#{request.path}", status: :moved_permanently
  end

  def _render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '404 error' }, status: :not_found
    else
      render 'errors/404', status: :not_found
    end
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: '500 error' }, status: :internal_server_error
    else
      render 'errors/500', status: :internal_server_error
    end
  end

end
