Class dc.aoc2023.Day6 Extends dc.aoc2023.Base
{

Parameter InputFile = "input6.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod isd(d As %String) As %Integer
{
	if (d = "0") || (d = "1") || (d = "2") || (d = "3") || (d = "4") || (d = "5") || (d = "6") || (d = "7") || (d = "8") || (d = "9") {
		return 1
	}
	return 0
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 1
    set times = 0
    set distances = 0
    set lineNumber = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set lineNumber = lineNumber + 1
		for i = 1:1:1000 {
			set n = $piece(line, " ", i)
			if (n '= "") && (n '= "Time:") && (n '= "Distance:") {
				if lineNumber = 1 {
					set times = times + 1
					set time(times) = n
				}
				if lineNumber = 2 {
					set distances = distances + 1
					set distance(distances) = n
				}
			}
		}
    }
    for i = 1:1:times {
	    set count = 0
	    for j = 1:1:(time(i) - 1) {
		    set speed = j
		    set raceTime = time(i) - j
		    set s = speed * raceTime
		    if (s > distance(i)) {
			    set count = count + 1
			}
	    }
	    set result = result * count
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set time = 0
    set distance = 0
    
    set line1 = $zstrip(stream.ReadLine(), "*C")
    for i = 1:1:$length(line1) {
	    set c = $extract(line1, i)
	    if ..isd(c) {
		    set time = time * 10 + c
	    }
    }

    set line2 = $zstrip(stream.ReadLine(), "*C")
    for i = 1:1:$length(line2) {
	    set c = $extract(line2, i)
	    if ..isd(c) {
		    set distance = distance * 10 + c
	    }
    }
    
    for i = 1:1:(time - 1) {
	    set speed = i
	    set raceTime = time - i
	    set s = speed * raceTime
	    if (s > distance) {
		    set result = result + 1
		}
    }

    return result
}

}
