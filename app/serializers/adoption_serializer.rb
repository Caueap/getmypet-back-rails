class AdoptionSerializer
  def self.serialize(adoption)
    {
      id: adoption.id,
      status: adoption.status,
      message: adoption.message,
      owner_notes: adoption.owner_notes,
      application_date: adoption.application_date,
      response_date: adoption.response_date,
      completion_date: adoption.completion_date,
      pet: serialize_pet_basic(adoption.pet),
      applicant: serialize_user_contact(adoption.applicant),
      owner: serialize_user_contact(adoption.owner),
      created_at: adoption.created_at,
      updated_at: adoption.updated_at
    }
  end
  
  def self.serialize_collection(adoptions)
    adoptions.map { |adoption| serialize(adoption) }
  end
  
  private
  
  def self.serialize_pet_basic(pet)
    {
      id: pet.id,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      images: pet.images&.first
    }
  end
  
  def self.serialize_user_contact(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      city: user.city,
      state: user.state
    }
  end
end 