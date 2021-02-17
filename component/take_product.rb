#encoding: windows-31j

def take_product(driver, company_ids, auc_id)
  url = 'https://page.auctions.yahoo.co.jp/jp/auction/' + auc_id
  driver.navigate.to url
  id = nil
  ##商品説明ページから ID だけの行を切り取り、それを会社IDに変換する。
  driver.find_element(:xpath, '//*[@class="ProductExplanation__commentBody"]').text.encode("cp932").split("\c\n").each do |d|
    d = d.strip
    id = company_ids[ d ] if company_ids[ d ] 
  end
  id 
end
