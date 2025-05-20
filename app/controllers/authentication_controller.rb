class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :register]
  
  # POST /auth/login
  def login
    @user = User.find_by(email: params[:email].downcase)
    
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, user: UserSerializer.new(@user) }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  # POST /auth/register
  def register
    @user = User.new(user_params)
    @user.email = @user.email.downcase
    
    if @user.save
      if params[:image].present?
        @user.image.attach(params[:image])
      end
      
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, user: UserSerializer.new(@user) }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :image)
  end
end