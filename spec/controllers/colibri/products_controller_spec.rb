require 'spec_helper'

describe Colibri::ProductsController do
  let!(:product) { create(:product, available_on: 1.year.from_now) }
  let!(:user)    { mock_model(Colibri::User, colibri_api_key: 'fake', last_incomplete_colibri_order: nil) }

  it 'allows admins to view non-active products' do
    controller.stub :before_save_new_order
    controller.stub colibri_current_user: user
    user.stub has_colibri_role?: true
    colibri_get :show, id: product.to_param
    expect(response.status).to eq(200)
  end

  it 'cannot view non-active products' do
    controller.stub :before_save_new_order
    controller.stub colibri_current_user: user
    user.stub has_colibri_role?: false
    colibri_get :show, id: product.to_param
    expect(response.status).to eq(404)
  end
end
