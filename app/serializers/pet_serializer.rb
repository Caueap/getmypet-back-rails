class PetSerializer
  def self.serialize(pet)
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
      location: pet.location,
      owner: UserSerializer.serialize_basic(pet.user),
      created_at: pet.created_at
    }
  end
  
  def self.serialize_collection(pets)
    pets.map { |pet| serialize(pet) }
  end
end 