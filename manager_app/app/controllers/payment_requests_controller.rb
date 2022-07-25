class PaymentRequestsController < ApplicationController
  before_action :set_payment_requests

  def index; end

  def update
    @operation = ::PaymentRequestProcessor.process(payment_request_params)

    if @operation.successful?
      redirect_to payment_requests_url, notice: 'Payment request successfully processed'
    else
      redirect_to payment_requests_url, alert: 'Could not process payment request. Please try again'
    end
  end

  private

  def set_payment_requests
    @payment_requests = PaymentRequest.pending
  end

  def payment_request_params
    params.permit(:id, :decision)
  end
end