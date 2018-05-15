#!/usr/bin/env ruby
# frozen_string_literal: true

require "English"

# This script is used to run Rubocop in CircleCI so that on branches only
# the changed files are checked and on master all files are checked.
#
# Additionally if rubocop configuration is changed, all files are checked, and
# if the commit description on a non-master branch includes [rubocop skip]
# then rubocop is skipped.

def run(command)
  puts "Running: #{command}"
  exit 1 unless system(command)
end

def rubocop_everything
  run("bundle exec rubocop --parallel")
end

begin
  if ENV["CIRCLE_BRANCH"] == "master"
    rubocop_everything
  else
    git_commit_desc = `git log --format=%B -n 1 $CIRCLE_SHA1`
    puts "Git commit: #{git_commit_desc}"
    if git_commit_desc.match?(/\[rubocop skip\]/i)
      puts "Skipping RuboCop"
      exit 0
    end

    changed_files = `git diff --diff-filter=d --name-only origin/master...$CIRCLE_BRANCH`.split("\n").join(" ")
    raise "Failed to identify changed files" unless $CHILD_STATUS.success?

    if changed_files.strip.empty? || changed_files.include?(".rubocop")
      rubocop_everything
    else
      run("bundle exec rubocop --force-exclusion #{changed_files}")
    end
  end
rescue StandardError => ex
  puts "Error: #{ex.message}"
  rubocop_everything
end
