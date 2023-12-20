Class dc.aoc2023.Day13 Extends dc.aoc2023.Base
{

Parameter InputFile = "input13.set2.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetGroupValue(ByRef Group, height, width, maxDiff) As %Integer
{
	// Columns
	for i = 1:1:(width - 1) {
		set diff = 0
		set mk = width - i
		if i < mk {
			set mk = i
		}
		for k = 1:1:mk {
			for j = 1:1:height {
				set a = i - k + 1
				set b = i + k
				if Group(j, a) '= Group(j, b) {
					set diff = diff + 1
				}
			}
		}
		if diff = maxDiff {
			return i
		}
	}
	
	// rows
	for i = 1:1:(height - 1) {
		set diff = 0
		set mk = height - i
		if i < mk {
			set mk = i
		}
		for k = 1:1:mk {
			for j = 1:1:width {
				set a = i - k + 1
				set b = i + k
				if Group(a, j) '= Group(b, j) {
					set diff = diff + 1
				}
			}
		}
		if diff = maxDiff {
			return i * 100
		}
	}

	return 0
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if (line = "") || (stream.AtEnd) {
			set result = result + (..GetGroupValue(.Group, height, width, 0))
			set height = 0
		} else {
			set height = height + 1
			set width = $length(line)
			for i = 1:1:width {
				set Group(height, i) = $extract(line, i)
			}
		}
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if (line = "") || (stream.AtEnd) {
			set result = result + (..GetGroupValue(.Group, height, width, 1))
			set height = 0
		} else {
			set height = height + 1
			set width = $length(line)
			for i = 1:1:width {
				set Group(height, i) = $extract(line, i)
			}
		}
    }
    return result
}

}
