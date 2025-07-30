class User < ApplicationRecord
    has_secure_password
    
    has_many :pets, dependent: :restrict_with_error
    has_many :adoption_requests, class_name: "Adoption", foreign_key: "applicant_id"
    has_many :requested_pets, through: :adoption_requests, source: :pet

    has_many :adoption_offers, class_name: "Adoption", foreign_key: "owner_id"
    has_many :pets_for_adoption, through: :adoption_offers, source: :pet

    has_many :successful_adoptions, -> { where(status: "approved") }, class_name: "Adoption", foreign_key: "owner_id"
    has_many :adopted_pets, through: :successful_adoptions, source: :pet
    
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :name, presence: true
    validates :phone, presence: true
    validates :role, presence: true
    
    before_validation :set_default_role, on: :create
    
    private
    
    def set_default_role
        self.role ||= 'user'
    end
end
