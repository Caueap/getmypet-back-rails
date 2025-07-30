class Pet < ApplicationRecord
    belongs_to :user
    has_many :adoptions
    
    validates :name, presence: true
    validates :species, presence: true
    validates :status, presence: true, inclusion: { in: %w[available pending adopted] }
    validates :location, presence: true
    
    def available?
        status == 'available'
    end
    
    def pending?
        status == 'pending'
    end
    
    def adopted?
        status == 'adopted'
    end
end
