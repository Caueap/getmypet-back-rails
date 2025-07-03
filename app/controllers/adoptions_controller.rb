class AdoptionsController < ApplicationController

    def index
        render json: Adoption.all
      end
    
      def show
        adoption = Adoption.find(params[:id])
        render json: adoption
      end
    
      def create
        adoption = Adoption.new(adoption_params)
        if adoption.save
          render json: adoption, status: :created
        else
          render json: adoption.errors, status: :unprocessable_entity
        end
      end
    
      def update
        adoption = Adoption.find(params[:id])
        if adoption.update(adoption_params)
          render json: adoption
        else
          render json: adoption.errors, status: :unprocessable_entity
        end
      end
    
      private
    
      def adoption_params
        params.require(:adoption).permit(
          :pet_id, :applicant_id, :owner_id,
          :status, :message, :owner_notes,
          :application_date, :response_date, :completion_date
        )
      end
end
