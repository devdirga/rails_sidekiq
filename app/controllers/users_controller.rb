class UsersController < ApplicationController
  # POST /register
  def register
    puts "Incoming Params: #{params.inspect}"
    user = User.new(user_params)

    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: { token: token, user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password_digest)
  end
end
