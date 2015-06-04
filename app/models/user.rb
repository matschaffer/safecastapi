class User < ActiveRecord::Base

  include UserConcerns

  has_many :bgeigie_imports
  has_many :measurements
  has_many :maps

  scope :moderator, -> { where(:moderator => true) }

  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :presence => true
  validates :name, :presence => true

  before_save :ensure_authentication_token

  def self.by_name(q)
    where("lower(name) LIKE ?", "%#{q.downcase}%")
  end

  def serializable_hash(options = {})
    super options.merge(
      :only => [:id, :name, :email, :authentication_token],
      :methods => [:first_name, :last_name]
    )
  end

  def measurements_count
    measurements.count
  end

  def to_builder
    Jbuilder.new do |user|
      user.(self, :id, :name, :number_of_measurements)
    end
  end

  def name_or_email
    name.presence || email
  end

end
