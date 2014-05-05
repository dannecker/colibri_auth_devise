class MakeUsersEmailIndexUnique < ActiveRecord::Migration
  def up
    add_index "colibri_users", ["email"], :name => "email_idx_unique", :unique => true
  end

  def down
    remove_index "colibri_users", :name => "email_idx_unique"
  end
end
