class UsuarioTokenController < Knock::AuthTokenController
  before_action :authenticate_user, only: [:refresh]
  skip_before_action :verify_authenticity_token, raise: true
end
