# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :project_id }

  enum priority: {
    null:    0,
    low:     1,
    medium:  2,
    high:    3,
    highest: 4
  }

  enum status: {
    backlog:     0,
    to_do:       1,
    in_progress: 2,
    in_review:   3,
    done:        4
  }

  has_many :tasks

  belongs_to :user
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true

  after_commit :notify_assignee, if: :assignee_previously_changed?

  private

  def notify_assignee
    TaskMailer.notify_assignee(self).deliver_later
  end
end
