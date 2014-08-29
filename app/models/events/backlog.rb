class Events::Backlog < ActiveRecord::Base
  belongs_to :event

  EVENT_TYPE = 'backlog'
end
