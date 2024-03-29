require 'colibri/core/validators/email'
Colibri::CheckoutController.class_eval do
  before_filter :check_authorization
  before_filter :check_registration, :except => [:registration, :update_registration]

  def registration
    @user = Colibri::User.new
  end

  def update_registration
    current_order.update_column(:email, params[:order][:email])
    if EmailValidator.new(:attributes => current_order.attributes).valid?(current_order.email)
      redirect_to checkout_path
    else
      flash[:registration_error] = t(:email_is_invalid, :scope => [:errors, :messages])
      @user = Colibri::User.new
      render 'registration'
    end
  end

  private
    def order_params
      if params[:order]
        params.require(:order).permit(:email)
      else
        {}
      end
    end

    def skip_state_validation?
      %w(registration update_registration).include?(params[:action])
    end

    def check_authorization
      authorize!(:edit, current_order, session[:access_token])
    end

    # Introduces a registration step whenever the +registration_step+ preference is true.
    def check_registration
      return unless Colibri::Auth::Config[:registration_step]
      return if colibri_current_user or current_order.email
      store_location
      redirect_to colibri.checkout_registration_path
    end

    # Overrides the equivalent method defined in Colibri::Core.  This variation of the method will ensure that users
    # are redirected to the tokenized order url unless authenticated as a registered user.
    def completion_route
      return order_path(@order) if colibri_current_user
      colibri.token_order_path(@order, @order.token)
    end
end
