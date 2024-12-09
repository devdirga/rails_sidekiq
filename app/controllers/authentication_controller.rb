class AuthenticationController < ApplicationController
  require "jwt"

  SECRET_KEY = Rails.application.secret_key_base.to_s

  # Register User
  def register
    user = User.new(user_params)
    if user.save
      # UserMailer.welcome_message(user).deliver_now
      SendEmailJob.perform_later(user.id)
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Login User
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = generate_token(user.id)
      render json: { token: token }, status: :ok
    else
      render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
    end
  end

  private

  # Strong parameters for user registration
  def user_params
    params.permit(:email, :password)
  end

  # Generate JWT token
  def generate_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY, "HS256")
  end
end
