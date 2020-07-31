class AddLegalStateReferencesToDeal < ActiveRecord::Migration[6.0]
  def change
    add_reference :deals, :legal_state, null: false, foreign_key: true
  end
end
