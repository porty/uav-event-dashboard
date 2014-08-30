class ObcStatsController < ApplicationController

  def index
    @latest_backlog = Events::Backlog.last
    @latest_transfers = Events::Transfer.limit(5).order(id: :desc)
  end

  helper_method :timestamp_in_words
  def timestamp_in_words(unix_timestamp)
    time = Time.at(unix_timestamp)

    prefix = view_context.time_ago_in_words(time, include_seconds: true)
    suffix = time.future? ? 'in the future' : 'ago'

    #view_context.time_ago_in_words(time) + time.future? ? 'in the future' : 'ago'
    "#{prefix} #{suffix}"
  end

end
