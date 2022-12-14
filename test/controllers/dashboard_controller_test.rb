# frozen_string_literal: true

require "test_helper"

describe ProjectsController do
  let(:user_one) { users(:one) }
  let(:user_two) { users(:two) }

  describe '#index' do
    describe 'unauthorised user' do
      it 'should redirect to login page' do
        get root_path
        follow_redirect!

        assert_select '.alert-danger', 'You need to sign in or sign up before continuing.'
      end
    end

    describe 'authorised user' do
      before do
        sign_in user_one.email
        get root_path
      end

      it 'should show welcome message' do
        assert_select 'h4', 'Welcome to Project Management'
      end

      it 'should show button for projects path' do
        assert_select 'a', 'Check your Projects'
        assert_select 'a[href=?]', projects_path
      end

      it 'should show button to tasks path' do
        assert_select 'a', 'Go to Tasks'
        assert_select 'a[href=?]', tasks_path
      end
    end
  end
end
