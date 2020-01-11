class ChangePlatformColName < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :platform, :author
  end
end
