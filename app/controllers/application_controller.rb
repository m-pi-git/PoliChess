class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters,
                if: :devise_controller?


                  protected
                  def configure_permitted_parameters
                    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :first_name, :last_name, :faculty])
                    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :first_name, :last_name, :faculty])
                  end

  protect_from_forgery with: :exception, prepend: true
end
