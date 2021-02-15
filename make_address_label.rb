#encoding:windows-31j
require_relative 'component/components'

account = account_info[:account]
postal_code = account_info[:postal_code]
address = account_info[:address]
name = account_info[:name]
phone = account_info[:phone]
today = Date.today.to_s.gsub('-','')
desktop = account_info[:desktop_dir] + "\\"

raw_data = []
send_data = []
address_data = []
CSV.foreach("./data/prepare_#{account}.csv"){|x| raw_data << x}
CSV.foreach(desktop + 'send_yafuoku_' + Date.today.to_s + '.csv'){|x| send_data << x}

sender_info = ["■配送元 〒#{postal_code}",address,"#{name} TEL: #{phone ||= ''} "]

send_data.each do |d|
  product = "product: " + d[0][0..29]
  id = d[1]
  buyer = d[2]
  seller = d[3]
  delivery = d[7]
  track_info = d[8]
  track_info = "★" + track_info if track_info != nil
  track_info = "" if track_info == nil
  address = ""
  tel = "TEL:"
  post_num = "■配送先■ "

  next if delivery == "fba" || delivery == "sagawa" || delivery == "x" || delivery == "yamato"

  case seller
  when account
    raw_data.each{|f| (post_num += f[14];tel += f[16]; address = f[15]; break) if f[4] == id }
    puts "住所を作成しました： id: #{id.to_s}"
  else
    next
  end

  if seller == account
    address_data << [
      post_num + " " + track_info,
      address,
      buyer + "   " + tel,
    ]  + sender_info + ["id:" + id + "  " + product] 
  end

end


sorted_address_data = []

address_data.each_with_index do |d,index|

  col = index % 2
  row = index / 2
  if col == 0
    sorted_address_data[row*9] = [d[0]]
    sorted_address_data[1 + row*9] = [d[1]]
    sorted_address_data[2 + row*9] = [d[2]]
    sorted_address_data[3 + row*9] = ["-------------------------------"]
    sorted_address_data[4 + row*9] = [d[3]]
    sorted_address_data[5 + row*9] = [d[4]]
    sorted_address_data[6 + row*9] = [d[5]]
    sorted_address_data[7 + row*9] = [d[6]]
    sorted_address_data[8 + row*9] = ["\t"]
  else
    sorted_address_data[row*9] << [d[0]]
    sorted_address_data[1 + row*9] << [d[1]]
    sorted_address_data[2 + row*9] << [d[2]]
    sorted_address_data[3 + row*9] << ["-------------------------------"]
    sorted_address_data[4 + row*9] << [d[3]]
    sorted_address_data[5 + row*9] << [d[4]]
    sorted_address_data[6 + row*9] << [d[5]]
    sorted_address_data[7 + row*9] << [d[6]]
    sorted_address_data[8 + row*9] << ["\t"]
  end
end

sorted_address_data.each_with_index do |d,index|
  sorted_address_data[index].flatten! if sorted_address_data[index] != nil
end


CSV.open(desktop +'address_yafuoku.csv',"w"){|f| sorted_address_data.each{|d| f << d}}

