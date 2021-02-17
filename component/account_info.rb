#encoding: windows-31j
require "csv"
def account_info
  hash = {}
  File.open(__dir__ + "/../setting/info.txt").read.each_line do |line|
    case line
    when /desktop_dir:/
      hash[:desktop_dir] = line.split("desktop_dir:").last.strip
    when /stock_file:/
      hash[:stock_file] = line.split("stock_file:").last.strip
    when /stock_id_column:/
      hash[:stock_id_column] = line.split("stock_id_column:").last.strip
    when /stock_num_column:/
      hash[:stock_num_column] = line.split("stock_num_column:").last.strip
    when /sagawa_track_url:/
      hash[:sagawa_track_url] = line.split("sagawa_track_url:").last.strip
    when /postjp_track_url:/
      hash[:postjp_track_url] = line.split("postjp_track_url:").last.strip
    when /yamato_track_url:/
      hash[:yamato_track_url] = line.split("yamato_track_url:").last.strip
    end
  end
  CSV.foreach(__dir__ + "/../setting/pass.csv") do |f|
    next if f[1] == "password"
    hash[:account] = f[0]
    hash[:password] = f[1]
    hash[:postal_code] = f[2]
    hash[:address] = f[3]
    hash[:name] = f[4]
    hash[:phone] = f[5]
  end
  ### debug
  if Dir.glob(__dir__ + "/../debug").empty? == false
    CSV.foreach(__dir__ + "/../debug/pass.csv") do |f|
      next if f[1] == "password"
      hash[:account] = f[0]
      hash[:password] = f[1]
      hash[:postal_code] = f[2]
      hash[:address] = f[3]
      hash[:name] = f[4]
      hash[:phone] = f[5]
    end
    File.open(__dir__ + "/../debug/info.txt").read.each_line do |line|
      case line
      when /desktop_dir:/
        hash[:desktop_dir] = line.split("desktop_dir:").last.strip
      when /stock_file:/
        hash[:stock_file] = line.split("stock_file:").last.strip
      when /stock_id_column:/
        hash[:stock_id_column] = line.split("stock_id_column:").last.strip
      when /stock_num_column:/
        hash[:stock_num_column] = line.split("stock_num_column:").last.strip
      end
    end
  end
  ###
  if !hash[:stock_file].nil? &&
     hash[:stock_file] != "" &&
     !hash[:stock_id_column].nil? &&
     hash[:stock_id_column] != "" &&
     !hash[:stock_num_column].nil? &&
     hash[:stock_num_column] != "" 
    hash[:stock_num] = {}
    stock_num_columns = hash[:stock_num_column].split(",")
    CSV.foreach(hash[:stock_file]) do |f|
      stock_num = 0
      stock_num_columns.each do |column|
        stock_num += f[ column.to_i ].to_i if f[ column.to_i ]
      end
      hash[:stock_num][ f[ hash[:stock_id_column].to_i ] ] = stock_num
    end
  end

  hash
end

if __FILE__ == $0
  p account_info
end
