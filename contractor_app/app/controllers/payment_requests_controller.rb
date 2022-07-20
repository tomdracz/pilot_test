class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.all
  end

  def new
    @payment_request = PaymentRequest.new
  end

  def create
    @operation = ::PaymentRequestCreator.create(payment_request_params)

    if @operation.successful?
      redirect_to payment_requests_url, notice: 'Payment request successfully submitted'
    else
      @payment_request = @operation.payment_request
      render 'new'
    end
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:amount, :currency, :description)
  end
end
