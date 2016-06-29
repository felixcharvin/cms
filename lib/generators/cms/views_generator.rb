require 'rails/generators/base'

module Cms
  module Generators
    class ViewsGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../templates', __FILE__)

      def view
        copy_file "show.html.haml", "app/views/#{file_name}/show.rb"
        copy_file "new.html.haml", "app/views/#{file_name}/new.rb"
        copy_file "index.html.haml", "app/views/#{file_name}/index.rb"
      end

    end
  end
end
