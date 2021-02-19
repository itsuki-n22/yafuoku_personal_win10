#encoding: windows-31j

require_relative "component/components"
data = []
word = ARGV[0]
CSV.foreach(account_info[:stock_file]){|f| data << [f[5],f[6],f[7],f[8],f[9],f[17]] }

result =  [ %w(p_id sku asin fba-stock stock price) ]
data.each do |d|
  p_id = d[0]
  sku = d[1]
  asin = d[2]
  fba_stock = d[3]
  stock = d[4]
  price = d[5]
  if p_id =~ /#{word}/ || sku =~ /#{word}/ || asin =~ /#{word}/
    result << d
  end
end

result.each do |d|
  p d
end
