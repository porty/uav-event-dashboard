class Events::Transfer < ActiveRecord::Base
  belongs_to :event

  EVENT_TYPE = 'xfer'
end
