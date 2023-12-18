Class dc.aoc2023.Day18 Extends dc.aoc2023.Base
{

Parameter InputFile = "input18.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Calculate(ByRef dist, ByRef dir, numLines) As %Integer
{
	set next("D", 1) =  1
	set next("D", 2) =  0
	set next("L", 1) =  0
	set next("L", 2) = -1
	set next("R", 1) =  0
	set next("R", 2) =  1
	set next("U", 1) = -1
	set next("U", 2) =  0
	
	set cy = 0
	set cx = 0
	set p = 0
	set a = 0
	set pointsCount = 1
	set points(1, 1) = 0
	set points(1, 2) = 0
	
	for i = 1:1:numLines {
		set cDir = dir(i)
		set cDist = dist(i)
		set cy = cy + (next(cDir, 1) * cDist)
		set cx = cx + (next(cDir, 2) * cDist)
		set p = p + cDist
		set pointsCount = pointsCount + 1
		set points(pointsCount, 1) = cy
		set points(pointsCount, 2) = cx
	}
	
	for i = pointsCount:-1:2 {
		set a = a + ((points(i, 2) + points(i - 1, 2)) * (points(i, 1) - points(i - 1, 1)))
	}
	set result = (p / 2) + (a / 2) + 1

	return result
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set numLines = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set numLines = numLines + 1
		set dir(numLines) = $piece(line, " ", 1)
		set dist(numLines) = $piece(line, " ", 2)
    }
    set result = ..Calculate(.dist, .dir, numLines)
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
	set dirCodes("0") = "R"
	set dirCodes("1") = "D"
	set dirCodes("2") = "L"
	set dirCodes("3") = "U"
    set stream = ..GetInput(..#InputFile)
    set numLines = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set numLines = numLines + 1
		set hex = $piece(line, " ", 3)
		set dir(numLines) = dirCodes($extract(hex, 8))
		set dist(numLines) = $zhex($extract(hex, 3, 7))
    }
    set result = ..Calculate(.dist, .dir, numLines)
    return result
}

}
