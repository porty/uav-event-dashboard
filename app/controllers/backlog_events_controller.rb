class BacklogEventsController < PaginatedController
  def index
  end

  helper_method :events
  def events
    @events = limit_to_date(Events::Backlog.includes(:event)).limit(items_per_page).offset(offset)
  end

  def item_count
    limit_to_date(Events::Backlog.includes(:event)).count
  end
end
