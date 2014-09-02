require 'spec_helper'
require 'rails_helper'

describe ObcStatsController do

  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('uav', 'joe')
  end

  describe '#index' do

    context 'transfers' do

      it 'is empty if there is none' do
        get :index
        expect(assigns(:latest_transfers)).to be_blank
      end

      it 'has latest 5' do

        trans = EventTransmission.new(timestamp: 1)
        trans.save!
        e = Event.new({ event_type: Events::Transfer::EVENT_TYPE,\
          timestamp: 1,
          data: '',
          event_transmission_id: trans.id
        })
        e.save!

        (1..10).each do |i|
          Events::Transfer.new.tap do |t|
            t.name = "file #{i}"
            t.size = i * 1024
            t.duration = i * 60
            t.event_id = e.id
            t.save!
          end
        end

        get :index

        transfers = assigns(:latest_transfers)
        expect(transfers.count).to eq(5)

        expect(transfers[0].name).to eq('file 10')
        expect(transfers[1].name).to eq('file 9')

        # (1..5).each do |i|
        #   t = transfers[i-1]
        #   expect(t.name).to eq("file #{i}")
        #   expect(t.size).to eq(i * 1024)
        #   expect(t.duration).to eq(i * 60)
        # end
      end

    end

  end

end
