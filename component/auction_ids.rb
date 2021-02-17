#encoding: windows-31j
require "csv"
def auction_ids(account: nil)
  auction_ids = {}
  array = []

  return hash if account == nil
  CSV.foreach(__dir__ + "/../data/auction_ids_#{account}.csv"){|f| array << f } rescue nil
  array.each do |d|
    p_id = d.first
    d.each{ auction_ids[d] = p_id }
  end
  auction_ids
end

if __FILE__ == $0
  p auction_ids account: ARGV[0]
end
