ActiveAdmin.register UserStock do
  form do |f|
    f.inputs "UserStocks" do
      f.input :stock, :as => :select, :collection => 
      Stock.joins("INNER JOIN issues ON stocks.issue_id = issues.id").where("issues.end_date >= curdate()").each{|stock| stock.name = "#{stock.issue.title} - #{stock.name}"}
      f.input :issue
      f.input :user, :as => :select, :collection => User.where("is_admin = 1").each{|user| user.name = "#{user.email}(#{user.nickname})"}
      f.input :stock_amounts
    end
    f.buttons
  end
end
