#encoding: windows-31j

require "fileutils"
require "date"
require_relative 'component/account_info'

desktop = account_info[:desktop_dir].gsub("\\","/")
today = Date.today.to_s

Dir.glob("#{desktop}/*").delete_if{|f| f !~ /send_.*\.csv|sagawa_address_.*\.csv|address_.*\.csv/ }.each do |f|
  FileUtils.move(f, __dir__ + "/sent")
	puts f + "�� sent/ �Ɉړ����܂���"
end
