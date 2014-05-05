require 'spec_helper'

describe Colibri::UsersController do
  let(:admin_user) { create(:user) }
  let(:user) { create(:user) }
  let(:role) { create(:role) }

  before do
    controller.stub colibri_current_user: user
  end

  context '#create' do
    it 'create a new user' do
      colibri_post :create, { user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(assigns[:user].new_record?).to be_false
    end
  end

  context '#update' do
    context 'when updating own account' do
      it 'perform update' do
        colibri_put :update, { user: { email: 'mynew@email-address.com' } }
        expect(assigns[:user].email).to eq 'mynew@email-address.com'
        expect(response).to redirect_to colibri.account_url(only_path: true)
      end
    end

    it 'does not update roles' do
      colibri_put :update, user: { colibri_role_ids: [role.id] }
      expect(assigns[:user].colibri_roles).to_not include role
    end
  end
end
