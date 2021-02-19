#encoding:windows-31j

require_relative "account_info"
require "date"
require "csv"

def read_send_file
  array = []
  CSV.foreach(account_info[:desktop_dir].gsub("\\","/") + "/send_yafuoku_#{Date.today}.csv"){|f| array << f }
  array
end
