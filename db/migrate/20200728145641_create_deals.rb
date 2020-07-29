class CreateDeals < ActiveRecord::Migration[6.0]
  def change
    create_table :deals do |t|
      t.bigint :ecid
      t.string :legal_state
      t.date :legal_state_date
      t.bigint :total_amount
      t.string :credit_entity
      t.string :subsidy_entity
      t.string :proyect_name
      t.string :proyect_stage
      t.string :proyect_apple
      t.string :land_plot
      t.bigint :mortgage_amount
      t.string :city
      t.bigint :subsidy_amount

      t.timestamps
    end
  end
end
