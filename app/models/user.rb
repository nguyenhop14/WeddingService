class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  devise :omniauthable
  AUTHORITIES = {admin: "admin", supplier: "supplier", member: "member"}.freeze
  validates :name, presence: true, length: {maximum: 50}
  enum role: AUTHORITIES
  validate :check_birthday
  has_many :vendors
  belongs_to :schedule, optional: true

  def self.new_with_session params, session
    super.tap do |user|
      if data = session["devise.facebook_data"] &&
        session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end

  private
  def check_birthday
    if birthday
      if birthday > Date.today
        errors.add(:birthday, "Birth day is the pass")
      end
    end
  end  
end
