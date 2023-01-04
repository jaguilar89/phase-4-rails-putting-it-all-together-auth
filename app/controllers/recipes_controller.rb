class RecipesController < ApplicationController
  before_action :authorize, only: [:index, :create]
  rescue_from ActiveRecord::RecordInvalid, with: :recipe_not_valid_response

  def index
    recipes = Recipe.all
    render json: recipes, status: :ok
  end

  def create
    recipe = Recipe.create!(recipe_params)
    render json: recipe, status: :created
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def authorize
    unless session.include?(:user_id)
      render json: { errors: ["Please log in to continue"] }, status: :unauthorized
    end
  end

  def recipe_not_valid_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }
  end
end
