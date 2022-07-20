class IncomingPaymentRequestConsumer
  include Hutch::Consumer
  consume 'contractor.paymentreq.created'

  def process(message)
    puts "DEBUG"
    puts message
    PaymentRequest.create(amount: message[:id], currency: 'USD', description: 'TEST')
  end
end