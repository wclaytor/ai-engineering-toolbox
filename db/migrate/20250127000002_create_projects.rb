class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.references :category, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false, limit: 255
      t.string :url, null: false, limit: 500
      t.text :description, null: false
      t.text :features # JSON serialized array
      t.integer :sort_order, null: false, default: 0

      t.timestamps null: false
    end

    # Add indexes (category_id index already created by t.references)
    add_index :projects, :name
    add_index :projects, :sort_order
    add_index :projects, [:category_id, :sort_order], name: "index_projects_on_category_and_sort"
    add_index :projects, [:category_id, :name], name: "index_projects_on_category_and_name"
  end
end
