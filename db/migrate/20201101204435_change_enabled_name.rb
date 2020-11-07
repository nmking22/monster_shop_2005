
class ChangeEnabledName < ActiveRecord::Migration[5.2]
  def change
    rename_column :merchants, :enabled, :enabled?
  end
end
