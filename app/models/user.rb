class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable, :validatable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :categories
  has_many :sources
  has_many :statements

  before_create :set_uuid

  def regenerate_token
    something_the_user_has = self.uuid
    something_i_know = "my-secret"
    something_i_dont_know = Time.now.to_s
    self.access_token = "f_#{Digest::MD5.hexdigest(something_the_user_has + something_i_know + something_i_dont_know)}"
    self.access_token_expiry_date = Time.now + 90.days
  end

  private
  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
