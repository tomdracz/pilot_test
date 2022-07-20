class PaymentRequest < ApplicationRecord
  self.implicit_order_column = "created_at"
  
  validates :amount, presence: true, numericality: true
  validates :currency, presence: true
  validates :description, presence: true

  enum status: %i[pending approved rejected], _default: "pending"
end
