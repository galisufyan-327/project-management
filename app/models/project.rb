class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user_id }

  enum status: {
  	active:    0,
  	archieved: 1,
  	paused:    2
  }

  has_many :tasks
  belongs_to :user
end
