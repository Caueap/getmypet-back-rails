class AuthService < ApplicationService
  def initialize(auth_params, action = 'login')
    @auth_params = auth_params
    @action = action
  end
  
  def call
    case @action
    when 'register'
      register_user
    when 'login'
      login_user
    else
      failure('Invalid action')
    end
  end
  
  private
  
  def register_user
    if User.exists?(email: @auth_params[:email])
      return failure('Email already registered')
    end
    
    user = User.new(@auth_params)
    
    if user.save
      success(user: user)
    else
      failure(user.errors.full_messages)
    end
  end
  
  def login_user
    user = User.find_by(email: @auth_params[:email])
    
    unless user
      return failure('Invalid email or password')
    end
    
    unless user.authenticate(@auth_params[:password])
      return failure('Invalid email or password')
    end
    
    success(user: user)
  end
end 