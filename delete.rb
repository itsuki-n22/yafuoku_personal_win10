#encoding: windows-31j
require_relative "component/components"
account = account_info[:account]

puts "#{account} �Ɋւ���f�[�^�̍폜�����܂��B"

query = ARGV[0] if ARGV[0]
unless ARGV[0]
  puts "delete [�Ώۂ̃I�[�N�V����ID] �Ɠ��͂��Ă��������B"
  exit
end

target_file = "./sale/#{account}_sale.csv"
target_file2 = "./data/untreat_#{account}.txt"
read_data =[]
CSV.foreach(target_file){|d|read_data << d }
read_data.each{|d| p d if d.include?(query)}

puts "����f�[�^�̂���������Ă������ł����H y/n"
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
puts "�������̉\�������閈���m�F���郊�X�g�̂����A����������Ă������ł����H"
cmd = STDIN.gets.chomp

if cmd == "y"
  read_data.delete_if{|d| d.include?(query) }
  read_data.each{|d| p d if d.include?(query)}
  read_data = read_data.join("\n")
  File.open(target_file2,"w"){|f| f.write read_data}
end
puts "�����I"
