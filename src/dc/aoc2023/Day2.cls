Class dc.aoc2023.Day2 Extends dc.aoc2023.Base
{

Parameter InputFile = "input2.txt";

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
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set lineLeft = $piece(line, ": ", 1)
		set lineRight = $piece(line, ": ", 2)
		set id = $piece(lineLeft, " ", 2)
		set ok = 1
		// write line,!
		for i=1:1:100 {
			set game = $piece(lineRight, "; ", i)
			if game = "" {
				QUIT
			} else {
				for j=1:1:3 {
					set cube = $piece(game, ", ", j)
					if cube = "" {
					} else {
						set count = $piece(cube, " ", 1)
						set color = $piece(cube, " ", 2)
						if (color = "red") && (count > 12) {
							set ok = 0
						}
						if (color = "green") && (count > 13) {
							set ok = 0
						}
						if (color = "blue") && (count > 14) {
							set ok = 0
						}
					}
				}
			}
		}
		if ok = 1 {
			set sum = sum + id
		}
	}
    return sum
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream=..GetInput(..#InputFile)
    set sum=0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set lineLeft = $piece(line, ": ", 1)
		set lineRight = $piece(line, ": ", 2)
		set id = $piece(lineLeft, " ", 2)
		set red = 0
		set green = 0
		set blue = 0
		// write line,!
		for i=1:1:100 {
			set game = $piece(lineRight, "; ", i)
			if game = "" {
				QUIT
			} else {
				for j=1:1:3 {
					set cube = $piece(game, ", ", j)
					if cube = "" {
					} else {
						set count = $piece(cube, " ", 1)
						set color = $piece(cube, " ", 2)
						if (color = "red") && (count > red) {
							set red = count
						}
						if (color = "green") && (count > green) {
							set green = count
						}
						if (color = "blue") && (count > blue) {
							set blue = count
						}
					}
				}
			}
		}
		set power = red * green * blue
		set sum = sum + power
	}
    return sum
}

}
