#encoding: windows-31j

def login_yahoo(account: nil, password: nil, driver: nil)
  puts "try login as #{account}"
  driver.navigate.to 'https://login.yahoo.co.jp/config/login'

  element = driver.find_element(:id => 'username')
  element.click
  element.send_keys account
  driver.find_element(:id => 'btnNext').click
  sleep 2
  if password
    element = driver.find_element(:id => 'passwd')
    element.send_keys password
    element.submit
  else
    p "�Ïؔԍ����p�X���[�h�����ĂˁB���̌�R�}���h�v�����v�g��enter����񉟂��Ă�"
    STDIN.gets.chomp
    element.submit rescue nil
  end

end
