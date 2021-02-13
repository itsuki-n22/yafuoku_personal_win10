#encoding: windows-31j
require "csv"
def product_ids
  hash = {}
  company_ids = {}
  array = []
  Dir.glob(__dir__ + "/../setting/products/*.csv").each do |target|
    CSV.foreach(target){|f| array << f }
  end
  array.each_with_index do |d, index|
    next if index == 0
    p_id = d.first
    company_ids[p_id] = p_id
    tmp_id = d[1].split(" ")
    tmp_id.each do |t_id|
      company_ids[t_id] = p_id
    end
  end
  hash[:company_ids] = company_ids
  hash
end

