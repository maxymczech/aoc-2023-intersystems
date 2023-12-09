Class dc.aoc2023.Day9 Extends dc.aoc2023.Base
{

Parameter InputFile = "input9.txt";

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
		set numCount = 0
		for i=1:1:100 {
			set n = $piece(line, " ", i)
			if n = "" {
				QUIT
			} else {
				set numCount = numCount + 1
				set numbers(numCount) = n
			}
		}
		set historyCount(1) = numCount
		for i = 1:1:numCount {
			set history(1, i) = numbers(i)
		}
		
		for i = 2:1:numCount {
			set historyCount(i) = 0
			set allZero = 1
			for j = 2:1:historyCount(i - 1) {
				set historyCount(i) = historyCount(i) + 1
				set history(i,j - 1) = history(i - 1, j) - history(i - 1, j - 1)
				if history(i,j - 1) '= 0 {
					set allZero = 0
				}
			}
			if allZero {
				set last = 0
				for j = (i-1):-1:1 {
					set last = history(j, historyCount(j)) + last
					// write last, " "
				}
				// write !
				set result = result + last

				QUIT
			}
		}
		
    }

    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set numCount = 0
		for i=1:1:100 {
			set n = $piece(line, " ", i)
			if n = "" {
				QUIT
			} else {
				set numCount = numCount + 1
				set numbers(numCount) = n
			}
		}
		set historyCount(1) = numCount
		for i = 1:1:numCount {
			// reverse
			set history(1, numCount - i + 1) = numbers(i)
		}
		
		for i = 2:1:numCount {
			set historyCount(i) = 0
			set allZero = 1
			for j = 2:1:historyCount(i - 1) {
				set historyCount(i) = historyCount(i) + 1
				set history(i,j - 1) = history(i - 1, j) - history(i - 1, j - 1)
				if history(i,j - 1) '= 0 {
					set allZero = 0
				}
			}
			if allZero {
				set last = 0
				for j = (i-1):-1:1 {
					set last = history(j, historyCount(j)) + last
					// write last, " "
				}
				// write !
				set result = result + last

				QUIT
			}
		}
		
    }

    return result
}

}
