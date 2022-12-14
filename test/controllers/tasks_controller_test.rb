# frozen_string_literal: true

require "test_helper"

describe ProjectsController do
  let(:user_one) { users(:one) }
  let(:user_two) { users(:two) }
  let(:project_one) { projects(:one) }

  describe "#index" do
    describe "unauthorised user" do
      it "should redirect to login page" do
        get tasks_path
        follow_redirect!

        assert_select ".alert-danger", "You need to sign in or sign up before continuing."
      end
    end

    describe "authorised user" do
      describe "with created tasks" do
        before do
          sign_in user_one.email
          get tasks_path
        end

        it "should show list of created projects" do
          assert_select ".left h5", "List of Tasks in my Projects"
          assert_equal assert_select(".left table tbody tr").size, user_one.tasks.count
        end

        it "should show list of assigned tasks" do
          assert_select ".right h5", "Assigned Tasks"
          assert_equal assert_select(".right table tbody tr").size, user_one.assigned_tasks.count
        end
      end

      describe "when did not created any task" do
        before do
          sign_in user_two.email
          get tasks_path
        end

        it "should show empty state" do
          assert_select "h5", "List of Tasks in my Projects"
          assert_select ".left .table-empty-state", "No record found"
        end
      end
    end
  end

  describe "#new" do
    describe "unauthorised user" do
      it "should redirect to login page" do
        get new_project_task_path(project_one)
        follow_redirect!

        assert_select ".alert-danger", "You need to sign in or sign up before continuing."
      end
    end

    describe "authorised user" do
      before do
        sign_in user_one.email
        get new_project_task_path(project_one)
      end

      it "should see form to create task" do
        assert_select "h4", "Create new Task"
        assert_select "form[action=?]", project_tasks_path(project_one)
      end
    end
  end

  describe "#create" do
    describe "unauthorised user" do
      it "should redirect to login page" do
        post project_tasks_path(project_one), params: task_params
        follow_redirect!

        assert_select ".alert-danger", "You need to sign in or sign up before continuing."
      end
    end

    describe "authorised user" do
      before do
        sign_in user_one.email
        post project_tasks_path(project_one), params: task_params
      end

      it "should redirect to tasks path" do
        assert_redirected_to tasks_path
      end

      it "should create task" do
        follow_redirect!
        assert_select ".alert-success", "Task created successfully"
      end
    end
  end

  describe "#update" do
    let(:task_two) { tasks(:two) }

    describe "unauthorised user" do
      it "should redirect to login page" do
        put project_task_path(task_two.project, task_two), params: task_params
        follow_redirect!

        assert_select ".alert-danger", "You need to sign in or sign up before continuing."
      end
    end

    describe "authorised user" do
      before do
        sign_in user_one.email
        put project_task_path(task_two.project, task_two), params: task_params
      end

      it "should redirect to tasks path" do
        assert_redirected_to tasks_path
      end

      it "should update task" do
        task_two.reload
        assert_equal task_two.title, task_params[:task][:title]

        follow_redirect!
        assert_select ".alert-success", "Task updated successfully"
      end
    end
  end

  describe "#destroy" do
    let(:task_two) { tasks(:two) }

    describe "unauthorised user" do
      it "should redirect to login page" do
        delete task_path(task_two)
        follow_redirect!

        assert_select ".alert-danger", "You need to sign in or sign up before continuing."
      end

      it "should not delete task of any other user" do
        sign_in user_two.email
        delete task_path(task_two)
        follow_redirect!

        assert_select ".alert-danger", "Task not found"
      end
    end

    describe "authorised user" do
      before do
        sign_in user_one.email
        delete task_path(task_two)
      end

      it "should redirect to tasks path" do
        assert_redirected_to tasks_path
      end

      it "should destroy task" do
        assert_nil Task.find_by_id(task_two)

        follow_redirect!
        assert_select ".alert-success", "Task deleted successfully"
      end
    end
  end

  describe "#show" do
    let(:task_one) { tasks(:one) }
    let(:task_two) { tasks(:two) }

    describe "unauthorised user" do
      it "should redirect to login page" do
        get task_path(task_two)
        follow_redirect!

        assert_select ".alert-danger", "You need to sign in or sign up before continuing."
      end

      it "should not show task of any other user" do
        sign_in user_two.email
        get task_path(task_two)
        follow_redirect!

        assert_select ".alert-danger", "Task not found"
      end
    end

    describe "authorised user" do
      before do
        sign_in user_one.email
        get task_path(task_two)
      end

      it "should see the task details" do
        assert_select "h5", "Task Details"
        assert_select "a[href=?]", edit_task_path(task_two)
        assert_select "b", "Title:"
        assert_select "button", "Delete"
        assert_select "form[action=?]", task_path(task_two)
      end

      it "should see task project details" do
        assert_select "h5", "Project"

        assert_select "a[href=?]", project_path(task_two.project)
      end
    end
  end

  def task_params
    {
      task: {
        title: "Task Name",
        description: "Task Description",
        status: "backlog",
        priority: "low",
        assignee: User.last
      }
    }
  end
end
