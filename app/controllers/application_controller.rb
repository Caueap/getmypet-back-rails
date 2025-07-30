class ApplicationController < ActionController::API
    before_action :authenticate_user!
    
    private
    
    def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        return render json: { error: 'No token provided' }, status: :unauthorized unless token
        
        begin
            decoded_token = JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' })
            @current_user = User.find(decoded_token[0]['user_id'])
        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end
    
    def current_user
        @current_user
    end
    
    def jwt_secret
        Rails.application.secret_key_base
    end
    
    def generate_jwt(user)
        payload = {
            user_id: user.id,
            email: user.email,
            exp: 24.hours.from_now.to_i
        }
        JWT.encode(payload, jwt_secret, 'HS256')
    end
end
