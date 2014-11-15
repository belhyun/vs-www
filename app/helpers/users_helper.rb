module UsersHelper
  def is_in_a_day(date)
    (Time.now - date)/86400.to_f <= 1.0
  end
end
