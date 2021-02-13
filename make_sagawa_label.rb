#encoding:windows-31j
require 'csv'
require 'date'
require_relative 'component/account_info'

account = account_info[:account]
desktop_dir = account_info[:desktop_dir]
today = Date.today.to_s
desktop = desktop_dir + "\\"

sagawa_data = []
result = []
data = []
CSV.foreach(desktop + "send_yafuoku_" + today + ".csv"){|f| sagawa_data << f if f[7] == "sagawa"}

CSV.foreach("./data/prepare_#{account}.csv"){|x| data << x }

sagawa_data.each_with_index do |d,index|
	next if d == nil || account != d[3]
  id = d[1]
	array = []

  data.each_with_index do |original, i|
    if id == original[4]
      data.delete_at(i)
      array = original
      break
    end
  end
  
	array[1] = d[0]
  array[1] = array[1][0,8].gsub(" ","") if array[1] !~ /^[a-zA-Z]/ #長い文字列は取り込み不可のため
  array[16] = "0" + array[16].to_s if array[16] !~ /^0/ #電話番号がexcelの自動で先頭の0を消す機能によって消えた場合に0を追加する
  array[19] = account_info[:address]
  array[20] = account_info[:name]
  array[21] = account_info[:phone]

	result << array
end
	
CSV.open(desktop + "sagawa_address_yafuoku_" + today + ".csv","w"){|f| result.each{|d| f << d}}
p "complete"
