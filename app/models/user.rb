class User < ActiveRecord::Base
  attr_accessor :login

  has_one :profile, dependent: :destroy

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                       uniqueness: { case_sensitive: false }, 
                           length: { maximum: 40 }, confirmation: true

  validates :username, uniqueness: { case_sensitive: false }, 
                           length: { maximum: 20 }, presence: true   

  validate :username_differs_from_emails
  validate :password_complexity

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :lockable, :timeoutable
         #:confirmable, :omniauthable

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where([
        "lower(username) = :value OR lower(email) = :value",
        { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def username_differs_from_emails
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end

  def password_complexity
    complexity_regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/
    error_message =
      'password must have a lowercase letter, an uppercase letter, and a digit'
    if password.present? && !password.match(complexity_regex)
      errors.add :password, error_message
    end
  end

  def login= login
    @login = login
  end

  def login
    @login || self.username || self.email
  end
end
