class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable, :validatable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :categories, dependent: :delete_all
  has_many :subcategories, dependent: :delete_all
  has_many :sources, dependent: :delete_all
  has_many :statements, dependent: :delete_all
  has_many :expenses, dependent: :delete_all

  before_create :set_uuid

  def regenerate_token
    factor_1 = self.uuid
    factor_2 = SecureRandom.alphanumeric
    factor_3 = Time.now.to_s
    self.access_token = "f_#{Digest::MD5.hexdigest(factor_1 + factor_2 + factor_3)}"
    self.access_token_expiry_date = Time.now + 90.days
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
    self.regenerate_token
  end
end
