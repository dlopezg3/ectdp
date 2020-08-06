class AddCardTidToDeal < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :card_tid, :string
  end
end
