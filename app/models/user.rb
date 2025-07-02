class User < ApplicationRecord
    has_many :adopption_requests, class_name: "Adoption", foreign_key: "applicant_id"
    has_many :requested_pets, through: :adoption_requests, source: :pet

    has_many :adoption_offers, class_name: "Adoption", foreign_key: "owner_id"
    has_many :pets_for_adoption, through: :adoption_offers, source: :pet

    has_many :successful_adoptions, -> { where(status: "approved") }, class_name: "Adoption", foreign_key: "owner_id"
    has_many :adopted_pets, through: :successful_adoptions, source: :pet
end
