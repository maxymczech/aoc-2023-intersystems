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

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream=..GetInput(..#InputFile)
    set sum=0
    set digits = "123456789"
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set cal = 0
		// write line,!
		for i=1:1:$LENGTH(line) {
			set c = $extract(line, i, i)
			for j=1:1:$LENGTH(digits) {
				set d = $extract(digits, j, j)
				if c = d {
					set cal = cal + j * 10
					GOTO Last1
				}
			}
		}
Last1
		for i=$LENGTH(line):-1:1 {
			set c = $extract(line, i, i)
			for j=1:1:$LENGTH(digits) {
				set d = $extract(digits, j, j)
				if c = d {
					set cal = cal + j
					GOTO Sum1
				}
			}
		}
Sum1
		set sum = sum + cal
    }
    return sum
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream=..GetInput(..#InputFile)
    set sum=0
    set digits = "123456789"
    set numbers(1) = "one"
    set numbers(2) = "two"
    set numbers(3) = "three"
    set numbers(4) = "four"
    set numbers(5) = "five"
    set numbers(6) = "six"
    set numbers(7) = "seven"
    set numbers(8) = "eight"
    set numbers(9) = "nine"
    set numbersRev(1) = "eno"
    set numbersRev(2) = "owt"
    set numbersRev(3) = "eerht"
    set numbersRev(4) = "ruof"
    set numbersRev(5) = "evif"
    set numbersRev(6) = "xis"
    set numbersRev(7) = "neves"
    set numbersRev(8) = "thgie"
    set numbersRev(9) = "enin"
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set lineRev = $REVERSE(line)
		set cal = 0
		
		set leftDigit = 0
		set leftPos = 9999
		for i=1:1:9 {
			set d = $extract(digits, i, i)
			set x = $FIND(line, d) - 1
			if (x > 0) && (x < leftPos) {
				set leftPos = x
				set leftDigit = i
			}
			set y = $FIND(line, numbers(i)) - $LENGTH(numbers(i))
			if (y > 0) && (y < leftPos) {
				set leftPos = y
				set leftDigit = i
			}
		}
		set cal = cal + leftDigit * 10

		set rightDigit = 0
		set rightPos = 9999
		for i=1:1:9 {
			set d = $extract(digits, i, i)
			set x = $FIND(lineRev, d) - 1
			if (x > 0) && (x < rightPos) {
				set rightPos = x
				set rightDigit = i
			}
			set y = $FIND(lineRev, numbersRev(i)) - $LENGTH(numbersRev(i))
			if (y > 0) && (y < rightPos) {
				set rightPos = y
				set rightDigit = i
			}
		}
		set cal = cal + rightDigit
		
		set sum = sum + cal
	}
    return sum
}

}
