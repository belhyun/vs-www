json.array!(@works) do |work|
  json.extract! work, :id, :title, :description, :give_money, :end_date
  json.url work_url(work, format: :json)
end
