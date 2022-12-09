class Project < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user_id }

  enum status: {
  	active:    0,
  	archieved: 1,
  	paused:    2
  }
end
