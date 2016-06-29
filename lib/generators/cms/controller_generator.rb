require 'rails/generators/base'

module Cms
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../templates', __FILE__)
      def controller
        template "controller.rb", "app/controllers/#{file_name}_controller.rb"    
      end
    end
  end
end
