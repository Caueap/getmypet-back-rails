class AdoptionService < ApplicationService
  def initialize(adoption_params, current_user)
    @adoption_params = adoption_params
    @current_user = current_user
  end
  
  def call
    case @adoption_params[:action]
    when 'create_request'
      create_adoption_request
    when 'approve_request'
      approve_adoption_request
    when 'reject_request'
      reject_adoption_request
    when 'complete_adoption'
      complete_adoption
    else
      failure('Invalid action')
    end
  end
  
  private
  
  def create_adoption_request
    pet = Pet.find_by(id: @adoption_params[:pet_id])
    return failure('Pet not found') unless pet
    return failure('Pet not available for adoption') unless pet.available?
    return failure('You cannot adopt your own pet') if pet.user == @current_user
    
    existing_request = Adoption.find_by(
      pet: pet,
      applicant: @current_user,
      status: 'pending'
    )
    return failure('You already have a pending request for this pet') if existing_request
    
    adoption = Adoption.new(
      pet: pet,
      applicant: @current_user,
      owner: pet.user,
      status: 'pending',
      message: @adoption_params[:message],
      application_date: Time.current
    )
    
    if adoption.save
      pet.update(status: 'pending')
      success(adoption: adoption)
    else
      failure(adoption.errors.full_messages)
    end
  end
  
  def approve_adoption_request
    adoption = find_adoption_for_owner
    return failure('Adoption request not found') unless adoption
    return failure('Request already processed') unless adoption.pending?
    
    adoption.update(
      status: 'approved',
      response_date: Time.current,
      owner_notes: @adoption_params[:owner_notes]
    )
    
    success(adoption: adoption)
  end
  
  def reject_adoption_request
    adoption = find_adoption_for_owner
    return failure('Adoption request not found') unless adoption
    return failure('Request already processed') unless adoption.pending?
    
    adoption.update(
      status: 'rejected',
      response_date: Time.current,
      owner_notes: @adoption_params[:owner_notes]
    )
    
    other_pending = Adoption.where(pet: adoption.pet, status: 'pending').exists?
    adoption.pet.update(status: 'available') unless other_pending
    
    success(adoption: adoption)
  end
  
  def complete_adoption
    adoption = find_adoption_for_owner
    return failure('Adoption request not found') unless adoption
    return failure('Request must be approved first') unless adoption.approved?
    
    adoption.update(
      status: 'completed',
      completion_date: Time.current
    )
    
    adoption.pet.update(status: 'adopted')
    
    Adoption.where(pet: adoption.pet, status: 'pending').update_all(
      status: 'rejected',
      response_date: Time.current,
      owner_notes: 'Pet has been adopted by another applicant'
    )
    
    success(adoption: adoption)
  end
  
  def find_adoption_for_owner
    Adoption.find_by(
      id: @adoption_params[:id],
      owner: @current_user
    )
  end
end
