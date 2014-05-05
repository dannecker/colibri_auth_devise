class Colibri::UsersController < Colibri::StoreController
  ssl_required
  skip_before_filter :set_current_order, :only => :show
  prepend_before_filter :load_object, :only => [:show, :edit, :update]
  prepend_before_filter :authorize_actions, :only => :new

  include Colibri::Core::ControllerHelpers

  def show
    @orders = @user.orders.complete.order('completed_at desc')
  end

  def create
    @user = Colibri::User.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        user = Colibri::User.reset_password_by_token(params[:user])
        sign_in(@user, :event => :authentication, :bypass => !Colibri::Auth::Config[:signout_after_password_change])
      end
      redirect_to colibri.account_url, :notice => Colibri.t(:account_updated)
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(Colibri::PermittedAttributes.user_attributes)
    end

    def load_object
      @user ||= colibri_current_user
      authorize! params[:action].to_sym, @user
    end

    def authorize_actions
      authorize! params[:action].to_sym, Colibri::User.new
    end

    def accurate_title
      Colibri.t(:my_account)
    end
end
