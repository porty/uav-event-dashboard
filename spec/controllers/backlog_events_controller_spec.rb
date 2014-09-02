require 'spec_helper'
require 'rails_helper'

describe BacklogEventsController do

  describe "#page" do

    it "returns last_page for too many pages" do
      expect(controller).to receive(:last_page).and_return(75)

      get :index, { "page" => 100 }

      expect(assigns(:page)).to eq(75)
    end

    it "returns 1 for too few pages" do
      get :index, { "page" => -4 }

      expect(assigns(:page)).to eq(1)
    end

  end

end
