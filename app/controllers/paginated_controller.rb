class PaginatedController < ApplicationController

  helper_method :page_count
  def page_count
    @page_count ||= (item_count / items_per_page) + 1
  end

  helper_method :items_per_page
  def items_per_page
    50
  end

  helper_method :page
  def page
    @page ||= begin
      raw_page = params['page'] || "1"
      raw_page = raw_page.to_i
      raw_page = [raw_page, 1].max
      raw_page = [raw_page, page_count].min
      raw_page
    end
  end

  def offset
    (page - 1) * items_per_page
  end

  def item_count
    throw StandardError.new("To implement")
  end

end
