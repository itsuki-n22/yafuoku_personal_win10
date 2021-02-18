#encoding: windows-31j
require "csv"
require_relative "account_info"
def product_ids
  hash = {}
  company_ids = {}
  array = []

  if Dir.glob(__dir__ + "/../debug").empty? == false
    Dir.glob(__dir__ + "/../debug/products/*.csv").each do |target|
      CSV.foreach(target){|f| array << f }
    end
  else
    Dir.glob(__dir__ + "/../setting/products/*.csv").each do |target|
      CSV.foreach(target){|f| array << f }
    end
  end

  array.each_with_index do |d, index|
    next if index == 0
    p_id = d.first
    company_ids[p_id] = p_id
    if d[1]
      tmp_id = d[1].split(" ")
      tmp_id.each do |t_id|
        company_ids[t_id] = p_id
      end
    end
  end
  hash[:company_ids] = company_ids
  hash
end

