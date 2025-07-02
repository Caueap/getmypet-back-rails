class Adoption < ApplicationRecord
  belongs_to :pet
  belongs_to :applicant, class_name: "User"
  belongs_to :owner, class_name: "User"

  enum :status, {
    pending: "pending",
    approved: "approved",
    rejected: "rejected",
    completed: "completed"
  }

  validates :message, :status, presence: true
end
