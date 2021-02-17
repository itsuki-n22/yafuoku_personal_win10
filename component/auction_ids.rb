#encoding: windows-31j
require "csv"
def auction_ids(account: nil)
  auction_ids = {}
  array = []

  return hash if account == nil
  CSV.foreach(__dir__ + "/../data/auction_ids_#{account}.csv"){|f| array << f } rescue nil
  array.each do |d|
    p_id = d.first
    d.each{|f| auction_ids[f] = p_id }
  end
  auction_ids
end

def auction_ids_csv(account: nil)
  array = []
  return hash if account == nil
  CSV.foreach(__dir__ + "/../data/auction_ids_#{account}.csv"){|f| array << f } rescue nil
	array
end

if __FILE__ == $0
 p auction_ids(account: ARGV[0])
 p auction_ids_csv(account: ARGV[0])
 p auction_ids(account: ARGV[0]).to_a
end
