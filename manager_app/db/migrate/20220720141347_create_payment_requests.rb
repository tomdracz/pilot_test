class CreatePaymentRequests < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :payment_requests, id: :uuid do |t|
      t.decimal :amount, null: false
      t.string :currency, null: false
      t.text :description, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
