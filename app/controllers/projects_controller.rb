class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_projects
  before_action :set_project, except: [:index, :create, :new]

  def index; end

  def new
    @project = Project.new
  end

  def create
    @project = @projects.new(project_params)
    if @project.save
      flash[:notice] = 'Project created successfully'
      redirect_to projects_path
    else
      render :new, status: 422
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = 'Project updated successfully'
      redirect_to projects_path
    else
      render :edit, status: 422
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = 'Project deleted successfully'
      redirect_to projects_path
    else
      flash[:alert] = @project.errors.full_messages[0]
      render :show, status: 422
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end

  def set_user_projects
    @projects = current_user.projects
  end

  def show_errors
    flash[:alert] = @project.errors.full_messages[0]
  end

  def set_project
    @project = @projects.find_by(id: params[:id])

    redirect_back(fallback_location: projects_path, alert: 'Project not found') if @project.blank?
  end
end