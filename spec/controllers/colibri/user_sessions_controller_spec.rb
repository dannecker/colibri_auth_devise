require 'spec_helper'

describe Colibri::UserSessionsController do
  let(:user) { create(:user) }
  before do
    @request.env["devise.mapping"] = Devise.mappings[:colibri_user]
  end

  context "#create" do

    context "using correct login information" do
      context "and html format is used" do
        it "redirects to default after signing in" do
          colibri_post :create, colibri_user: { email: user.email, password: 'secret' }
          expect(response).to redirect_to colibri.root_path
        end
      end

      context "and js format is used" do
        it "returns a json with ship and bill address" do
          colibri_post :create, colibri_user: { email: user.email, password: 'secret' }, format: 'js'
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("user")
          expect(parsed).to have_key("ship_address")
          expect(parsed).to have_key("bill_address")
        end
      end
    end

    context "using incorrect login information" do
      context "and html format is used" do
        it "renders new template again with errors" do
          colibri_post :create, colibri_user: { email: user.email, password: 'wrong' }
          expect(response).to render_template('new')
          expect(flash[:error]).to eq I18n.t('devise.failure.invalid')
        end
      end

      context "and js format is used" do
        it "returns a json with the error" do
          colibri_post :create, colibri_user: { email: user.email, password: 'wrong' }, format: 'js'
          parsed = ActiveSupport::JSON.decode(response.body)
          expect(parsed).to have_key("error")
        end
      end
    end
  end
end
