# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/home/www/rails_app/vs-www/log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#

set :environment, 'development'
every 1.days, :at => '1:00 am' do
  runner "LogUser.log_user_info"
end

every 1.days,  :at => '11:00 pm' do
  runner "LogStock.log_stock_info"
end

# Learn more: http://github.com/javan/whenever
