class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email_address
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.datetime :email_sent_date
      t.text :group
      t.string :key

      t.timestamps null: false
    end
  end
end
