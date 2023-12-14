Class dc.aoc2023.Day14 Extends dc.aoc2023.Base
{

Parameter InputFile = "input14.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
    }
    return result
}

}
