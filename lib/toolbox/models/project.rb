class Project < ActiveRecord::Base
  belongs_to :category
  
  validates :name, presence: true
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]) }
  validates :description, presence: true
  
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
end