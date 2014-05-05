class Colibri::Admin::UserSessionsController < Devise::SessionsController
  helper 'colibri/base'

  include Colibri::Core::ControllerHelpers::Auth
  include Colibri::Core::ControllerHelpers::Common
  include Colibri::Core::ControllerHelpers::SSL
  include Colibri::Core::ControllerHelpers::Store

  helper 'colibri/admin/navigation'
  helper 'colibri/admin/tables'
  layout 'colibri/layouts/admin'

  ssl_required :new, :create, :destroy, :update

  def create
    authenticate_colibri_user!

    if colibri_user_signed_in?
      respond_to do |format|
        format.html {
          flash[:success] = Colibri.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(colibri_current_user))
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash.now[:error] = t('devise.failure.invalid')
      render :new
    end
  end

  def authorization_failure
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
