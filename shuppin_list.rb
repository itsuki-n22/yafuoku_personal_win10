#encoding: windows-31j
require_relative 'component/components'

company_ids = product_ids[:company_ids]
accounts = [account_info[:account]]

client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 120
driver = Selenium::WebDriver.for :chrome , http_client: client

data =[]
other_ids =[]
accounts.each do |account|
  auction_ids = auction_ids(account: account)
  url = 'https://auctions.yahoo.co.jp/seller/' + account + '?n=100&mode=2'
  driver.navigate.to url
  count = 0
  loop do
    sleep 2
    watch_path ='//*[@id="list01"]/table/tbody/tr/td[2]/div/h3/a' 
    img_path = '//*[@id="list01"]/table/tbody/tr/td[1]/div/table/tbody/tr/td/a/img'
    price_path = '//*[@id="list01"]/table/tbody/tr/td[3]'
    driver.find_elements(:xpath => watch_path).each_with_index do |d,i|
      data[i + count * 100] = []
			data[i + count * 100] << d.text.encode('cp932') rescue nil
			data[i + count * 100] << d.attribute('href').split("/").last rescue nil
    end
    driver.find_elements(:xpath => price_path).each_with_index do |d,i|
			data[i + count * 100] << d.text.encode('cp932').gsub(',',"").split('円').first  rescue nil
    end
    count += 1
    sleep 3

    next_path =  '//*[@id="ASsp1"]/p[@class="next"]/a'
    begin
    if driver.find_element(:xpath => next_path)
      p driver.find_element(:xpath => next_path).attribute('href')
      driver.find_element(:xpath => next_path).click
    else
      p "break"
      break
    end
    rescue
      break
    end
  end

  data.each_with_index do |d,i|
    name = d[0]
    auc_id = d[1]
    other_id ||= auction_ids[name] 
		other_id ||= auction_ids[auc_id] 
    unless other_id
      company_id = take_product(driver, company_ids, auc_id)
    else
      company_id = other_id
    end
		other_ids << [company_id, auc_id, name]
    stock_num = account_info[:stock_num][company_id]
    data[i] << company_id
    data[i] << stock_num
  end
	auction_ids = auction_ids_csv(account: account)
	auction_ids.delete_if do |d|
		company_id = d.first
		flag = false
		other_ids.each{ |x| flag = true if x[0] == company_id }
		flag
	end
	other_ids
	auction_ids
	other_ids += auction_ids

	CSV.open("./data/auction_ids_#{account}.csv","w"){ |f| other_ids.to_a.each{|d| f << d} }
end


CSV.open(account_info[:desktop_dir] + "\\yafuoku_shuppin_ichiran.csv","w") do |f|
  data.each{|d| f << d}
end

puts "yafuoku_shuppin_ichiran.csv was made"
puts "complete!"
