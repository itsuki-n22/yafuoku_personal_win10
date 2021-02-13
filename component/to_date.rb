#encoding:windows-31j

def to_date(str)
	begin
		str = str.encode("cp932")
		if str == nil
			"newer() argv == nil "
			return nil
		end

	rescue
		return false
	end
	match = str.scan(/\d+/) 

end

def to_date2(str)
	year = Time.new.year
	day = [year]
	return false unless to_date(str).size == 4
	day += to_date(str)
	day.map!(&:to_i)
	Time.new(day[0],day[1],day[2],day[3],day[4]).to_s

end
def to_date3(str)
	year = Time.new.year
	day = [year]
	return false unless to_date(str).size == 4
	day += to_date(str)
	day.map!(&:to_i)
	Time.new(day[0],day[1],day[2],day[3],day[4])

end
def to_date4(str,year1)
	year = Time.new.year
	day = [year]
	return false unless to_date(str).size == 4
	day += to_date(str)
	day.map!(&:to_i)
	Time.new(year1,day[1],day[2],day[3],day[4])

end
