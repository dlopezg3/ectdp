class AddContactInfoToDeal < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :client_name, :string
    add_column :deals, :client_phone, :string
  end
end
