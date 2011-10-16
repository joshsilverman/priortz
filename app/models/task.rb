class Task < ActiveRecord::Base
  
  attr_accessor :score
  
  def score
    Math.sqrt (self[:importance]**2 + self[:urgency]**2)
  end
end
