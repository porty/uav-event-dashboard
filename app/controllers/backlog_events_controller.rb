class BacklogEventsController < ApplicationController
  def index
    @events = Events::Backlog.order(id: :desc).limit(items_per_page)
    @page = page
  end

  helper_method :last_page
  def last_page
    @last_page ||= (Events::Backlog.all.count / items_per_page) + 1
  end

  def items_per_page
    50
  end

  private

  def page
    raw_page = params['page'] || "1"
    raw_page = raw_page.to_i
    raw_page = [raw_page, 1].max
    raw_page = [raw_page, last_page].min
    raw_page
  end

end
