class AddChangeFlagToDeals < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :change_flag, :boolean
  end
end
