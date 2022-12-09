class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :projects
  has_many :tasks

  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assigne_id'
  has_many :assigned_projects, through: :assigned_tasks, source: :project

  def all_projects
  	Project.where(id: [projects + assigned_projects])
  end

  def all_tasks
  	tasks.or(assigned_tasks)
  end
end
