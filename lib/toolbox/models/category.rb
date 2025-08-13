class Category < ActiveRecord::Base
  # Self-referential relationship for hierarchical categories
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy

  has_many :projects, -> { order(:sort_order) }, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :sort_order, presence: true, numericality: { integer: true, greater_than_or_equal_to: 0 }

  before_validation :generate_slug, if: :name_changed?

  scope :ordered, -> { order(:sort_order, :name) }
  scope :root_categories, -> { where(parent_id: nil) }

  def root?
    parent_id.nil?
  end

  def has_children?
    children.any?
  end

  private

  def generate_slug
    return unless name.present?
    self.slug = name.downcase
                   .gsub(/[^a-z0-9\s]/i, "")
                   .gsub(/\s+/, "-")
                   .gsub(/^-+|-+$/, "")
  end
end
