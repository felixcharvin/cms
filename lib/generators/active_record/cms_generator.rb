require 'rails/generators/active_record'
require 'generators/cms/orm_helpers'

module ActiveRecord
  module Generators
    class CmsGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"
      include Cms::Generators::OrmHelpers
      source_root File.expand_path('../templates', __FILE__)

      def copy_devise_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_cms_to_#{table_name}.rb", migration_version: migration_version
        else
          migration_template "migration.rb", "db/migrate/cms_create_#{table_name}.rb", migration_version: migration_version
        end
        migration_template "migration_page_slug.rb","db/migrate/page_slug_create_#{table_name}.rb", migration_version: migration_version
        migration_template "migration_page_relation.rb","db/migrate/page_relation_create_#{table_name}.rb", migration_version: migration_version
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def inject_devise_content
        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def migration_data
<<RUBY
      
      t.string :title
      t.boolean :active, default: true
      t.datetime :published_at
      t.text :headline 
      t.string :slug

      t.text :content
      t.integer :user_id
      t.integer :parent_id
      t.datetime :auto_published_at
      t.datetime :front_published_at
      t.datetime :front_updated_at
      t.string :thumbnail
      t.string :page_type 
      t.text :content_draft
      t.integer :position, default: 1, null: false
      t.string :title_draft
      t.text :headline_draft
      t.string :slug_draft
      t.string :meta_title
      t.string :meta_title_draft
      t.text :meta_description
      t.text :meta_description_draft
      t.integer :cms_category_id
      t.string :author
      t.string :thumbnail_alt
      t.string :preview_token, null: false
      t.boolean :draft_active, default: true, null: false
      t.datetime :draft_version_updated_at  
      t.datetime :public_version_updated_at

RUBY
      end

      def ip_column
        # Padded with spaces so it aligns nicely with the rest of the columns.
        "%-8s" % (inet? ? "inet" : "string")
      end

      def inet?
        postgresql?
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def postgresql?
        config = ActiveRecord::Base.configurations[Rails.env]
        config && config['adapter'] == 'postgresql'
      end

      def migration_version
        if rails5?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end

    end
  end
end
