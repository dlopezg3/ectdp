class CreateLegalStates < ActiveRecord::Migration[6.0]
  def change
    create_table :legal_states do |t|
      t.string :name
      t.string :board_tid

      t.timestamps
    end
  end
end
