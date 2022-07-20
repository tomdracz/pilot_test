class PaymentRequestPublisher
  def self.publish(params)
    Hutch::Config.set(:mq_host, 'rabbitmq')
    Hutch::Config.set(:mq_api_host, 'rabbitmq')

    Hutch.connect
    Hutch.publish('contractor.paymentreq.created', id: 333)
  end
end
