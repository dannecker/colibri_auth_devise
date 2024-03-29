require 'spec_helper'

feature 'Payment methods' do
  background do
    sign_in_as! create(:admin_user)

    visit colibri.admin_path
    click_link 'Configuration'
  end

  # Regression test for #5
  scenario 'can dismiss the banner' do
    Colibri::User.any_instance.stub(dismissed_banner?: false)
    Colibri::PaymentMethod.stub(:production).and_return(payment_methods = [double])
    payment_methods.stub(:where).and_return([])
    click_link 'Payment Methods'
  end
end
