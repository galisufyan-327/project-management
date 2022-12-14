# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  def notify_assignee(task)
    @task = task

    mail to:    task.assignee.email,
      subject: "New task has been assigned"
  end
end
