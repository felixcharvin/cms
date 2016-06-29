class PageRelationCreate<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %>_relation do |t|
      t.integer :cms_page_source_id
      t.integer :cms_page_target_id

      t.timestamps null: false
    end
  end
end