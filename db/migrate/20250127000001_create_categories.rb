class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 255
      t.string :slug, null: false, limit: 255
      t.text :description
      t.integer :parent_id, null: true
      t.integer :sort_order, null: false, default: 0

      t.timestamps null: false
    end

    # Add indexes
    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id
    add_index :categories, :sort_order
    add_index :categories, [:parent_id, :sort_order], name: "index_categories_on_parent_and_sort"

    # Add foreign key constraint for parent_id (self-referential)
    add_foreign_key :categories, :categories, column: :parent_id, on_delete: :cascade
  end
end
