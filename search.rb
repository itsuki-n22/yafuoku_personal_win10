#encoding: windows-31j
require_relative 'component/components'

#############
dir = Dir.pwd
query = ARGV[0] if ARGV[0]
unless ARGV[0]
  puts "search [調べたい情報] と入力してください。"
  exit 
end
puts "キーワード: #{query}\n\n"

targets = Dir.glob("sale/*").map{|d| d.split("/").last.split("_").first}

dup =[]
targets.each do |target|
  target_file = dir + "/sale/#{target}_sale.csv"
  dup << ["■■■■#{target}■■■■"]
  CSV.foreach(target_file) do |line|
    dup << line if /#{query}/ =~ line[1] || /#{query}/ =~ line[2] || /#{query}/ =~ line[13] || /#{query}/ =~ line[16] || /#{query}/ =~ line[9] || /#{query}/ =~ line[12] || /#{query}/ =~ line[15] || /#{query}/ =~ line[4] || /#{query}/ =~ line[5] || /#{query}/ =~ line[14] #12は発送日#9は合計金額
  end
end

dup.each_with_index do |d, index|
  next if d[1] == nil
  [1,4,5,9,12,13,14,15,16,2].each do |num|
    print d[num] + " " if d[num]
  end
  puts "\n\n"
end

CSV.open(account_info[:desktop_dir] + "/yafuoku_search_result.csv","w") do |f|
	dup.each{|d| f << d}
end
p "yafuoku_search_result.csv has been made"
