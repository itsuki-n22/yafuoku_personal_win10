#encoding: windows-31j
require_relative "component/components"
account = account_info[:account]

puts "#{account} に関するデータの削除をします。"

query = ARGV[0] if ARGV[0]
unless ARGV[0]
  puts "delete [対象のオークションID] と入力してください。"
  exit
end

target_file = "./sale/#{account}_sale.csv"
target_file2 = "./data/untreat_#{account}.txt"
read_data =[]
CSV.foreach(target_file){|d|read_data << d }
read_data.each{|d| p d if d.include?(query)}

puts "売上データのこれを消してもいいですか？ y/n"
cmd = STDIN.gets.chomp
if cmd == "y"
  read_data.delete_if{|d| d.include?(query) }
  read_data.each{|d| p d if d.include?(query)}
  CSV.open(target_file,"w") do |f|
    read_data.each do |d|
      f << d
    end
  end
end
read_data =[]
read_data = File.open(target_file2,"r").read.split("\n")
read_data.each{|d| p d if d.include?(query)}
puts "未発送の可能性がある毎日確認するリストのうち、これを消してもいいですか？"
cmd = STDIN.gets.chomp

if cmd == "y"
  read_data.delete_if{|d| d.include?(query) }
  read_data.each{|d| p d if d.include?(query)}
  read_data = read_data.join("\n")
  File.open(target_file2,"w"){|f| f.write read_data}
end
puts "完了！"
