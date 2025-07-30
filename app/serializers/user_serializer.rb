class UserSerializer
  def self.serialize(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      city: user.city,
      state: user.state,
      zipCode: user.zipCode,
      avatar: user.avatar,
      role: user.role,
      pets: user.pets.map { |pet| serialize_pet_basic(pet) }
    }
  end
  
  def self.serialize_basic(user)
    {
      id: user.id,
      name: user.name,
      city: user.city,
      state: user.state
    }
  end
  
  def self.serialize_collection(users)
    users.map { |user| serialize(user) }
  end
  
  private
  
  def self.serialize_pet_basic(pet)
    {
      id: pet.id,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      size: pet.size,
      age: pet.age,
      gender: pet.gender,
      description: pet.description,
      images: pet.images,
      vaccinations: pet.vaccinations,
      status: pet.status,
      isNeutered: pet.isNeutered,
      location: pet.location
    }
  end
end 