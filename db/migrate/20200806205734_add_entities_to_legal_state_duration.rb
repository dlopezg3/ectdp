class AddEntitiesToLegalStateDuration < ActiveRecord::Migration[6.0]
  def change
    add_column :legal_state_durations, :credit_entity, :string
    add_column :legal_state_durations, :subsidy_entity, :string
  end
end
