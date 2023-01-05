class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authorize
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record_response

  private

  def authorize
    #@current_user available in all subclasses(the other controllers) that call upon the before_action :authorize macro, since all methods defined in a superclass are inherited
    #by its instances and subclasses
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      render json: { errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def invalid_record_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
