module Authenticable
  def current_user
    @current_user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  end

  def authenticate_user!
    render json: { error: "Not Authorized" }, status: :unauthorized unless current_user
  end

  private

  def decoded_auth_token
    return nil if request.headers["Authorization"].blank?

    token = request.headers["Authorization"].split(" ").last
    JwtService.decode(token)
  end
end
