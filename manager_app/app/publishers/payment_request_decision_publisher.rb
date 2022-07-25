class PaymentRequestDecisionPublisher
  def self.publish(**params)
    Hutch::Config.set(:mq_host, 'rabbitmq')
    Hutch::Config.set(:mq_api_host, 'rabbitmq')

    Hutch.connect
    Hutch.publish('manager.paymentreq.processed', **params)
  end
end
