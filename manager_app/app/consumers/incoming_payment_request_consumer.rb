class IncomingPaymentRequestConsumer
  include Hutch::Consumer
  consume 'contractor.paymentreq.created'

  def process(message)
    PaymentRequest.create!(id: message[:id], amount: message[:amount], currency: message[:currency], description: message[:description])
  end
end