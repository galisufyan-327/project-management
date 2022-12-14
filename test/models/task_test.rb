# frozen_string_literal: true

require "test_helper"

describe Task do
  let(:task) { tasks(:one) }

  describe 'validation' do
    test 'valid task' do
      assert task.valid?
    end

    test 'invalid without title' do
      task.title = nil
      assert_not task.valid?
    end

    test 'invalid with same name in same project' do
      _task = tasks(:three)
      _task.title = task.title
      assert_not _task.valid?
    end
  end

  describe 'associations' do
    test 'project' do
      assert_equal 'three', task.project.name

      task.project = nil
      assert_not task.valid?
    end

    test 'creator' do
      assert_equal 'three@user.co', task.user.email

      task.user = nil
      assert_not task.valid?
    end
  end
end
