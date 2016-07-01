module Errors
  class InsufficientFundsError < StandardError; end
  class TransactionNotCompletedError < StandardError; end
  class RequestNotCompletedError < StandardError; end
  class RequestNotAcceptedError < StandardError; end
  class RequestNotRejectedError < StandardError; end
end