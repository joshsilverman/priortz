class List < ActiveRecord::Base
  
  belongs_to :user
  has_many :tasks
  
  attr_accessor :recent_tasks
  
  def recent_tasks
    self.tasks.where("'tasks'.'complete' IS NULL or 'tasks'.'complete' <> ? or 'tasks'.'updated_at' > ?", true, Time.now() - 60*60*5).sort_by { |t| 10000 - t.score }
  end
  
end
