Class dc.aoc2023.Day3 Extends dc.aoc2023.Base
{

Parameter InputFile = "input3.txt";

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
    set stream=..GetInput(..#InputFile)
    set result = 0
    kill lines
    set h = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set h = h + 1
		set lines(h) = line
    }
    set w = $length(lines(1))
    
    for i = 1:1:h {
	    for j = 1:1:w {
		    set c = $extract(lines(i),j)
		    if ..isd(c) {
			    set l = 1
			    for t = j+1:1:w {
				    set c2 = $extract(lines(i),t)
				    if ..isd(c2) {
					    set l = l + 1
				    } else {
					    QUIT
				    }
			    }
			    
			    set n = $extract(lines(i),j,j+l-1)
			    set isPartNumber = 0
			    for u = i-1:1:i+1 {
				    for v = j-1:1:j+l {
					    if (u > 0) && (u <= h) && (v > 0) && (v <= w) {
						    set c3 = $extract(lines(u),v)
						    if (..isd(c3) = 0) && (c3 '= ".") {
							    set isPartNumber = 1
						    }
					    }
				    }
			    }
			    
			    // write n, " ", isPartNumber, !
				if isPartNumber {
					set result = result + n
				}
			    
			    set j = j + l
		    }
	    }
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream=..GetInput(..#InputFile)
    set result = 0
    kill lines
    kill adjacency
    kill adjCount
    set h = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set h = h + 1
		set lines(h) = line
    }
    set w = $length(lines(1))
    
    for i = 1:1:h {
	    for j = 1:1:w {
		    set key = i _ ";" _ j
		    set adjCount(key) = 0
	    }
    }
    
    for i = 1:1:h {
	    for j = 1:1:w {
		    set c = $extract(lines(i),j)
		    if ..isd(c) {
			    set l = 1
			    for t = j+1:1:w {
				    set c2 = $extract(lines(i),t)
				    if ..isd(c2) {
					    set l = l + 1
				    } else {
					    QUIT
				    }
			    }
			    
			    set n = $extract(lines(i),j,j+l-1)
			    set isPartNumber = 0
			    for u = i-1:1:i+1 {
				    for v = j-1:1:j+l {
					    if (u > 0) && (u <= h) && (v > 0) && (v <= w) {
						    set c3 = $extract(lines(u),v)
						    if (..isd(c3) = 0) && (c3 = "*") {
							    set key = u _ ";" _ v
							    if adjCount(key) = 0 {
								    set adjacency(key) = n
							    } else {
								    set adjacency(key) = adjacency(key) * n
							    }
							    set adjCount(key) = adjCount(key) + 1
						    }
					    }
				    }
			    }

			    set j = j + l
		    }
	    }
    }
    
    for i = 1:1:h {
	    for j = 1:1:w {
		    set key = i _ ";" _ j
		    if adjCount(key) = 2 {
			    set result = result + adjacency(key)
		    }
	    }
    }

    return result
}

}
