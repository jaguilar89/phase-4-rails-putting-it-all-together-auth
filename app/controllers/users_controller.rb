class UsersController < ApplicationController
  before_action :authorize, only: [:show]
  rescue_from ActiveRecord::RecordInvalid, with: :user_not_valid_response

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id
    render json: user, status: :created
  end

  def show
    user = User.find_by(id: session[:user_id])
    render json: user, status: :created
  end

  private

  def user_params
    params.permit(:id, :username, :password, :password_confirmation, :image_url, :bio)
  end

  def authorize
    unless session.include?(:user_id)
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def user_not_valid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
