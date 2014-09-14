module StoreHelper

  def current_date_and_time
    Time.now.to_formatted_s(:long)
  end
end
