class AddListTidToLegalStates < ActiveRecord::Migration[6.0]
  def change
    add_column :legal_states, :list_tid, :string
  end
end
