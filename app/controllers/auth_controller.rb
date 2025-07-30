class AuthController < ApplicationController
    skip_before_action :authenticate_user!, only: [:register, :login]
    
    def register
        result = AuthService.call(user_params, 'register')
        
        if result.success?
            token = generate_jwt(result.data[:user])
            render json: {
                user: UserSerializer.serialize(result.data[:user]),
                token: token,
                message: 'Registration successful'
            }, status: :created
        else
            render json: { errors: result.error_message }, status: :unprocessable_entity
        end
    end
    
    def login
        result = AuthService.call(login_params, 'login')
        
        if result.success?
            token = generate_jwt(result.data[:user])
            render json: {
                user: UserSerializer.serialize(result.data[:user]),
                token: token,
                message: 'Login successful'
            }, status: :ok
        else
            render json: { error: result.error_message }, status: :unauthorized
        end
    end
    
    def logout
        # For JWT, logout is handled client-side by removing the token
        render json: { message: 'Logged out successfully' }, status: :ok
    end
    
    private
    
    def user_params
        params.require(:user).permit(
            :name, :email, :password, :password_confirmation,
            :phone, :address, :city, :state, :zipCode, :avatar, :role
        )
    end
    
    def login_params
        params.permit(:email, :password)
    end
end
