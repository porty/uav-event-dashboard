require 'spec_helper'
require 'rails_helper'

describe BacklogEventsController do

  describe "#page" do

    it "returns last_page for too many pages" do
      expect(controller).to receive(:last_page).and_return(75)
      allow(controller).to receive(:last_page).and_return(75)

      get :index, { "page" => 100 }

      expect(assigns(:page)).to eq(75)
    end

    it "returns 1 for too few pages" do
      get :index, { "page" => -4 }

      expect(assigns(:page)).to eq(1)
    end

  end

  describe "#offset" do

    def add_backlog_events(num)
      t = EventTransmission.new
      t.timestamp = 1
      t.save!

      e = Event.new
      e.event_type = Events::Backlog::EVENT_TYPE
      e.timestamp = 1
      e.data = ""
      e.event_transmission_id = t.id
      e.save!

      (1..num).each do |i|
        Events::Backlog.new.tap do |b|
          b.waiting_count = i
          b.waiting_size = i * 100
          b.completed_count = i+1
          b.completed_size = (i+1) * 100
          b.event_id = e.id
          b.save!
        end
      end
    end

    it "returns the correct offset" do
      add_backlog_events(40)
      expect(controller).to receive(:page).and_return(2)
      expect(controller).to receive(:items_per_page).and_return(10)
      expect(controller.offset).to eq(11)
    end

  end

end
