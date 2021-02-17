#encoding: windows-31j
require_relative 'component/components'

init ##�t�H���_���Ȃ��ꍇ���̃A�J�E���g�p�̃t�H���_���쐬
account = account_info[:account]
password = account_info[:password]
car_pids = product_ids[:company_ids]
puts "�p�X���[�h��ʂ��J�����烍�O�C�����āA���O�C����ɂ��̍�����ʂ�enter����͂��Ă�"

#### �t�@�C���ǂݍ��݁A�ŐV�����̎��o��
target_file = Dir.pwd + '\\sale\\' + account + '_sale.csv'
old_date = Time.now - 31536000
CSV.foreach(target_file) do |line|
  break if line[3] == nil
  old_date = Time.parse(line[3])
  break
end
read_data = CSV.open(target_file).read
puts "�ŐV�f�[�^�̗��D��:" + old_date.to_s
####

prepare = []
change = []
data =[]
delete_data=[]
comment_data = []

untreat = File.open("./data/untreat_#{account}.txt","r").read
end_flag = false

driver = Selenium::WebDriver.for :chrome # , http_client: client
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 120
login_yahoo(account: account, password: password, driver: driver)

def take_product(driver, car_pids, auc_id)
  url = 'https://page.auctions.yahoo.co.jp/jp/auction/' + auc_id
  driver.navigate.to url
  id = nil
  driver.find_element(:xpath, '//*[@class="ProductExplanation__commentBody"]').text.encode("cp932").split("\c\n").each do |d|
    d = d.strip
    id = car_pids[ d ] if car_pids[ d ] 
  end
  id 
end

#####################
x_closes = '//*[@id="acWrContents"]/div/table/tbody/tr/td/table/tbody/tr[3]/td/table[2]/tbody/tr/td[5]'
x_trade_urls = '//*[@id="acWrContents"]/div/table/tbody/tr/td/table/tbody/tr[3]/td/table[2]/tbody/tr/td[8]/table/tbody/tr[1]/td/a'
x_product = '//*[@id="acConHeader"]/div[2]/dl/dd[1]'
x_qunt = '//*[@id="acConHeader"]/div[2]/dl/dd[2]/span'
x_price = '//*[@id="acConHeader"]/div[2]/dl/dd[2]'
x_close = '//*[@id="acConHeader"]/div[2]/dl/dd[3]'
x_aucid = '//*[@id="acConHeader"]/div[2]/dl/dd[4]/p'
x_userid = '//*[@id="acConHeader"]/div[2]/dl/dd[5]/p'
x_click = '//*[@id="yjMain"]/div/div/div[2]/p/a'
x_address = x_postnum = '((//*[@class="decInTblCel"])[1]//div[@class="decCnfWr"])[2]'
x_name = '((//*[@class="decInTblCel"])[1]//div[@class="decCnfWr"])[1]'
x_tel = '((//*[@class="decInTblCel"])[1]//div[@class="decCnfWr"])[3]'
x_send_price = '((//*[@class="decInTblCel"])[1]//div[@class="decCnfWr"])[4]'
x_status = '//*[@class="libTableCnfTop"][5]//*[@class="decCnfWr"]'
x_payway = '//*[@id="yjMain"]/div/div/div[3]/div[2]/table/tbody/tr/td/div/table/tbody/tr/td/div'
###########################################untreat.txt����
untreat_urls = untreat.split("\n")
puts untreat_urls.size.to_s + "�̖������̎�����`�F�b�N���܂�"
untreat = ""

untreat_urls.each do |url|
  driver.navigate.to url
  puts url
  
  status = 0
  product=""
  close=""
  price=""
  aucid=""
  userid=""
  qunt=""
  send_price="0"
  amount=""
  name=""
  postnum=""
  address=""
  tel=""
  payday = ""
  sentday=""
  payway =""
  ############################################�������D�҂�����ꍇ
  x_multi = '//*[@id="acWrContents"]/div/div/h1'
  x_extraurl = '//*[@id="acWrContents"]/div/table/tbody/tr/td/table/tbody/tr/td/div[2]/table/tbody/tr/td[5]/div[1]/a'

  begin
    if driver.find_element(:xpath,x_multi)
      puts "�������D��"
      driver.find_elements(:xpath => x_extraurl).each{|x|  urls << x.attribute('href')}
      next
    end
  rescue
  end

  driver.find_elements(:xpath,'//*[@id="yjMain"]/div/div/p').each do |element|
    if element.text.encode('cp932') =~ /�폜�ς�/
      puts "�폜�ς�"
      delete_data << url
      next
    end
  rescue
  end

  begin 
    if driver.find_element(:xpath,'//*[@id="plibLoadMdlInner"]/div/div[2]/input') 
      puts "���M�s�� or �A���҂�"
      untreat += url + "\n" 
      next
    end
  rescue
  end

  begin
    if driver.find_element(:xpath, '//*[@id="plibLoadMdlInner"]/div/div[2]/div[2]/a')
      puts "�܂Ƃ߂Ĕ���"
      untreat += url + "\n" 
      next
    end
  rescue
  end
  ############################################�㕔

  # "�ڍ׃f�[�^�\���{�^�����N���b�N  "
  driver.find_element(:xpath => x_click).click rescue retry
  
  userid = driver.find_element(:xpath,'//dd[@class="decBuyerID"]').text.encode('cp932', undef: :replace).split(/\s/).last.split('�i').first
  tmp = driver.find_element(:xpath,'//dd[@class="decPrice"]').text.encode('cp932', undef: :replace).scan(/([\d\,]+)/).flatten
  qunt = tmp[0]
  price = tmp[1].gsub(',','')
  driver.find_elements(:xpath, x_product).each{|f| product = f.text.encode('cp932', undef: :replace)}
  driver.find_elements(:xpath, x_close).each do |f|
     tmp = f.text.encode('cp932', undef: :replace).split('�F ')[1]
     close = time_parse(str: tmp).to_s
  end
  aucid = driver.find_element(:xpath, x_aucid).text.encode('cp932', undef: :replace).split('ID�F ')[1]

  ###########################################����
  begin  ##�܂Ƃ߂Ď���̕t�����i�ł���ꍇ
    driver.find_element(:xpath,'//*[@id="yjMain"]/div/a[@class="libBtnGrayL"]').click
    sleep 1
    driver.find_element(:xpath => x_click).click rescue retry
  rescue
  end  

  send_price = driver.find_element(:xpath => x_send_price).text.encode('cp932', undef: :replace).scan(/([\d\,]+)/).flatten.last.gsub(',','') rescue nil

  begin
    driver.find_elements(:xpath => x_payway).each do |f|
      payway = f.text.encode('cp932', undef: :replace)
      break
    end
  rescue
  end

  begin ## diff
    driver.find_element(:xpath => x_name).text  ##�܂Ƃ߃p�[�g
  rescue
    puts "matome:���M�s�� or �A���҂�"
    untreat += url + "\n" 
    next
  end
  name = driver.find_element(:xpath => x_name).text.encode('cp932', undef: :replace)
  tmp = driver.find_element(:xpath => x_postnum).text.encode('cp932', undef: :replace).split(/[\n]/)
  postnum = tmp[0]
  address = tmp[1]
  tel = driver.find_element(:xpath => x_tel).text.encode('cp932', undef: :replace)
  
  driver.find_elements(:xpath,x_status ).reverse.each_with_index do |f,index|
    if /�󂯎��/ =~ f.text.encode('cp932', undef: :replace)
      status = 4
    end
    if /�����̘A��/ =~ f.text.encode('cp932', undef: :replace)
      status = 3
      tmp = f.find_element(:css,'span').text.encode('cp932', undef: :replace)
      sentday = time_parse(str: tmp).to_s
    end
    if /�x��������/ =~ f.text.encode('cp932', undef: :replace)
      status = 2
      tmp = f.find_element(:css,'span').text.encode('cp932', undef: :replace)
      payday = time_parse(str: tmp).to_s
    end
    if /���͂����/ =~ f.text.encode('cp932', undef: :replace)
      status = 1
    end
  end

  if status == 2
    tmp = []
    driver.find_elements(:xpath,'//*[@id="messagelist"]/dl').each{|f| tmp << f.text.encode('cp932', undef: :replace)}
    comment_data << [aucid,tmp]
  end

  amount = send_price.to_i + price.to_i * qunt.to_i
  #########################���σ`�F�b�N#
  moji = /��斾��/
  paied = nil
  see_detail = nil
  target = '//td/table/tbody/tr/td/div[@class="decCnfWr"]|//td/table/tbody/tr/th/div[@class="decCnfWr"]'
  driver.find_elements(:xpath, target).each do |f|
    x = f.text.encode('cp932', undef: :replace)
    if moji =~ x
      see_detail = f.find_element(:xpath, 'a').attribute('href')
    end

  end
  if see_detail
    begin
      driver.navigate.to see_detail
      sleep 2
      paied = driver.find_element(:xpath ,'//dl[@class="itemize"]/dd[@class="u-fontSize14"]').text.scan(/([\d\,]+)/).flatten.last
      x_shinsachu = '//*[@id="rcvdtl"]/ul/li[2]/dl/dd'
    rescue
      puts "�G���[���������܂����B���O�C���o���Ă��Ȃ��ꍇ�̓��O�C�����Ă��������B���̌�R�}���h�v�����v�g��enter�������ĉ������B"
      STDIN.gets.chomp
    end

    paied = "�R����" if driver.find_element(:xpath ,x_shinsachu).text.encode('cp932') =~ /�R����/
    x_cancel = '//*[@id="rcvdtl"]/ul/li[2]/dl'
    paied = "�L�����Z��" if driver.find_element(:xpath ,x_cancel).text.encode('cp932') =~ /�L�����Z��/
  end
  ###########################################
  puts product = take_product(driver, car_pids, aucid) if take_product(driver, car_pids, aucid)
 
  prepare << [status,product,url,close,aucid,userid,price,qunt,send_price,amount,payday,payway,paied,name,postnum,address,tel] if status == 2

  if status == 1 || status == 0 || status == 2
    untreat += url + "\n" 
  else
    change << [status,product,url,close,aucid,userid,price,qunt,send_price,amount,payday,payway,sentday,name,postnum,address,tel] 
  end
end
#####################
(1..10).each do |page| ##�֋X�I��1-10�ɂ��Ă邯�ǁA�K�X�ύX���ĂˁBdebug
  #####################
  #####################
  url = 'https://auctions.yahoo.co.jp/closeduser/jp/show/mystatus?select=closed&hasWinner=1&apg=' + page.to_s
  driver.navigate.to url
  #####################               1

  target_num = 0
  driver.find_elements(:xpath => x_closes).each_with_index do |cdate,index| #
    print index.to_s + " "
    next if index == 0  
    
    new_date = time_parse(str: cdate.text.encode('cp932'))
    new_date = time_parse(str: cdate.text.encode('cp932'), year: Time.new.year - 1) if new_date.month == 12 && old_date.month == 12 && new_date.year != old_date.year ###january

    if new_date > old_date
      target_num = index
    else
      end_flag = true
      break
    end
  end

  urls =[]
  driver.find_elements(:xpath => x_trade_urls).each_with_index do |url,index|
    break if index >= target_num
    urls <<  url.attribute('href')
  end
  urls.each do |url|
    next if untreat_urls.include?(url) ##diff
    driver.navigate.to url
    p url
    
    #sleep 2
    status = 0
    product=""
    close=""
    price=""
    aucid=""
    userid=""
    qunt=""
    send_price="0"
    amount=""
    name=""
    postnum=""
    address=""
    tel=""
    payday = ""
    sentday=""
    payway =""
    ############################################�������D�҂�����ꍇ
    x_multi = '//*[@id="acWrContents"]/div/div/h1'
    x_extraurl = '//*[@id="acWrContents"]/div/table/tbody/tr/td/table/tbody/tr/td/div[2]/table/tbody/tr/td[5]/div[1]/a'

    begin
    if driver.find_element(:xpath,x_multi)
      p "�������D��"
      
      driver.find_elements(:xpath => x_extraurl).each do |x|
      urls << x.attribute('href')

      end
      next

    end
    rescue
    end

    x_error = '//*[@id="plibLoadMdlInner"]/div/div[2]/input'
    begin 
      if driver.find_element(:xpath,x_error) || driver.find_element(:xpath,x_matome)
        p "�ڍז���"
    untreat += url + "\n" 
    userid = driver.find_element(:xpath,'//dd[@class="decBuyerID"]').text.encode('cp932', undef: :replace).split(/\s/).last.split('�i').first
    tmp = driver.find_element(:xpath,'//dd[@class="decPrice"]').text.encode('cp932', undef: :replace).scan(/([\d\,]+)/).flatten
     qunt = tmp[0]
     price = tmp[1].gsub(',','')
    driver.find_elements(:xpath, x_product).each do |f|
       product = f.text.encode('cp932', undef: :replace)
    end
    driver.find_elements(:xpath, x_close).each do |f|
       tmp = f.text.encode('cp932', undef: :replace).split('�F ')[1]
       close = time_parse(str: tmp).to_s
    end
    aucid = driver.find_element(:xpath, x_aucid).text.encode('cp932', undef: :replace).split('ID�F ')[1]


    data << [status,product,url,close,aucid,userid,price,qunt,send_price,amount,payday,payway,sentday,name,postnum,address,tel]
        next
      end
    rescue
    end
    ############################################�㕔

    begin
    driver.find_element(:xpath => x_click).click
    rescue
      retry
    end
     userid = driver.find_element(:xpath,'//dd[@class="decBuyerID"]').text.encode('cp932', undef: :replace).split(/\s/).last.split('�i').first
    tmp = driver.find_element(:xpath,'//dd[@class="decPrice"]').text.encode('cp932', undef: :replace).scan(/([\d\,]+)/).flatten
     qunt = tmp[0]
     price = tmp[1].gsub(',','')
    driver.find_elements(:xpath, x_product).each do |f|
       product = f.text.encode('cp932', undef: :replace)
    end
    driver.find_elements(:xpath, x_close).each do |f|
       tmp = f.text.encode('cp932', undef: :replace).split('�F ')[1]
       close = time_parse(str: tmp).to_s
    end
    aucid = driver.find_element(:xpath, x_aucid).text.encode('cp932', undef: :replace).split('ID�F ')[1]

    ###########################################����
    begin  ##�܂Ƃ߂Ď���̕t�����i�ł���ꍇ
      driver.find_element(:xpath,'//*[@id="yjMain"]/div/a[@class="libBtnGrayL"]').click
      sleep 1
      begin
      driver.find_element(:xpath => x_click).click
      rescue => e
        p e
        retry
      end
    rescue

    end  #####
    begin
     send_price = driver.find_element(:xpath => x_send_price).text.encode('cp932', undef: :replace).scan(/([\d\,]+)/).flatten.last.gsub(',','')
    rescue
    end
    begin
      driver.find_elements(:xpath => x_payway).each do |f|
       payway = f.text.encode('cp932', undef: :replace)
       break
      end
    rescue
    end
    begin
     name = driver.find_element(:xpath => x_name).text.encode('cp932', undef: :replace)
    tmp = driver.find_element(:xpath => x_postnum).text.encode('cp932', undef: :replace).split(/[\n]/)
     postnum = tmp[0]
     address = tmp[1]
    rescue ###########�O��C���ʒu
      untreat += url + "\n" 
      data << [status,product,url,close,aucid,userid,price,qunt,send_price,amount,payday,payway,sentday,name,postnum,address,tel]
      next
    end
     tel = driver.find_element(:xpath => x_tel).text.encode('cp932', undef: :replace)
     driver.find_elements(:xpath,x_status ).reverse.each_with_index do |f,index|

      if /�󂯎��/ =~ f.text.encode('cp932', undef: :replace)
        status = 4
      end
      if /�����̘A��/ =~ f.text.encode('cp932', undef: :replace)
        status = 3
        tmp = f.find_element(:css,'span').text.encode('cp932', undef: :replace)
        sentday = time_parse(str: tmp).to_s
      end
      if /�x��������/ =~ f.text.encode('cp932', undef: :replace)
        status = 2
        tmp = f.find_element(:css,'span').text.encode('cp932', undef: :replace)
        payday = time_parse(str: tmp).to_s
      end
      if /���͂����/ =~ f.text.encode('cp932', undef: :replace)
        status = 1
      end
    end
      if status == 2
        tmp = []
        target  = '//*[@id="messagelist"]/dl'
        driver.find_elements(:xpath,target ).each_with_index do |f,index|
          tmp << f.text.encode('cp932', undef: :replace)
        end
        comment_data << [aucid,tmp]
      end

    amount = send_price.to_i + price.to_i * qunt.to_i
    #########################���σ`�F�b�N#
   moji = /��斾��/
   paied = nil
   see_detail = nil
   target = '//td/table/tbody/tr/td/div[@class="decCnfWr"]|//td/table/tbody/tr/th/div[@class="decCnfWr"]'
   driver.find_elements(:xpath, target).each do |f|
     x = f.text.encode('cp932', undef: :replace)
     if moji =~ x
       see_detail = f.find_element(:xpath, 'a').attribute('href')
     end

   end
   see_detail
   if see_detail
   driver.navigate.to see_detail
   sleep 2
  begin
   #paied = driver.find_element(:xpath ,'//dl[@class="itemize"]/dd[@class="mB10"]').text.scan(/([\d\,]+)/).flatten.last
   paied = driver.find_element(:xpath ,'//dl[@class="itemize"]/dd[@class="u-fontSize14"]').text.scan(/([\d\,]+)/).flatten.last

  rescue
    begin
      sleep 2
      if
        login(driver,2)
      end
    rescue
      p "�G���[�Benter����������Ď��s���܂��B"
      STDIN.gets.chomp
    end
    retry
  end

   x_shinsachu = '//*[@id="rcvdtl"]/ul/li[2]/dl/dd'
   if driver.find_element(:xpath ,x_shinsachu).text.encode('cp932') =~ /�R����/
     paied = "�R����"
   end
   end
    ###########################################
    data << [status,product,url,close,aucid,userid,price,qunt,send_price,amount,payday,payway,sentday,name,postnum,address,tel]
    
    product = take_product(driver, car_pids, aucid) if take_product(driver, car_pids, aucid)
    prepare << [status,product,url,close,aucid,userid,price,qunt,send_price,amount,payday,payway,paied,name,postnum,address,tel] if status == 2
    untreat += url + "\n" if status == 1 || status == 0 || status == 2
  end

  break if end_flag == true #���̃y�[�W���p�[�X���Ȃ�
end


#####################
puts prepare.size.to_s + "�̔���"
puts untreat.split("\n").size.to_s + "�̖�����"
puts change.size.to_s + "�̃X�e�[�^�X�ω�"
puts "�폜�F" + delete_data.size.to_s
####�����t�@�C�������o��
File.open("./data/untreat_#{account}.txt","w"){ |f| f.write untreat }
CSV.open("./data/prepare_#{account}.csv","w"){|csv|  prepare.each{|d| csv << d} }
####�{�f�[�^�����o��
read_data.each_with_index do |d,index|
  change.each do |cdata|
    read_data[index] = cdata if cdata[4] == d[4]
  end
end
###�폜�ς݃f�[�^���폜
read_data.delete_if{|d| delete_data.include?(d[2]) }

###�f�[�^�����o��
data = data + read_data
CSV.open(target_file,"w"){|f| data.each{|d| f << d}}
CSV.open("./data/comment_#{account}.csv","w"){|f| comment_data.each{|d| f << d}}
p 'complete! made ' + target_file
driver.quit
