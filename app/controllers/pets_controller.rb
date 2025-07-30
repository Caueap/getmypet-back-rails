class PetsController < ApplicationController
    before_action :set_pet, only: [:show, :update, :destroy]
    
    def index
        pets = Pet.includes(:user).all
        render json: PetSerializer.serialize_collection(pets)
    end
    
    def show
        render json: PetSerializer.serialize(@pet)
    end 
    
    def create
        result = PetService.call(pet_params, current_user, 'create')
        
        if result.success?
            render json: PetSerializer.serialize(result.data[:pet]), status: :created        
        else
            render json: { errors: result.error_message }, status: :unprocessable_entity
        end
    end
    
    def update
        result = PetService.call(pet_params.merge(id: @pet.id), current_user, 'update')
        
        if result.success?
            render json: PetSerializer.serialize(result.data[:pet])
        else
            render json: { errors: result.error_message }, status: :unprocessable_entity
        end
    end
    
    def destroy
        result = PetService.call({ id: @pet.id }, current_user, 'delete')
        
        if result.success?
            render json: { message: result.data[:message] }, status: :ok
        else
            render json: { errors: result.error_message }, status: :unprocessable_entity
        end
    end
    
    private
    
    def set_pet
        @pet = Pet.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: 'Pet not found' }, status: :not_found
    end

    def pet_params
        permitted_params = params.require(:pet).permit(
          :name, :species, :breed, :size, :age, :gender,
          :description, :status, :isNeutered, :location,
          images: [], vaccinations: []
        )
    end
end
