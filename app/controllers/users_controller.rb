class UsersController < ApplicationController
  # GET /profile
  def profile
    render json: current_user
  end
end