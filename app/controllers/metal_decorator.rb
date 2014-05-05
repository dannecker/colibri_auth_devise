# For the API
ActionController::Metal.class_eval do
  def colibri_current_user
    @colibri_current_user ||= env['warden'].user
  end
end
