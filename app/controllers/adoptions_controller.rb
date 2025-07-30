class AdoptionsController < ApplicationController
    before_action :set_adoption, only: [:show, :update, :destroy]
    
    def index
        adoptions = Adoption.includes(:pet, :applicant, :owner)
                           .where('applicant_id = ? OR owner_id = ?', current_user.id, current_user.id)
        render json: AdoptionSerializer.serialize_collection(adoptions)
    end
    
    def show
        unless @adoption.applicant == current_user || @adoption.owner == current_user
            return render json: { error: 'Unauthorized' }, status: :forbidden
        end
        
        render json: AdoptionSerializer.serialize(@adoption)
    end
    
    def create
        result = AdoptionService.call(
            adoption_params.merge(action: 'create_request'),
            current_user
        )
        
        if result.success?
            render json: AdoptionSerializer.serialize(result.data[:adoption]), status: :created
        else
            render json: { errors: result.error_message }, status: :unprocessable_entity
        end
    end
    
    def update
        action = determine_action
        
        result = AdoptionService.call(
            adoption_params.merge(id: @adoption.id, action: action),
            current_user
        )
        
        if result.success?
            render json: AdoptionSerializer.serialize(result.data[:adoption])
        else
            render json: { errors: result.error_message }, status: :unprocessable_entity
        end
    end
    
    def destroy
        unless @adoption.owner == current_user
            return render json: { error: 'Unauthorized' }, status: :forbidden
        end
        
        @adoption.destroy
        render json: { message: 'Adoption request deleted' }, status: :ok
    end
    
    private
    
    def set_adoption
        @adoption = Adoption.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { error: 'Adoption request not found' }, status: :not_found
    end
    
    def adoption_params
        params.require(:adoption).permit(
            :pet_id, :message, :owner_notes, :status, :action
        )
    end
    
    def determine_action
        return params[:action] if params[:action].present?
        
        case adoption_params[:status]
        when 'approved'
            'approve_request'
        when 'rejected'
            'reject_request'
        when 'completed'
            'complete_adoption'
        else
            'update'
        end
    end
end
