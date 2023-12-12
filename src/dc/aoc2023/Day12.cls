Class dc.aoc2023.Day12 Extends dc.aoc2023.Base
{

Parameter InputFile = "input12.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Calculate(ByRef springs, springsLength, ByRef numbers, numbersCount) As %Integer
{
	for i = 1:1:numbersCount {
		for j = 1:1:springsLength {
			set counts(i, j) = 0
		}
	}	
	for i = 1:1:numbersCount {
		for j = 1:1:springsLength {
			set count = 0
			if springs(j) '= "#" {
				set ci = i
				set cj = j - 1
				if (ci = 1) && (cj = 0) {
					set count = count + 1
				} else {
					if (cj > 0) && (ci > 0) {
						set count = count + counts(ci, cj)
					}
				}
			}
			if (i > 1) {
				set flag = 1
				if (springs(j) = "#") {
					set flag = 0
				}
				for k = 1:1:numbers(i) {
					if ((j - k) < 1) {
						set flag = 0
					} else {
						if (springs(j - k) = ".") {
							set flag = 0
						}
					}
				}
				if flag {
					set ci = i - 1
					set cj = (j - 1) - numbers(i)
					if (ci = 1) && (cj = 0) {
						set count = count + 1
					} else {
						if (cj > 0) && (ci > 0) {
							set count = count + counts(ci, cj)
						}
					}
				}
			}
			
			set counts(i, j) = count
		}
	}
	return counts(numbersCount, springsLength)
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set tmpSprings = $piece(line, " ", 1)
		set springsLength = 0
		for t = 1:1:1 {
			for i = 1:1:$length(tmpSprings) {
				set springsLength = springsLength + 1
				set springs(springsLength) = $extract(tmpSprings, i)
			}
			set springsLength = springsLength + 1
			set springs(springsLength) = "?"
		}
		set tmpNumbers = $piece(line, " ", 2)
		set numbersCount = 1
		set numbers(1) = 0
		for t = 1:1:1 {
			for i = 1:1:100 {
				set n = $piece(tmpNumbers, ",", i)
				if n = "" {
					QUIT
				} else {
					set numbersCount = numbersCount + 1
					set numbers(numbersCount) = n
				}
			}
		}
		set result = result + (..Calculate(.springs, springsLength, .numbers, numbersCount))
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set tmpSprings = $piece(line, " ", 1)
		set springsLength = 0
		for t = 1:1:5 {
			for i = 1:1:$length(tmpSprings) {
				set springsLength = springsLength + 1
				set springs(springsLength) = $extract(tmpSprings, i)
			}
			set springsLength = springsLength + 1
			set springs(springsLength) = "?"
		}
		set tmpNumbers = $piece(line, " ", 2)
		set numbersCount = 1
		set numbers(1) = 0
		for t = 1:1:5 {
			for i = 1:1:100 {
				set n = $piece(tmpNumbers, ",", i)
				if n = "" {
					QUIT
				} else {
					set numbersCount = numbersCount + 1
					set numbers(numbersCount) = n
				}
			}
		}
		set result = result + (..Calculate(.springs, springsLength, .numbers, numbersCount))
    }
    return result
}

}
