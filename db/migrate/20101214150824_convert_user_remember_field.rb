class ConvertUserRememberField < ActiveRecord::Migration
  def up
    remove_column :colibri_users, :remember_created_at
    add_column :colibri_users, :remember_created_at, :datetime
  end

  def down
    remove_column :colibri_users, :remember_created_at
    add_column :colibri_users, :remember_created_at, :string
  end
end
