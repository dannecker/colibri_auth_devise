class Colibri::Admin::UserPasswordsController < Devise::PasswordsController
  helper 'colibri/base'

  include Colibri::Core::ControllerHelpers::Auth
  include Colibri::Core::ControllerHelpers::Common
  include Colibri::Core::ControllerHelpers::SSL
  include Colibri::Core::ControllerHelpers::Store

  helper 'colibri/admin/navigation'
  helper 'colibri/admin/tables'
  layout 'colibri/layouts/admin'

  ssl_required

  # Overridden due to bug in Devise.
  #   respond_with resource, :location => new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, :location => colibri.login_path
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, :location => colibri.admin_login_path
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes colibri/colibri#2190.
  def update
    if params[:colibri_user][:password].blank?
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end

end
