class PageSlugCreate<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %>_slug do |t|
      t.integer :cms_page_id
      t.string :slug

      t.timestamps null: false
    end
  end
end