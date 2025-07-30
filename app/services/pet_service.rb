class PetService < ApplicationService
  def initialize(pet_params, current_user, action = 'create')
    @pet_params = pet_params
    @current_user = current_user
    @action = action
    @pet = Pet.find_by(id: pet_params[:id]) if pet_params[:id]
  end
  
  def call
    case @action
    when 'create'
      create_pet
    when 'update'
      update_pet
    when 'delete'
      delete_pet
    else
      failure('Invalid action')
    end
  end
  
  private
  
  def create_pet
    # User is already authenticated by ApplicationController
    # Pet will be registered to the current logged-in user
    normalized_params = @pet_params.dup
    if normalized_params[:status].present?
      normalized_params[:status] = normalized_params[:status].downcase
    else
      normalized_params[:status] = 'available'
    end
    
    pet = Pet.new(normalized_params.merge(
      user: @current_user
    ))
    
    if pet.save
      success(pet: pet)
    else
      failure(pet.errors.full_messages)
    end
  end
  
  def update_pet
    return failure('Pet not found') unless @pet
    return failure('You can only update your own pets') unless @pet.user == @current_user
    
    if @pet_params[:status] && @pet_params[:status] != @pet.status
      pending_adoptions = @pet.adoptions.where(status: 'pending').exists?
      if pending_adoptions && @pet_params[:status] == 'available'
        return failure('Cannot change status while there are pending adoption requests')
      end
    end
    
    if @pet.update(@pet_params)
      success(pet: @pet)
    else
      failure(@pet.errors.full_messages)
    end
  end
  
  def delete_pet
    return failure('Pet not found') unless @pet
    return failure('You can only delete your own pets') unless @pet.user == @current_user
    
    approved_adoptions = @pet.adoptions.where(status: ['approved', 'completed']).exists?
    if approved_adoptions
      return failure('Cannot delete pet with approved or completed adoptions')
    end
    
    @pet.adoptions.where(status: 'pending').update_all(
      status: 'rejected',
      response_date: Time.current,
      owner_notes: 'Pet registration cancelled by owner'
    )
    
    @pet.destroy
    success(message: 'Pet deleted successfully')
  end
end 