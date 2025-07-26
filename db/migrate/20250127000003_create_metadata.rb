class CreateMetadata < ActiveRecord::Migration[7.0]
  def change
    create_table :metadata do |t|
      t.references :project, null: true, foreign_key: { on_delete: :cascade }
      t.string :key, null: false, limit: 255
      t.text :value, null: false
      
      t.timestamps null: false
    end
    
    # Add indexes (project_id index already created by t.references)
    add_index :metadata, :key
    add_index :metadata, [:project_id, :key], unique: true, name: 'index_metadata_on_project_and_key'
    add_index :metadata, [:key, :project_id], name: 'index_metadata_on_key_and_project'
    
    # Add unique constraint for global metadata (where project_id is NULL)
    # This allows one global setting per key, and one setting per project per key
    add_index :metadata, :key, unique: true, where: "project_id IS NULL", name: 'index_metadata_unique_global_key'
  end
end