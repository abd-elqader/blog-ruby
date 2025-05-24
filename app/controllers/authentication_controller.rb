class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :register]
  
  # POST /auth/login
  def login
    if params[:email].blank? || params[:password].blank?
      return render json: { error: 'Email and password are required' }, status: :bad_request
    end

    @user = User.find_by(email: params[:email].downcase)
    
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id, name: @user.name, email: @user.email)
      render json: { token: token, user: UserSerializer.new(@user) }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
  
  # POST /auth/register
  def register
    if params[:name].blank? || params[:email].blank? || params[:password].blank? || params[:password_confirmation].blank?
      return render json: { error: 'Name, Email, Password and password_confirmation are required' }, status: :bad_request
    end

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