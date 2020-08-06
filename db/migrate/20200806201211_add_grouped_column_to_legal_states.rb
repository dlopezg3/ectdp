class AddGroupedColumnToLegalStates < ActiveRecord::Migration[6.0]
  def change
    add_column :legal_states, :grouped, :boolean, default: false
  end
end
