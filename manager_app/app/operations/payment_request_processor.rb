class PaymentRequestProcessor
  def self.process(params)
    new(params).process
  end

  attr_reader :payment_request

  def initialize(params)
    @params = params
    @payment_request = PaymentRequest.find(params[:id])
  end

  def process
    PaymentRequest.transaction do
      saved = @payment_request.update(status: params[:decision])
      if saved
        PaymentRequestDecisionPublisher.publish(**params)
      end
    end
    self
  end

  def successful?
    errors.empty?
  end

  delegate :errors, to: :payment_request

  private

  attr_reader :params
end