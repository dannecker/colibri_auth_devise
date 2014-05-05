require 'spec_helper'

module Colibri
  module Admin
    describe OrdersController do
      stub_authorization!

      context '#authorize_admin' do
        it 'grant access to users with an admin role' do
          colibri_get :new
          expect(response).to redirect_to colibri.edit_admin_order_path Order.last
        end
      end
    end
  end
end
