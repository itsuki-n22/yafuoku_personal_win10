#encoding: windows-31j
require_relative 'component/components'
check_if_only_one_send_file_exist
template = read_message_files
account = account_info[:account]
password = account_info[:password]
desktop = account_info[:desktop_dir]

list = read_send_file
#############
access = false
debug = true


#############################################

explain_btn='//*[@id="textarea"]'
sub_btn = '//*[@id="submitButton"]'
send_btn='//*[@id="yjMain"]/p[2]/input'
send_btn='//*[@id="yjMain"]/div[6]/input'
send_btn='//*[@id="yjMain"]/div[7]/input'
matomete_btn='//*[@id="yjMain"]/div[5]/a'
ok_btn1 = '//*[@id="yjMain"]/form/div[2]/input[2]'
ok_btn2 = '//*[@id="yjMain"]/form/div/input[2]'

end_flag = false
#############

1.times do |index| 
  driver = Selenium::WebDriver.for :chrome if access
  login_yahoo(account: account,password: password, driver: driver) if access

  list.each do |l|
    place = l[3]
    deliver = l[7]
    track_info = l[8]
    next unless place == account
    next if l[7] == "x" || l[7] == "q" || l[7] == "ｘ"
    next if l[8] == "x" || l[8] == "q" || l[8] == "ｘ"
    next if l[9] == "x" || l[9] == "q" || l[9] == "ｘ"
    next if l[10] == "x" || l[10] == "q" || l[10] == "ｘ"

    puts "オークションID:" + l[1]
    if deliver.nil? && track_info.nil?
      p "  発送情報がないので飛ばしました。"
      next
    elsif deliver =~ /fba/i && track_info.nil?
      p "  FBA発送情報がないので飛ばしました。"
      next
    end

    driver.navigate.to l[9] if access
    explain = ""
    if deliver =~ /fba/i
      explain = template[:amazon_fba].gsub("@arrive_data@", track_info)
    elsif deliver =~ /s/i
      explain = template[:basic].gsub("@track_url@", account_info[:sagawa_track_url]).gsub("@sender@", "佐川急便")
    elsif deliver =~ /y/i
      explain = template[:basic].gsub("@track_url@", account_info[:yamato_track_url]).gsub("@sender@", "ヤマト運輸")
    elsif /\d+/ =~ track_info
      explain = template[:basic].gsub("@track_url@", account_info[:postjp_track_url]).gsub("@sender@", "日本郵便")
    elsif /[te|て|定]/ =~ track_info
      explain = template[:teikeigai]
    end
    explain = explain.gsub("@email@", account + "@yahoo.co.jp").gsub("@track_number@", track_info)
    
    begin
      driver.find_element(:xpath => send_btn).click
      sleep 1
    rescue
      p "発送ボタンがないので飛ばします。"
      next
    end

    driver.find_element(:xpath => ok_btn1).click rescue retry
    sleep 1

    driver.find_element(:xpath => ok_btn2).click rescue retry
    sleep 1

    driver.find_element(:xpath => explain_btn).send_keys explain rescue retry
    sleep 1

    driver.find_element(:xpath => sub_btn).click rescue retry
    sleep 1
  end
  driver.quit
end
p "send_message complete"
