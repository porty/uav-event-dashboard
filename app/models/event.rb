class Event < ActiveRecord::Base
  belongs_to :event_transmission
  alias_method :transmission, :event_transmission

  def process!
    case event_type
    when Events::Backlog::EVENT_TYPE
      Events::Backlog.new.tap do |b|
        b.waiting_count = data_as_hash['waitCount']
        b.waiting_size = data_as_hash['waitSize']
        b.completed_count = data_as_hash['sentCount']
        b.completed_size = data_as_hash['sentSize']
        b.event_id = id
        b.save!
      end
    when Events::Transfer::EVENT_TYPE
      Events::Transfer.new(data_as_hash).tap do |t|
        t.event_id = id
        t.save!
      end
    end
  end

  def data_as_hash
    @data_as_hash ||= JSON.parse(data)
  end

end
