module ApplicationHelper
  def fail(msg)
    {:code => 0, :msg => msg}
  end

  def success(body)
    if body.nil?
      {:code => 1, :msg => 'success'}
    else
      {:code => 1, :body => body, :msg => 'success'}
    end
  end
end
