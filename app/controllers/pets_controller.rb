class PetsController < ApplicationController

    def index
        render json: Pet.all
    end
    
    def show
        pet = Pet.find(params[:id])
        render json: pet
    end 
    
    def create
        pet = Pet.new(pet_params)
        if pet.save
            render json: pet, status: :created        
        else
            render json: pet.errors, status: :unprocessable_entity
        end
    end
    
    private

    def pet_params
        params.require(:pet).permit(
          :name, :species, :breed, :size, :age, :gender,
          :description, :status, :isNeutered, :location,
          images: [], vaccinations: []
        )
    end    
end
