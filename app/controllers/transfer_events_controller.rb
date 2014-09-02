class TransferEventsController < PaginatedController
  def index
  end

  helper_method :events
  def events
    @events = Events::Transfer.includes(:event).limit(items_per_page).offset(offset)
  end

  def item_count
    Events::Transfer.count
  end
end
