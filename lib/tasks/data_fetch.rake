require 'net/http'
require 'csv'

namespace :data do
  desc "restore the mysql backup to current database."

  task :fetch => :environment do
    StockDayData.fetch_data('300072.sz')
  end

end
