#encoding:windows-31j
require 'csv'
require 'date'
require_relative 'component/account_info'
account = account_info[:account]
desktop = account_info[:desktop_dir] + "\\"
fba_data = account_info[:fba_data]

comment_data = []
send_data = []
CSV.foreach("./data/comment_#{account}.csv"){|x| comment_data << x}
CSV.foreach("./data/prepare_#{account}.csv"){|x| send_data << x }

result = [ %w(p_id 注文ID 購入者名 売場 支払金額 金額 ASIN FBA? 発送情報 url) ]

send_data.each_with_index do |d,index|
  next if d == nil
  place = account 
  p_id = d[1]
  asin = nil
  amazon_stock = 0

  if fba_data && fba_data[p_id]
    asin = fba_data[p_id][:asin] 
    amazon_stock = fba_data[p_id][:amazon_stock]
    amazon_stock ||= 0
  end

  memo = ""
  memo = "fba" if asin && amazon_stock > 0
  qunt = d[7].to_i
  p_id = p_id + "xx" + qunt.to_s if qunt > 1
  id = d[4]
  url = d[2]
  name = d[13]
  price1 = d[9]
  price2 = d[12]
  payment = d[11]
  input = ""
  input = payment if payment =~ /代金引換/

  comment = d[18]
  comment_data.each do |tmp|
    if tmp[0] == id
      comment = tmp[1]
      break
    end
  end
  result << [p_id,id,name,place,price2,price1,asin,memo,input,url,payment,comment]
end

CSV.open(desktop + 'send_yafuoku_' + Date.today.to_s + '.csv',"w"){|f| result.each{|d| f << d}}
puts "complete"
