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
        PaymentRequestPublisher.publish({foo: 'bar'})
      end
    end
    self
  end

  def successful?
    errors.empty?
  end

  delegate :errors, to: :payment_request
end