class AddTrelloFlagToDeals < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :trello_flag, :boolean
  end
end
