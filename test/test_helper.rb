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
    def authenticated_header(usuario, password)
      post login_url, params:{ auth: {
        email: usuario.email,
        password: password
        }
      }
      respuesta = JSON.parse(response.body)
      token = respuesta['jwt']
      header = { 'Authorization': "Bearer #{token}"}
      return header
    end

  class ActionDispatch::IntegrationTest
    include HeadersHelper
  end
end
