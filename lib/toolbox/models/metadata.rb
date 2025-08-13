class Metadata < ActiveRecord::Base
  belongs_to :project, optional: true

  validates :key, presence: true, length: { minimum: 1, maximum: 255 }
  validates :value, presence: true

  # Validate uniqueness of key per project (or globally if project_id is nil)
  validates :key, uniqueness: { scope: :project_id }

  scope :global, -> { where(project_id: nil) }
  scope :for_project, ->(project) { where(project: project) }

  def self.get(key, project = nil)
    if project
      find_by(key: key, project: project)&.value
    else
      find_by(key: key, project_id: nil)&.value
    end
  end

  def self.set(key, value, project = nil)
    metadata = if project
      find_or_initialize_by(key: key, project: project)
               else
      find_or_initialize_by(key: key, project_id: nil)
    end
    metadata.value = value
    metadata.save!
    metadata
  end

  def global?
    project_id.nil?
  end

  def project_specific?
    !project_id.nil?
  end
end
