class AddContactPhoneTwoToDeal < ActiveRecord::Migration[6.0]
  def change
    add_column :deals, :client_phone_two, :string
  end
end
