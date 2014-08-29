class Event < ActiveRecord::Base
  belongs_to :event_transmission
  alias_method :transmission, :event_transmission

  def process!
    case event_type
    when Events::Backlog::EVENT_TYPE
      Events::Backlog.new.tap do |b|
        b.waiting = data_as_hash['waiting']
        b.completed = data_as_hash['completed']
        b.event_id = id
        b.save!
      end
    end
  end

  def data_as_hash
    @data_as_hash ||= JSON.parse(data)
  end

end
