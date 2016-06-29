module Cms
  module Generators
    module OrmHelpers
      def model_contents
        buffer = <<-CONTENT
  has_paper_trail class_name: 'Cms::PageVersion'

  has_many   :slugs,       class_name: "::Cms::PageSlug", foreign_key: "cms_page_id"
  has_many   :pages,       class_name: "::Cms::Page",     foreign_key: "parent_id"

  belongs_to :user
  belongs_to :page_parent, class_name: "::Cms::Page", foreign_key: "parent_id"

  has_many :page_relations_for_related_pages,  class_name: "::Cms::PageRelation", foreign_key: "cms_page_source_id"
  has_many :page_relations_for_pages,          class_name: "::Cms::PageRelation", foreign_key: "cms_page_target_id"
  has_many :related_pages,                     class_name: "::Cms::Page", through: :page_relations_for_related_pages
  has_many :in_related_pages,                  class_name: "::Cms::Page", through: :page_relations_for_pages

  validates :user_id, :galaxy_website_id, :preview_token, presence: true
  validates :title_draft, :slug_draft, presence: true, if: -> (obj) { obj.draft_active? }
  validates :title, :slug, presence: true, if: -> (obj) { obj.public? }
  validates :slug, uniqueness: { scope: :page_type, message: "Le slug doit être unique par type de contenu" }, if: -> (obj) { obj.slug.present? }
  validate :validate_slug_draft

CONTENT
        buffer
      end

      private

      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_cms_to_#{table_name}.rb$/).first
      end

      def migration_path
        @migration_path ||= File.join("db", "migrate")
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end

