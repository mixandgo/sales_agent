class Base
  RETRYABLE_API_ERRORS = [
    JSON::ParserError,
    Faraday::TooManyRequestsError, Faraday::ServerError, Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::SSLError,
    OpenSSL::SSL::SSLError
  ].freeze

  def self.call(...)
    new(...).perform
  end
end
