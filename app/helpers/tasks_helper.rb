# frozen_string_literal: true

module TasksHelper
  def authorized_to_task?(task)
    current_user.all_tasks.find_by(id: task.id).present?
  end
end
