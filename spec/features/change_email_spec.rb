require 'spec_helper'

feature 'Change email' do

  background do
    user = create(:user)
    visit colibri.root_path
    click_link 'Login'

    fill_in 'colibri_user[email]', with: user.email
    fill_in 'colibri_user[password]', with: 'secret'
    click_button 'Login'

    visit colibri.edit_account_path
  end

  scenario 'work with correct password' do
    fill_in 'user_email', with: 'tests@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Update'

    expect(page).to have_text 'Account updated'
    expect(page).to have_text 'tests@example.com'
  end
end
