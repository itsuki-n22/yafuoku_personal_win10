#encoding: windows-31j

def take_product(driver, company_ids, auc_id="")
  url = 'https://page.auctions.yahoo.co.jp/jp/auction/' + auc_id
  driver.navigate.to url
	sleep 1
  id = nil
	debug_count = 0
  ##商品説明ページから ID だけの行を切り取り、それを会社IDに変換する。
	begin 
		driver.find_element(:xpath, '//*[contains(@class, "ProductExplanation__commentBody")]').text.encode("cp932").split("\c\n").each do |d|
			d = d.strip
			id = company_ids[ d ] if company_ids[ d ] 
		end
	rescue => e
		driver.find_elements(:xpath, '//*[contains(@class,"prMdl__close")]').each do |element|
			element.click rescue nil
		end
		debug_count += 1
		retry if debug_count < 3
	end
  id 
end
