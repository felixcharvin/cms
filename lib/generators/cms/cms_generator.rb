require 'rails/generators/named_base'

module Cms
  module Generators
    class CmsGenerator < Rails::Generators::NamedBase
      namespace "cms"
      source_root File.expand_path('../templates', __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with cms "

      hook_for :orm
    end
  end
end