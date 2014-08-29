require 'spec_helper'
require 'rails_helper'

describe EventsController, :type => :controller do

  before(:each) do
    request.accept = "application/json"
  end

  let(:raw_params) do
    {
      "time" => "2014-08-28T21:12:16.881976621+10:00",
      "events" => [ {
        "type" => "chat",
        "time" => "2014-08-28T21:12:11.104988762+10:00",
        "data" => {
          "Message" => "rofl",
          "Who" => "bob"
        }
      },
      {
        "type" => "chat",
        "time" => "2014-08-28T21:12:11.881628945+10:00",
        "data" => {
          "Message" => "copter", "Who" => "bob" }
        }
      ],
      #"event" => {}
    }
  end

  describe "#create" do

    it "should create transmission object" do
      post :create, raw_params

      expect(EventTransmission.count).to eq(1)
      t = EventTransmission.all[0]

      expect(t.timestamp).to eq(1409224336)
    end

    it "should add events in the transmission object" do
      post :create, raw_params

      expect(Event.count).to eq(2)
      Event.all[0].tap do |e|
        expect(e.event_type).to eq("chat")
        expect(e.timestamp).to eq(1409224331)
        expect(e.data).to eq('{"Message":"rofl","Who":"bob"}')
      end
    end

    context "backlog events" do

      let(:raw_params) do
        {
          "time" => "2014-08-24T23:15:44.274441358+10:00",
          "events" => [{
            "type" => "backlog",
            "time" => "2014-08-24T23:15:39.273821646+10:00",
            "data" => {
              "sentCount" => 1,
              "sentSize" => 1024,
              "waitCount"=> 2,
              "waitSize"=> 2048
            }
          }]
        }
      end

      it "saves a Backlog model object" do
        post :create, raw_params

        expect(Events::Backlog.count).to eq(1)
        Events::Backlog.all[0].tap do |b|
          expect(b.completed_count).to eq(1)
          expect(b.completed_size).to eq(1024)
          expect(b.waiting_count).to eq(2)
          expect(b.waiting_size).to eq(2048)
        end
      end

    end
  end
end
