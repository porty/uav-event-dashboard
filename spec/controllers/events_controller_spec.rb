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
        expect(e.data).to eq('{"Message":"copter","Who":"bob"}')
      end
    end

  #   it "should use command/event pattern" do
  #     expect(Contests::AddWhitelistUserEvent).to receive(:new) do |args|
  #         expect(args[:user_id]).to eq(params[:user_id])
  #         expect(args[:admin_user_id]).to eq(params[:admin_user_id])
  #
  #         double.tap do |d|
  #           expect(d).to receive(:process)
  #         end
  #     end
  #
  #     post :add, params
  #   end
  #
  #   context "for new IDs" do
  #     it "should return 200" do
  #       post :add, params
  #       expect(response.status).to eq(200)
  #     end
  #
  #     it "should save whitelist item" do
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(false)
  #       post :add, params
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(true)
  #     end
  #   end
  #
  #   context "for existing IDs" do
  #     it "should return 200" do
  #       Contests::WhitelistUser.new(id: params[:user_id]).save!
  #       post :add, params
  #       expect(response.status).to eq(200)
  #     end
  #
  #     it "should still be whitelisted" do
  #       Contests::WhitelistUser.new(id: params[:user_id]).save!
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(true)
  #       post :add, params
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(true)
  #     end
  #   end
  #
  # end
  #
  # describe "#remove" do
  #
  #   it "should use command/event pattern" do
  #     expect(Contests::RemoveWhitelistUserEvent).to receive(:new) do |args|
  #         expect(args[:user_id]).to eq(params[:user_id])
  #         expect(args[:admin_user_id]).to eq(params[:admin_user_id])
  #
  #         double.tap do |d|
  #           expect(d).to receive(:process)
  #         end
  #     end
  #
  #     post :remove, params
  #   end
  #
  #   context "for whitelisted users" do
  #     it "should return 200" do
  #       Contests::WhitelistUser.new(id: params[:user_id]).save!
  #       post :remove, params
  #       expect(response.status).to eq(200)
  #     end
  #
  #     it "should un-whitelist user" do
  #       Contests::WhitelistUser.new(id: params[:user_id]).save!
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(true)
  #
  #       post :remove, params
  #
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(false)
  #     end
  #   end
  #
  #   context "for users that aren't whitelisted" do
  #
  #     it "should return 200 anyway" do
  #       post :remove, params
  #       expect(response.status).to eq(200)
  #     end
  #
  #     it "shouldn't change whitelisting status" do
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(false)
  #       post :remove, params
  #       expect(Contests::WhitelistUser.is_whitelisted? params[:user_id]).to eq(false)
  #     end
  #
  #   end
  end
end
