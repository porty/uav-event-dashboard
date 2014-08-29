class ObcStatsController < ApplicationController

  def index
    @latest_backlog = Events::Backlog.last
  end

end
