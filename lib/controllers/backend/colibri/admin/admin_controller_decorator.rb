Colibri::Admin::BaseController.class_eval do

  # Redirect as appropriate when an access request fails.  The default action is to redirect to the login screen.
  # Override this method in your controllers if you want to have special behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might simply close itself.
  def unauthorized
    if try_colibri_current_user
      flash[:error] = Colibri.t(:authorization_failure)
      redirect_to colibri.admin_unauthorized_path
    else
      store_location
      redirect_to colibri.admin_login_path
    end
  end

  protected

    def model_class
      const_name = controller_name.classify
      if Colibri.const_defined?(const_name)
        return "Colibri::#{const_name}".constantize
      end
      nil
    end

end
