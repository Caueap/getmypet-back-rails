class UsersController < ApplicationController
    skip_before_action :authenticate_user!
    prepend_before_action :authenticate_user!, only: [:profile]
    before_action :set_user, only: [:show, :update, :destroy]

    def index
        users = User.includes(:pets).all
        render json: UserSerializer.serialize_collection(users)
    end
    
    def show
        render json: UserSerializer.serialize(@user)
    end
    
    def update
        if @user.update(user_params)
            render json: UserSerializer.serialize(@user)
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    def destroy
        if @user.destroy
            render json: { message: 'User account deleted successfully' }, status: :ok
        else
            render json: { 
                errors: @user.errors.full_messages.presence || ['Cannot delete user with associated pets']
            }, status: :unprocessable_entity
        end
    end
    
    def profile
        user_with_pets = User.includes(:pets).find(current_user.id)
        render json: UserSerializer.serialize(user_with_pets)
    end
    
    private
    
    def set_user
        @user = User.includes(:pets).find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
    end
    
    def authorize_user
        unless @user == current_user
            render json: { error: 'Unauthorized' }, status: :forbidden
        end
    end
     
    def user_params
        params.require(:user).permit(
            :name, :email, :phone, :address, :city, :state,
            :zipCode, :avatar
        )
    end
end
