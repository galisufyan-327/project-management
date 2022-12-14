# frozen_string_literal: true

require "test_helper"

describe Project do
  let(:project) { projects(:one) }

  describe "validation" do
    test "valid project" do
      assert project.valid?
    end

    test "invalid without name" do
      project.name = nil
      assert_not project.valid?
    end

    test "invalid without creator user" do
      project.user = nil
      assert_not project.valid?
    end
  end

  describe "associations" do
    test "tasks" do
      assert_equal 1, project.tasks.size

      project.tasks = []
      assert project.valid?
    end

    test "creator" do
      assert_equal "one@user.co", project.user.email

      project.user = nil
      assert_not project.valid?
    end
  end
end
