#encoding:windows-31j
#
require_relative "account_info"

def check_if_only_one_send_file_exist
  files = Dir.glob(account_info[:desktop_dir].gsub("\\","/") + "/*").delete_if{|f| f !~ %r{/send_.*\.csv} }
  if files.size > 1
    puts "�f�X�N�g�b�v�ɖ��O��send_����n�܂�CSV�t�@�C����#{files.size}���݂��܂��B1�ɂ��Ă�������"
    exit
  elsif files.size == 0
    puts "�f�X�N�g�b�v�ɖ��O��send_����n�܂�CSV�t�@�C�������݂��܂���Bprepare.rb�����s���č쐻���Ă�������"
    exit
  end
end
