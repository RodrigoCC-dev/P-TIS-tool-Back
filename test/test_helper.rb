ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  module HeadersHelper
    

    def profesor_header
      token = Knock::AuthToken.new(payload: {sub: usuarios(:profesor).id}).token
      {
        'Authorization': "Bearer #{token}"
      }
    end
  end

  class ActionDispatch::IntegrationTest
    include HeadersHelper
  end
end
