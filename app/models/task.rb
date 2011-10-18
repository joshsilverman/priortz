class Task < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessor :score
  
  def score
    Math.sqrt (self[:importance]**2 + self[:urgency]**2)
  end
end
