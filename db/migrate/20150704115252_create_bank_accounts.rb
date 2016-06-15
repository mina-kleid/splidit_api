class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :iban
      t.string :account_name
      t.string :bic
      t.references :user, index: true

      t.timestamps
    end
  end
end
