ActiveAdmin.register UserStock do
  form do |f|
    f.inputs "UserStocks" do
      f.input :stock, :as => :select, :collection => Stock.all.each{|stock| stock.name = "#{stock.issue.title} - #{stock.name}"}
      f.input :issue
      f.input :user, :as => :select, :collection => User.all.each{|user| user.name = "#{user.email}(#{user.nickname})"}
      f.input :stock_amounts
    end
    f.buttons
  end
end
