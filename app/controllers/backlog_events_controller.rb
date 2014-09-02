class BacklogEventsController < PaginatedController
  def index
  end

  helper_method :events
  def events
    @events = Events::Backlog.includes(:event).limit(items_per_page).offset(offset)
  end

  def item_count
    Events::Backlog.count
  end
end
