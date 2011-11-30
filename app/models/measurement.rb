class Measurement < ActiveRecord::Base
  
  include MeasurementConcerns
  
  validates :latitude,  :presence => true
  validates :longitude, :presence => true
  validates :value,     :presence => true
  validates :unit,      :presence => true
  
  belongs_to :user
  
  def serializable_hash(options)
    options ||= {}
    super(options.merge(:only => [
      :id, :value, :user_id, :latitude, :longitude
    ]))
  end
  
end
