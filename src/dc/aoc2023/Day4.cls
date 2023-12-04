Class dc.aoc2023.Day4 Extends dc.aoc2023.Base
{

Parameter InputFile = "input4.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream=..GetInput(..#InputFile)
    set result=0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set tmp = $piece(line, ": ", 2)
		set numbersLeft = $piece(tmp, " | ", 1)
		set numbersRight = $piece(tmp, " | ", 2)
		set countHave = 0
		set countWinning = 0
		for i=1:1:100 {
			set n = $piece(numbersLeft, " ", i)
			if n '= "" {
				set countWinning = countWinning + 1
				set winning(countWinning) = n
			}

			set n = $piece(numbersRight, " ", i)
			if n '= "" {
				set countHave = countHave + 1
				set have(countHave) = n
			}
		}
		
		// write numbersLeft, " ", numbersRight, !

		set score = 0
		for i = 1:1:countHave {
			for j = 1:1:countWinning {
				if have(i) = winning(j) {
					if (score = 0) {
						set score = 1
					} else {
						set score = score * 2
					}
					QUIT
				}
			}
		}
		set result = result + score
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream=..GetInput(..#InputFile)
    set result=0
    set linesCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set linesCount = linesCount + 1
		set lines(linesCount) = line
	}
	for l = 1:1:linesCount {
		set count(l) = 1
	}
	for l = 1:1:linesCount {
		set line = lines(l)
		set tmp = $piece(line, ": ", 2)
		set numbersLeft = $piece(tmp, " | ", 1)
		set numbersRight = $piece(tmp, " | ", 2)
		set countHave = 0
		set countWinning = 0
		for i=1:1:100 {
			set n = $piece(numbersLeft, " ", i)
			if n '= "" {
				set countWinning = countWinning + 1
				set winning(countWinning) = n
			}

			set n = $piece(numbersRight, " ", i)
			if n '= "" {
				set countHave = countHave + 1
				set have(countHave) = n
			}
		}
		
		// write numbersLeft, " ", numbersRight, !

		set score = 0
		for i = 1:1:countHave {
			for j = 1:1:countWinning {
				if have(i) = winning(j) {
					set score = score + 1
					QUIT
				}
			}
		}
		
		set result = result + count(l)
		for i = 1:1:score {
			set count(l + i) = count(l + i) + count(l)
		}
    }
    return result
}

}
