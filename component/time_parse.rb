#encoding:windows-31j

def time_parse(str: "", year: nil)
  str = str.encode("cp932")
  return nil if str == nil
  match = str.scan(/\d+/) 

  year ||= Time.new.year
  day = [year]
  return false unless match.size == 4
  day += match
  day.map!(&:to_i)
  Time.new(day[0],day[1],day[2],day[3],day[4])
end

if __FILE__ == $0
  str = ARGV[0]
  p time_parse(str: str, year: Time.new.year - 1)
end
