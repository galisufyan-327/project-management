# frozen_string_literal: true

require "test_helper"

describe ProjectsController do
  let(:user_one) { users(:one) }
  let(:user_two) { users(:two) }

  describe '#index' do
    describe 'unauthorised user' do
      it 'should redirect to login page' do
        get projects_path
        follow_redirect!

        assert_select '.alert-danger', 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'authorised user' do
      describe 'created projects' do
        before do
          sign_in user_one.email
          get projects_path
        end

        it 'should show list of created projects' do
          assert_select '.left h5', 'List of Created Projects'
          assert_equal assert_select('.left table tbody tr').size, user_one.projects.count
        end

        it 'should show button to create new project' do
          assert_select '.left a', 'Create New Project'
          assert_select 'a[href=?]', new_project_path
        end

        it 'should show list of projects with task assigned' do
          assert_select '.right h5', 'Assigned(tasks) Projects'
          assert_equal assert_select('.right table tbody tr').size, user_one.assigned_projects.count
        end
      end

      describe 'does not created any project' do
        before do
          sign_in user_two.email
          get projects_path
        end

        it 'should show empty state' do
          assert_select 'h5', 'List of Created Projects'
          assert_select '.left .table-empty-state', 'No record found'
        end
      end
    end
  end

  describe '#new' do
    describe 'unauthorised user' do
      it 'should redirect to login page' do
        get new_project_path
        follow_redirect!

        assert_select '.alert-danger', 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'authorised user' do
      before do
        sign_in user_one.email
        get new_project_path
      end

      it 'should see form to create project' do
        assert_select 'h4', 'Create new Project'
        assert_select 'form[action=?]', projects_path
      end
    end
  end

  describe '#create' do
    describe 'unauthorised user' do
      it 'should redirect to login page' do
        post projects_path, params: project_params
        follow_redirect!

        assert_select '.alert-danger', 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'authorised user' do
      before do
        sign_in user_one.email
        post projects_path, params: project_params
      end

      it 'should redirect to projects path' do
        assert_redirected_to controller: 'projects', action: 'index'
      end

      it 'should create project' do
        follow_redirect!
        assert_select '.alert-success', 'Project created successfully'
      end
    end
  end

  describe '#update' do
    let(:project_one) { projects(:one) }

    describe 'unauthorised user' do
      it 'should redirect to login page' do
        put project_path(project_one), params: project_params
        follow_redirect!

        assert_select '.alert-danger', 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'authorised user' do
      before do
        sign_in user_one.email
        put project_path(project_one), params: project_params
      end

      it 'should redirect to projects path' do
        assert_redirected_to controller: 'projects', action: 'index'
      end

      it 'should update project' do
        project_one.reload
        assert_equal project_one.name, project_params[:project][:name]

        follow_redirect!
        assert_select '.alert-success', 'Project updated successfully'
      end
    end
  end

  describe '#destroy' do
    let(:project_one) { projects(:one) }

    describe 'unauthorised user' do
      it 'should redirect to login page' do
        delete project_path(project_one)
        follow_redirect!

        assert_select '.alert-danger', 'You need to sign in or sign up before continuing.'
      end

      it 'should not delete project of any other user' do
        sign_in user_two.email
        delete project_path(project_one)
        follow_redirect!

        assert_select '.alert-danger', 'Project not found'
      end
    end

    describe 'authorised user' do
      before do
        sign_in user_one.email
        delete project_path(project_one)
      end

      it 'should redirect to projects path' do
        assert_redirected_to controller: 'projects', action: 'index'
      end

      it 'should destroy project' do
        assert_nil Project.find_by_id(project_one)

        follow_redirect!
        assert_select '.alert-success', 'Project deleted successfully'
      end
    end
  end

  def project_params
    {
      project: {
        name: 'Project Name',
        description: 'Project Description',
        status: 'active'
      }
    }
  end
end
