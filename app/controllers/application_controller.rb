class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  respond_to :html, :json, :safecast_api_v1_json

  before_filter :cors_set_access_control_headers
  skip_before_filter :verify_authenticity_token
  if !Rails.env.production?
    skip_after_filter :intercom_rails_auto_include
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end


  def index
    cors_set_access_control_headers
    result = { }
    respond_with @result = @doc
  end

  def options
    cors_set_access_control_headers
    render :text => '', :content_type => 'application/json'
  end

protected

  def rescue_action(env)
    respond_to do |wants|
      wants.json { render :json => "Error", :status => 500 }
    end
  end

  def cors_set_access_control_headers
    return unless request.env['HTTP_ACCEPT'].eql? 'application/json'
    if current_user
      host = request.env['HTTP_ORIGIN']
    else
      host = request.env['HTTP_ORIGIN']
      unless /safecast.org$/.match host
        host = 'safecast.org'
      end
    end
    headers['Access-Control-Allow-Origin'] = host
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = '*, X-Requested-With'
    headers['Access-Control-Max-Age'] = '100000'
  end

  def require_moderator
    unless user_signed_in? and current_user.moderator?
      set_flash_message(:alert, 'access_denied')
      redirect_to root_path
    end
  end

  def set_locale
    if user_signed_in? && current_user.default_locale.present?
      I18n.locale = current_user.default_locale
    else
      I18n.locale = params[:locale] || I18n.default_locale
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  private

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

end
