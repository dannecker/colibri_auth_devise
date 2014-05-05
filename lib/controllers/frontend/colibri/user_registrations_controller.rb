class Colibri::UserRegistrationsController < Devise::RegistrationsController
  helper 'colibri/base', 'colibri/store'

  if Colibri::Auth::Engine.dash_available?
    helper 'colibri/analytics'
  end

  include Colibri::Core::ControllerHelpers::Auth
  include Colibri::Core::ControllerHelpers::Common
  include Colibri::Core::ControllerHelpers::Order
  include Colibri::Core::ControllerHelpers::SSL
  include Colibri::Core::ControllerHelpers::Store

  ssl_required
  before_filter :check_permissions, :only => [:edit, :update]
  skip_before_filter :require_no_authentication

  # GET /resource/sign_up
  def new
    super
    @user = resource
  end

  # POST /resource/sign_up
  def create
    @user = build_resource(colibri_user_params)
    if resource.save
      set_flash_message(:notice, :signed_up)
      sign_in(:colibri_user, @user)
      session[:colibri_user_signup] = true
      associate_user
      sign_in_and_redirect(:colibri_user, @user)
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected
    def check_permissions
      authorize!(:create, resource)
    end

  private
    def colibri_user_params
      params.require(:colibri_user).permit(Colibri::PermittedAttributes.user_attributes)
    end
end
