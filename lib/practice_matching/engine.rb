# frozen_string_literal: true

module PracticeMatching
  class Engine < ::Rails::Engine
    engine_name PracticeMatching::PLUGIN_NAME
    isolate_namespace PracticeMatching
  end
end

# Require all the necessary files
require_relative "user_extension"
require_relative "practice_interest"
