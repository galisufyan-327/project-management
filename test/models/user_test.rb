require "test_helper"

describe User do
  let(:user) { users(:one) }

  describe 'validation' do
    test 'valid user' do
      assert user.valid?
    end

    test 'invalid without name' do
      user.name = nil
      assert_not user.valid?
    end

    test 'invalid without email' do
      user.email = nil
      assert_not user.valid?
    end
  end

  describe 'associations' do
    test 'created projects' do
      assert_equal 2, user.projects.size
    end

    test 'assigned projects' do
      assert_equal 3, user.assigned_projects.size
    end

    test 'created tasks' do
      assert_equal 1, user.tasks.size
    end

    test 'assigned tasks' do
      assert_equal 3, user.assigned_tasks.size
    end
  end
end
