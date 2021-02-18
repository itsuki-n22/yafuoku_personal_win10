#encoding: windows-31j
require "csv"
def account_info
  hash = {}
  hash[:stock_num] = {}
  hash[:fba_data] = {}

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

    when /fba_check\(y\/n\):/
      hash[:fba_check] = line.split("fba_check(y/n):").last.strip
    when /fba_data_file:/
      hash[:fba_data_file] = line.split("fba_data_file:").last.strip
    when /amazon_asin_column:/
      hash[:amazon_asin_column] = line.split("amazon_asin_column:").last.strip
    when /amazon_stock_column:/
      hash[:amazon_stock_column] = line.split("amazon_stock_column:").last.strip
    when /amazon_sku_column:/
      hash[:amazon_sku_column] = line.split("amazon_sku_column:").last.strip
    when /amazon_company_id_column:/
      hash[:amazon_company_id_column] = line.split("amazon_company_id_column:").last.strip

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

      when /fba_check\(y\/n\):/
        hash[:fba_check] = line.split("fba_check(y/n):").last.strip
      when /fba_data_file:/
        hash[:fba_data_file] = line.split("fba_data_file:").last.strip
      when /amazon_asin_column:/
        hash[:amazon_asin_column] = line.split("amazon_asin_column:").last.strip
      when /amazon_stock_column:/
        hash[:amazon_stock_column] = line.split("amazon_stock_column:").last.strip
      when /amazon_sku_column:/
        hash[:amazon_sku_column] = line.split("amazon_sku_column:").last.strip
      when /amazon_company_id_column:/
        hash[:amazon_company_id_column] = line.split("amazon_company_id_column:").last.strip
      end
    end
  end
  ###
  begin
    if !hash[:stock_file].nil? &&
       hash[:stock_file] != "" &&
       !hash[:stock_id_column].nil? &&
       hash[:stock_id_column] != "" &&
       !hash[:stock_num_column].nil? &&
       hash[:stock_num_column] != "" 
      stock_num_columns = hash[:stock_num_column].split(",")
      CSV.foreach(hash[:stock_file]) do |f|
        stock_num = 0
        stock_num_columns.each do |column|
          stock_num += f[ column.to_i ].to_i if f[ column.to_i ]
        end
        hash[:stock_num][ f[ hash[:stock_id_column].to_i ] ] = stock_num
      end
    end
  rescue => e
    puts e
    puts "在庫データを取得できませんでした"
  end

  begin 
    if hash[:fba_check] == "y" &&
       !hash[:fba_data_file].nil? &&
       hash[:fba_data_file] != "" &&
       !hash[:amazon_sku_column].nil? &&
       hash[:amazon_sku_column] != "" &&
       !hash[:amazon_stock_column].nil? &&
       hash[:amazon_stock_column] != "" &&
       !hash[:amazon_company_id_column].nil? &&
       hash[:amazon_company_id_column] != "" &&
       !hash[:amazon_asin_column].nil? &&
       hash[:amazon_asin_column] != "" 

      asin_column = hash[:amazon_asin_column].to_i
      sku_column = hash[:amazon_sku_column].to_i
      company_id_column = hash[:amazon_company_id_column].to_i
      amazon_stock_column = hash[:amazon_stock_column].to_i

      CSV.foreach(hash[:fba_data_file]) do |f|
        hash[:fba_data][ f[ company_id_column ] ] = {}
        hash[:fba_data][ f[ company_id_column ] ][:asin] = f[ asin_column ]
        hash[:fba_data][ f[ company_id_column ] ][:sku] = f[ sku_column ]
        hash[:fba_data][ f[ company_id_column ] ][:amazon_stock] = f[ amazon_stock_column ]
      end
    end
  rescue => e
    puts e
    puts "FBA発送データを取得できませんでした"
  end

  hash
end

if __FILE__ == $0
  p account_info
end
