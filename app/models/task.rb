class Task < ActiveRecord::Base
  
  belongs_to :user
  
  attr_accessor :score

  def self.recent
    self.where("'tasks'.'complete' IS NULL or 'tasks'.'complete' <> ? or 'tasks'.'updated_at' > ?", true, Time.now() - 60*60*5).sort_by { |t| 10000 - t.score }
  end
  
  def score
    Math.sqrt (self[:importance]**2 + self[:urgency]**2)
  end
end
