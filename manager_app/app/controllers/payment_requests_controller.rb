class PaymentRequestsController < ApplicationController
  def index
    @payment_requests = PaymentRequest.pending
  end

  def update
  end

  private

  def payment_request_params
    params.require(:payment_request).permit(:id, :status)
  end
end
