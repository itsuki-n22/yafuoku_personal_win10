#encoding: windows-31j
require_relative 'component/components'

accounts = [account_info[:account]]
result = []

keyword = ARGV[0]

accounts.each do |account|
  CSV.foreach("./data/auction_ids_#{account}.csv"){ |f| result << f if f.first == keyword }
end

if result.size == 0
  accounts.each do |account|
    CSV.foreach("./data/auction_ids_#{account}.csv"){ |f| result << f if f.first =~ /#{keyword}/ }
  end
end

if result.size == 1
  puts result.first.first
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 120
  driver = Selenium::WebDriver.for :chrome , http_client: client
  driver.navigate.to 'https://page.auctions.yahoo.co.jp/jp/auction/' + result.first[1]
  puts "�����L�[����͂�����I�����܂��B"
  STDIN.gets.chomp
elsif result.size > 1
  puts "URL �������݂���܂���"
  result.each do |d|
    puts d.first
    puts 'https://page.auctions.yahoo.co.jp/jp/auction/' + d[1]
  end
else
  puts "�o�i�Ȃ��B�������́Ashuppin_list���N�����Ă��������x�T���Ă݂Ă�������"
end

