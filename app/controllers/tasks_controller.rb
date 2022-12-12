class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_projects_tasks
  before_action :set_task, except: [:index, :create, :new]

  def index
    @assigned_tasks = current_user.assigned_tasks
  end

  def new
    @task = @tasks.new
  end

  def create
    @task = @tasks.new(task_params)
    if @task.save
      flash[:notice] = 'Task created successfully'
      redirect_to tasks_path
    else
      render :new, status: 422
    end
  end

  def update
    if @task.update(task_params)
      flash[:notice] = 'Task updated successfully'
      redirect_to tasks_path
    else
      render :edit, status: 422
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = 'Task deleted successfully'
      redirect_to tasks_path
    else
      flash[:alert] = @task.errors.full_messages[0]
      render :show, status: 422
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :priority, :assigne_id)
  end

  def set_user_projects_tasks
    @tasks = current_user.tasks
    @tasks = @tasks.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show_errors
    flash[:alert] = @task.errors.full_messages[0]
  end

  def set_task
    @task = current_user.all_tasks.find_by(id: params[:id])

    redirect_back(fallback_location: tasks_path, alert: 'Task not found') if @task.blank?
  end
end
