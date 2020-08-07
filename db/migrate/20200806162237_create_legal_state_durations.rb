class CreateLegalStateDurations < ActiveRecord::Migration[6.0]
  def change
    create_table :legal_state_durations do |t|
      t.integer :days
      t.references :legal_state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
