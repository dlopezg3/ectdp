class AddAmountsToDeal < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :savings_amount, :bigint
    add_column :deals, :layoffs_amount, :bigint
    add_column :deals, :initial_fee_amount, :bigint
    add_column :deals, :clearance_amount, :bigint
    add_column :deals, :initial_fee_subsidy_amount, :bigint
    add_column :deals, :second_subsidy_amount, :bigint
    add_column :deals, :swap_amount, :bigint
  end
end
