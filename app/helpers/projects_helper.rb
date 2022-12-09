module ProjectsHelper
	def authorized_to_project?(project)
		current_user.projects.find_by(id: project.id).present?
	end
end
