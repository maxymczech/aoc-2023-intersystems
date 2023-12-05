Class dc.aoc2023.Day5 Extends dc.aoc2023.Base
{

Parameter InputFile = "input5.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadData(ByRef seedCount, ByRef seeds, ByRef mapCount, ByRef mapNames, ByRef mapRowCounts, ByRef mapData)
{
    set stream=..GetInput(..#InputFile)

	// Seeds
    set firstLine = $zstrip(stream.ReadLine(), "*C")
    set seedsRaw = $EXTRACT(firstLine, 8, $LENGTH(firstLine))
	set seedCount = 0
	for i = 1:1:1000 {
		set n = $piece(seedsRaw, " ", i)
		if n = "" {
			QUIT
		} else {
			set seedCount = seedCount + 1
			set seeds(seedCount) = n
		}
	}

	set newMap = 0
	set mapCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line = "" {
			set newMap = 1
		} else {
			if (newMap) {
				set newMap = 0
				set mapCount = mapCount + 1
				set mapNames(mapCount) = $extract(line, 1, $length(line) - 5)
				set mapRowCounts(mapCount) = 0
			} else {
				set destination = $piece(line, " ", 1)
				set source = $piece(line, " ", 2)
				set range = $piece(line, " ", 3)
				set mapRowCounts(mapCount) = mapRowCounts(mapCount) + 1
				set mapData(mapCount, mapRowCounts(mapCount), 1) = destination
				set mapData(mapCount, mapRowCounts(mapCount), 2) = source
				set mapData(mapCount, mapRowCounts(mapCount), 3) = range
			}
		}
    }
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set result=999999999999
    do ..ReadData(.seedCount, .seeds, .mapCount, .mapNames, .mapRowCounts, .mapData)

    for i = 1:1:seedCount {
	    set index = seeds(i)
	    for j = 1:1:mapCount {
		    for k = 1:1:mapRowCounts(j) {
			    set destination = mapData(j, k, 1)
			    set source = mapData(j, k, 2)
			    set range = mapData(j, k, 3)
			    if (index >= source) && (index <= (source + range - 1)) {
				    set index = index - source + destination
				    QUIT
			    }
		    }
	    }
	    // write seeds(i), " ", index,!
	    if index < result {
		    set result = index
	    }
    }

    return result
}

ClassMethod Rec(index, indexRange, mapIndex, mapCount, ByRef mapData, ByRef mapRowCounts, ByRef result)
{
	if (mapIndex > mapCount) {
		// write index, " ", indexRange, !
		if (index < result) {
			set result = index
		}
		return
		write "qwe",!
	}
	set mappedMin = 999999999999
	set mappedMax = -999999999999
	for i = 1:1:mapRowCounts(mapIndex) {
		set destination = mapData(mapIndex, i, 1)
		set source = mapData(mapIndex, i, 2)
		set range = mapData(mapIndex, i, 3)
		set a = index
		set b = index + indexRange - 1
		set c = source
		set d = source + range - 1
		if (a > d) || (c > b) {
		} else {
			set res0 = a
			if c > a {
				set res0 = c
			}
			set res1 = b
			if d < b {
				set res1 = d
			}
			set indexNext = (res0 - source) + destination
			set indexRangeNext = (res1 - res0) + 1
			if res0 < mappedMin {
				set mappedMin = res0
			}
			if res1 > mappedMax {
				set mappedMax = res1
			}
			do ..Rec(indexNext, indexRangeNext, mapIndex + 1, mapCount, .mapData, .mapRowCounts, .result)
		}
    }

    if mappedMin = 999999999999 {
	    do ..Rec(index, indexRange, mapIndex + 1, mapCount, .mapData, .mapRowCounts, .result)
    } else {
	    set outer0 = index
	    set outer1 = index + indexRange - 1
	    set inner0 = mappedMin
	    set inner1 = mappedMax
		if (inner0 > outer0) {
			do ..Rec(outer0, (inner0 - outer0) + 1, mapIndex + 1, mapCount, .mapData, .mapRowCounts, .result)
		}
		if (inner1 < outer1) {
			do ..Rec(inner1, (outer1 - inner1) + 1, mapIndex + 1, mapCount, .mapData, .mapRowCounts, .result)
		}
    }
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set result=999999999999
    do ..ReadData(.seedCount, .seeds, .mapCount, .mapNames, .mapRowCounts, .mapData)
    for i = 1:2:seedCount {
	    do ..Rec(seeds(i), seeds(i + 1), 1, mapCount, .mapData, .mapRowCounts, .result)
    }
    return result
}

}
