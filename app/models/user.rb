class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :subcategories, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :statements, dependent: :destroy
  has_many :statement_processings, dependent: :destroy
  has_many :expenses, dependent: :destroy

  normalizes :username, with: ->(e) { e.strip.downcase }
  validates :username, uniqueness: { message: "can't be used" }

  before_create :set_uuid
  after_create :create_baseline_categories

  def regenerate_token
    factor_1 = self.uuid
    factor_2 = SecureRandom.alphanumeric
    factor_3 = Time.now.to_s
    self.access_token = "f_#{Digest::MD5.hexdigest(factor_1 + factor_2 + factor_3)}"
    self.access_token_expiry_date = Time.now + 90.days
  end

  def uncategorized
    return self.categories.first, self.subcategories.first
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
    self.regenerate_token
  end

  def create_baseline_categories
    c = Category.create!(name: "Uncategorized", user: self)
    self.categories << c
    self.subcategories << Subcategory.create!(name: "Uncategorized", user: self, category: c)
  end
end
