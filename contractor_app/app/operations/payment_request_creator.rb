class PaymentRequestCreator
  def self.create(params)
    new(params).create
  end

  attr_reader :payment_request

  def initialize(params)
    @payment_request = PaymentRequest.new(params)
  end

  def create
    PaymentRequest.transaction do
      saved = @payment_request.save
      if saved
        PaymentRequestPublisher.publish(**event_params)
      end
    end
    self
  end

  def successful?
    errors.empty?
  end

  delegate :errors, to: :payment_request

  def event_params
    @payment_request.attributes.symbolize_keys.slice(:id, :amount, :currency, :description)
  end
end