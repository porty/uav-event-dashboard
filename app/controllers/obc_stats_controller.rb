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

  helper_method :speed_in_words
  def speed_in_words(bytes, ms)
    seconds = ms / 1000.0
    bps = bytes / seconds
    view_context.number_to_human_size(bps) + "/s"
  end

end
