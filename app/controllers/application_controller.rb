class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include Knock::Authenticable
  before_action :authenticate_user

  private

  def unauthorized_entity(entity_name)
    render json: { error: "Unauthorized request" }, status: :unauthorized
  end
end
