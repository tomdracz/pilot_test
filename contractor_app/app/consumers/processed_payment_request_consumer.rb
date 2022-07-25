class ProcessedPaymentRequestConsumer
  include Hutch::Consumer
  consume 'manager.paymentreq.processed'

  def process(message)
    PaymentRequest.find(message[:id]).update(status: message[:decision])
  end
end