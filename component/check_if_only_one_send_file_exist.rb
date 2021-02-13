#encoding:windows-31j
#
require_relative "account_info"

def check_if_only_one_send_file_exist
  files = Dir.glob(account_info[:desktop_dir].gsub("\\","/") + "/*").delete_if{|f| f !~ %r{/send_.*\.csv} }
  if files.size > 1
    puts "デスクトップに名前がsend_から始まるCSVファイルが#{files.size}個存在します。1つにしてください"
    exit
  elsif files.size == 0
    puts "デスクトップに名前がsend_から始まるCSVファイルが存在しません。prepare.rbを実行して作製してください"
    exit
  end
end
