class Project < ActiveRecord::Base
  belongs_to :category
  has_many :metadata, class_name: 'Metadata', dependent: :destroy
  
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]) }
  validates :description, presence: true, length: { minimum: 10 }
  validates :sort_order, presence: true, numericality: { integer: true, greater_than_or_equal_to: 0 }
  
  serialize :features, coder: JSON
  
  scope :by_category, ->(category_slug) { 
    joins(:category).where(categories: { slug: category_slug }) 
  }
  
  scope :ordered, -> { order(:sort_order, :name) }
  
  def features_list
    return [] unless features.is_a?(Array)
    features
  end
  
  def add_feature(feature)
    self.features ||= []
    self.features << feature unless self.features.include?(feature)
  end
  
  def get_metadata(key)
    metadata.find_by(key: key)&.value
  end
  
  def set_metadata(key, value)
    meta = metadata.find_or_initialize_by(key: key)
    meta.value = value
    meta.save!
    meta
  end
end