# frozen_string_literal: true

class TaskMailer < ApplicationMailer
  def notify_assigne(task)
    @task = task

    mail to:    task.assigne.email,
      subject: "New task has been assigned"
  end
end
