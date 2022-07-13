class ChangePaymentRequestColumnNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :payment_requests, :description, false
  end
end
