require 'spec_helper'

describe Colibri::CheckoutController do
  let(:order) { create(:order_with_totals, email: nil, user: nil) }
  let(:user)  { mock_model Colibri::User, last_incomplete_colibri_order: nil, has_colibri_role?: true, colibri_api_key: 'fake' }
  let(:token) { 'some_token' }

  before do
    controller.stub current_order: order
    order.stub confirmation_required?: true
  end

  context '#edit' do
    context 'when registration step enabled' do
      before do
        controller.stub :check_authorization
        Colibri::Auth::Config.set(registration_step: true)
      end

      context 'when authenticated as registered user' do
        before { controller.stub colibri_current_user: user }

        it 'proceed to the first checkout step' do
          user.should_receive(:ship_address)

          colibri_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'redirect to registration step' do
          colibri_get :edit, { state: 'address' }
          expect(response).to redirect_to colibri.checkout_registration_path
        end
      end
    end

    context 'when registration step disabled' do
      before do
        Colibri::Auth::Config.set(registration_step: false)
        controller.stub :check_authorization
      end

      context 'when authenticated as registered' do
        before { controller.stub colibri_current_user: user }

        it 'proceed to the first checkout step' do
          user.should_receive(:ship_address)

          colibri_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end

      context 'when authenticated as guest' do
        it 'proceed to the first checkout step' do
          colibri_get :edit, { state: 'address' }
          expect(response).to render_template :edit
        end
      end
    end
  end

  context '#update' do
    context 'when in the confirm state' do
      before do
        order.update_column(:email, 'colibri@example.com')
        order.update_column(:state, 'confirm')

        # So that the order can transition to complete successfully
        order.stub payment_required?: false
      end

      context 'with a token' do
        before do
          order.stub token: 'ABC'
        end

        it 'redirect to the tokenized order view' do
          colibri_post :update, { state: 'confirm' }, { access_token: 'ABC' }
          expect(response).to redirect_to colibri.token_order_path(order, 'ABC')
          expect(flash.notice).to eq Colibri.t(:order_processed_successfully)
        end
      end

      context 'with a registered user' do
        before do
          controller.stub colibri_current_user: user
          order.stub user: user
          order.stub token: nil
        end

        it 'redirect to the standard order view' do
          colibri_post :update, { :state => 'confirm' }
          expect(response).to redirect_to colibri.order_path(order)
        end
      end
    end
  end

  context '#registration' do
    it 'does not check registration' do
      controller.stub :check_authorization
      controller.should_not_receive :check_registration
      colibri_get :registration
    end

    it 'check if the user is authorized for :edit' do
      controller.should_receive(:authorize!).with(:edit, order, token)
      colibri_get :registration, {}, { access_token: token }
    end
  end

  context '#update_registration' do
    let(:user) { user = mock_model Colibri::User }

    it 'does not check registration' do
      controller.stub :check_authorization
      order.stub update_attributes: true
      controller.should_not_receive :check_registration
      colibri_put :update_registration, { order: { } }
    end

    it 'render the registration view if unable to save' do
      controller.stub :check_authorization
      colibri_put :update_registration, { order: { email: 'invalid' } }
      expect(flash[:registration_error]).to eq I18n.t(:email_is_invalid, scope: [:errors, :messages])
      expect(response).to render_template :registration
    end

    it 'redirect to the checkout_path after saving' do
      order.stub update_attributes: true
      controller.stub :check_authorization
      colibri_put :update_registration, { order: { email: 'jobs@colibricommerce.com' } }
      expect(response).to redirect_to colibri.checkout_path
    end

    it 'check if the user is authorized for :edit' do
      order.stub update_attributes: true
      controller.should_receive(:authorize!).with(:edit, order, token)
      colibri_put :update_registration, { order: { email: 'jobs@colibricommerce.com' } }, { access_token: token }
    end
  end
end
