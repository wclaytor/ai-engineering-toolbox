class Metadata < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  
  def self.get(key)
    find_by(key: key)&.value
  end
  
  def self.set(key, value)
    metadata = find_or_initialize_by(key: key)
    metadata.value = value
    metadata.save!
    metadata
  end
end