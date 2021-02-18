#encoding:windows-31j
require_relative 'component/components'

account = account_info[:account]
desktop_dir = account_info[:desktop_dir]
fba_data = account_info[:fba_data]
today = Date.today.to_s
desktop = desktop_dir + "\\"

send_data = {}
result = []
data = []

CSV.foreach(desktop + "send_yafuoku_" + today + ".csv") do |d|
  if d[7] =~ /fba/i
    send_data[d[1]] = { id: d[1], product: d[0], account: d[3], asin: d[6]}
  end
end
CSV.foreach("./data/prepare_#{account}.csv"){|x| data << x }

data.each_with_index do |d,index|
  next if d == nil
  id = d[4]
  next unless id
  product_id = send_data[id][:product] 
  asin = fba_data[product_id][:asin]
  asin ||= send_data[id][:asin] 
  fba_stock = fba_data[product_id][:fba_stock]
  fba_stock ||= 0

  data[index][16] = "0" + data[index][16].to_s if data[index][16] !~ /^0/ #電話番号がexcelの自動で先頭の0を消す機能によって消えた場合に0を追加する

  if fba_stock > 1 && asin
    data[index][17] = asin 
  else
    data.delete_at(index)
  end
  
end
CSV.open(desktop + "prepare_a2" + today + ".csv","w"){|f| data.each{|d| f << d}}
p "complete"
