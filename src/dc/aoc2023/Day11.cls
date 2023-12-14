Class dc.aoc2023.Day11 Extends dc.aoc2023.Base
{

Parameter InputFile = "input11.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Compute(growFactor) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
	set height = 0
	set width = -1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		set height = height + 1
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
		}
    }

    set rowCount = 0
    for y = 1:1:height {
	    set isEmpty = 1
	    for x = 1:1:width {
		    if data(y, x) '= "." {
			    set isEmpty = 0
			    QUIT
		    }
	    }
	    if isEmpty {
		    set rowCount = rowCount + 1
		    set rows(rowCount) = y
	    }
    }

    set colCount = 0
    for x = 1:1:width {
	    set isEmpty = 1
	    for y = 1:1:height {
		    if data(y, x) '= "." {
			    set isEmpty = 0
			    QUIT
		    }
	    }
	    if isEmpty {
		    set colCount = colCount + 1
		    set cols(colCount) = x
	    }
    }

    set galaxyCount = 0
    for y = 1:1:height {
	    for x = 1:1:width {
		    if data(y, x) = "#" {
			    set galaxyCount = galaxyCount + 1
			    set galaxies(galaxyCount, 1) = y
			    set galaxies(galaxyCount, 2) = x
		    }
	    }
    }

    for i = 2:1:galaxyCount {
	    for j = 1:1:(i - 1) {
		    set miny = galaxies(i, 1)
		    if miny > galaxies(j, 1) {
			    set miny = galaxies(j, 1)
		    }
		    set maxy = galaxies(i, 1)
		    if maxy < galaxies(j, 1) {
			    set maxy = galaxies(j, 1)
		    }
		    set minx = galaxies(i, 2)
		    if minx > galaxies(j, 2) {
			    set minx = galaxies(j, 2)
		    }
		    set maxx = galaxies(i, 2)
		    if maxx < galaxies(j, 2) {
			    set maxx = galaxies(j, 2)
		    }
		    set d = (maxx - minx) + (maxy - miny)
		    
		    for y = miny:1:maxy {
			    set isEmpty = 0
			    for t = 1:1:rowCount {
				    if rows(t) = y {
					    set isEmpty = 1
					    QUIT
				    }
			    }
			    if isEmpty {
				    set d = d + growFactor
			    }
		    }
		    for x = minx:1:maxx {
			    set isEmpty = 0
			    for t = 1:1:colCount {
				    if cols(t) = x {
					    set isEmpty = 1
					    QUIT
				    }
			    }
			    if isEmpty {
				    set d = d + growFactor
			    }
		    }
		    set result = result + d
	    }
    }

    return result
}

ClassMethod Part1(verbose = 0) As %Integer
{
	return ..Compute(1)
}

ClassMethod Part2(verbose = 0) As %Integer
{
	return ..Compute(999999)
}

}
