class Colibri::UserSessionsController < Devise::SessionsController
  helper 'colibri/base', 'colibri/store'
  if Colibri::Auth::Engine.dash_available?
    helper 'colibri/analytics'
  end

  include Colibri::Core::ControllerHelpers::Auth
  include Colibri::Core::ControllerHelpers::Common
  include Colibri::Core::ControllerHelpers::Order
  include Colibri::Core::ControllerHelpers::SSL
  include Colibri::Core::ControllerHelpers::Store

  ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar

  def create
    authenticate_colibri_user!

    if colibri_user_signed_in?
      respond_to do |format|
        format.html {
          flash[:success] = Colibri.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(colibri_current_user))
        }
        format.js {
          render :json => {:user => colibri_current_user,
                           :ship_address => colibri_current_user.ship_address,
                           :bill_address => colibri_current_user.bill_address}.to_json
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }
        format.js {
          render :json => { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        }
      end
    end
  end

  def nav_bar
    render :partial => 'colibri/shared/nav_bar'
  end

  private
    def accurate_title
      Colibri.t(:login)
    end

    def redirect_back_or_default(default)
      redirect_to(session["colibri_user_return_to"] || default)
      session["colibri_user_return_to"] = nil
    end
end
