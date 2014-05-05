module Colibri
  module AuthenticationHelpers
    def self.included(receiver)
      receiver.send :helper_method, :colibri_current_user
      receiver.send :helper_method, :colibri_login_path
      receiver.send :helper_method, :colibri_signup_path
      receiver.send :helper_method, :colibri_logout_path
    end

    def colibri_current_user
      current_colibri_user
    end

    def colibri_login_path
      colibri.login_path
    end

    def colibri_signup_path
      colibri.signup_path
    end

    def colibri_logout_path
      colibri.logout_path
    end
  end
end
