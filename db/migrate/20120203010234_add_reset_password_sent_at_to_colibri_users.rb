class AddResetPasswordSentAtToColibriUsers < ActiveRecord::Migration
  def change
    Colibri::User.reset_column_information
    unless Colibri::User.column_names.include?("reset_password_sent_at")
      add_column :colibri_users, :reset_password_sent_at, :datetime
    end
  end
end
