class UserService < ApplicationService
  def initialize(user_params, current_user, action = 'update')
    @user_params = user_params
    @current_user = current_user
    @action = action
    @target_user = User.find_by(id: user_params[:id]) if user_params[:id]
  end
  
  def call
    case @action
    when 'update'
      update_user
    when 'delete'
      delete_user
    else
      failure('Invalid action')
    end
  end
  
  private
  
  def update_user
    return failure('User not found') unless @target_user
    return failure('You can only update your own profile') unless @target_user == @current_user
    
    sanitized_params = @user_params.except(:role, :id)
    
    if @target_user.update(sanitized_params)
      success(user: @target_user)
    else
      failure(@target_user.errors.full_messages)
    end
  end
  
  def delete_user
    return failure('User not found') unless @target_user
    return failure('You can only delete your own account') unless @target_user == @current_user
    
    has_active_adoptions = @target_user.pets.joins(:adoptions)
                                     .where(adoptions: { status: ['pending', 'approved'] })
                                     .exists?
    
    if has_active_adoptions
      return failure('Cannot delete account while you have pets with active adoption requests')
    end
    
    has_pending_requests = @target_user.adoption_requests.where(status: 'pending').exists?
    
    if has_pending_requests
      return failure('Cannot delete account while you have pending adoption requests')
    end
    
    @target_user.adoption_requests.where(status: 'rejected').destroy_all
    @target_user.adoption_offers.where(status: 'rejected').destroy_all
    
    @target_user.pets.destroy_all
    
    @target_user.destroy
    
    success(message: 'User account deleted successfully')
  end
end 