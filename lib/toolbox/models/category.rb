class Category < ActiveRecord::Base
  has_many :projects, -> { order(:sort_order) }, dependent: :destroy
  
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  
  before_validation :generate_slug
  
  scope :ordered, -> { order(:sort_order, :name) }
  
  private
  
  def generate_slug
    return unless name.present?
    self.slug = name.downcase
                   .gsub(/[^a-z0-9\s]/i, '')
                   .gsub(/\s+/, '-')
                   .gsub(/^-+|-+$/, '')
  end
end