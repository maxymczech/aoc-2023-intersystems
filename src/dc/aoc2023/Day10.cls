Class dc.aoc2023.Day10 Extends dc.aoc2023.Base
{

Parameter InputFile = "input10.txt";

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
	set height = 0
	set width = -1
	set sx = -1
	set sy = -1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		set height = height + 1
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
			set visited(height, i) = 0
			if $extract(line, i) = "S" {
				set sx = i
				set sy = height
			}
		}
	}
	set visited(sy, sx) = 1
	set dirs(1, 1) = sy
	set dirs(1, 2) = sx
	set dirs(2, 1) = sy
	set dirs(2, 2) = sx

	while 1 {
		set result = result + 1
		for i = 1:1:2 {
			set y = dirs(i, 1)
			set x = dirs(i, 2)
			set flag = 0
			if ('flag) && (y > 1) && ((data(y, x) = "S") || (data(y, x) = "|") || (data(y, x) = "L") || (data(y, x) = "J")) && ((data(y - 1, x) = "|") || (data(y - 1, x) = "F") || (data(y - 1, x) = "7")) && ('visited(y - 1, x)){
				set next(i, 1) = y - 1
				set next(i, 2) = x
				set visited(y - 1, x) = 1
				set flag = 1
			}
			if ('flag) && (y < height) && ((data(y, x) = "S") || (data(y, x) = "|") || (data(y, x) = "F") || (data(y, x) = "7")) && ((data(y + 1, x) = "|") || (data(y + 1, x) = "L") || (data(y + 1, x) = "J")) && ('visited(y + 1, x)) {
				set next(i, 1) = y + 1
				set next(i, 2) = x
				set visited(y + 1, x) = 1
				set flag = 1
			}
			if ('flag) && (x > 1) && ((data(y, x) = "S") || (data(y, x) = "-") || (data(y, x) = "7") || (data(y, x) = "J")) && ((data(y, x - 1) = "-") || (data(y, x - 1) = "F") || (data(y, x - 1) = "L")) && ('visited(y, x - 1)){
				set next(i, 1) = y
				set next(i, 2) = x - 1
				set visited(y, x - 1) = 1
				set flag = 1
			}
			if ('flag) && (x < width) && ((data(y, x) = "S") || (data(y, x) = "-") || (data(y, x) = "F") || (data(y, x) = "L")) && ((data(y, x + 1) = "-") || (data(y, x + 1) = "7") || (data(y, x + 1) = "J")) && ('visited(y, x + 1)){
				set next(i, 1) = y
				set next(i, 2) = x + 1
				set visited(y, x + 1) = 1
				set flag = 1
			}
		}

		for i = 1:1:2 {
			for j = 1:1:2 {
				set dirs(i, j) = next(i, j)
			}
		}

		if ((dirs(1,1) = (dirs(2,1) + 1)) && (dirs(1,2) = dirs(2,2))) || ((dirs(1,1) = (dirs(2,1) - 1)) && (dirs(1,2) = dirs(2,2))) || ((dirs(1,2) = (dirs(2,2) + 1)) && (dirs(1,1) = dirs(2,1))) || ((dirs(1,2) = (dirs(2,2) - 1)) && (dirs(1,1) = dirs(2,1))) {
			QUIT
		}
	}
	
	return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
	set stream = ..GetInput(..#InputFile)
	set result = 0
	set height = 0
	set width = -1
	set sx = -1
	set sy = -1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		set height = height + 1
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
			set visited(height, i) = 0
			if $extract(line, i) = "S" {
				set sx = i
				set sy = height
			}
		}
	}
	set visited(sy, sx) = 1
	set dirs(1, 1) = sy
	set dirs(1, 2) = sx
	set dirs(2, 1) = sy
	set dirs(2, 2) = sx

	while 1 {
		for i = 1:1:2 {
			set y = dirs(i, 1)
			set x = dirs(i, 2)
			set flag = 0
			if ('flag) && (y > 1) && ((data(y, x) = "S") || (data(y, x) = "|") || (data(y, x) = "L") || (data(y, x) = "J")) && ((data(y - 1, x) = "|") || (data(y - 1, x) = "F") || (data(y - 1, x) = "7")) && ('visited(y - 1, x)){
				set next(i, 1) = y - 1
				set next(i, 2) = x
				set visited(y - 1, x) = 1
				set flag = 1
				set movedFromStart(i) = "up"
			}
			if ('flag) && (y < height) && ((data(y, x) = "S") || (data(y, x) = "|") || (data(y, x) = "F") || (data(y, x) = "7")) && ((data(y + 1, x) = "|") || (data(y + 1, x) = "L") || (data(y + 1, x) = "J")) && ('visited(y + 1, x)) {
				set next(i, 1) = y + 1
				set next(i, 2) = x
				set visited(y + 1, x) = 1
				set flag = 1
				set movedFromStart(i) = "down"
			}
			if ('flag) && (x > 1) && ((data(y, x) = "S") || (data(y, x) = "-") || (data(y, x) = "7") || (data(y, x) = "J")) && ((data(y, x - 1) = "-") || (data(y, x - 1) = "F") || (data(y, x - 1) = "L")) && ('visited(y, x - 1)){
				set next(i, 1) = y
				set next(i, 2) = x - 1
				set visited(y, x - 1) = 1
				set flag = 1
				set movedFromStart(i) = "left"
			}
			if ('flag) && (x < width) && ((data(y, x) = "S") || (data(y, x) = "-") || (data(y, x) = "F") || (data(y, x) = "L")) && ((data(y, x + 1) = "-") || (data(y, x + 1) = "7") || (data(y, x + 1) = "J")) && ('visited(y, x + 1)){
				set next(i, 1) = y
				set next(i, 2) = x + 1
				set visited(y, x + 1) = 1
				set flag = 1
				set movedFromStart(i) = "right"
			}
		}

		for i = 1:1:2 {
			for j = 1:1:2 {
				set dirs(i, j) = next(i, j)
			}
		}

		if ((dirs(1,1) = (dirs(2,1) + 1)) && (dirs(1,2) = dirs(2,2))) || ((dirs(1,1) = (dirs(2,1) - 1)) && (dirs(1,2) = dirs(2,2))) || ((dirs(1,2) = (dirs(2,2) + 1)) && (dirs(1,1) = dirs(2,1))) || ((dirs(1,2) = (dirs(2,2) - 1)) && (dirs(1,1) = dirs(2,1))) {
			QUIT
		}
	}
	
	// part 2
	for y = 1:1:height {
		for x = 1:1:width {
			if 'visited(y, x) {
				set data(y, x) = "."
			}
		}
	}

	set gwidth = 2 * width
	set gheight = 2 * height
	for y = 1:1:height {
		for x = 1:1:width {
			set growy((2 * y) - 1, x) = data(y, x)
			if (data(y, x) = "|") || (data(y, x) = "F") || (data(y, x) = "7") {
				set growy(2 * y, x) = "|"
			} else {
				if (data(y, x) = "S") && ((movedFromStart(1) = "down") || (movedFromStart(2) = "down")) {
					set growy(2 * y, x) = "|"
				} else {
					set growy(2 * y, x) = " "
				}
			}
		}
	}

	for y = 1:1:gheight {
		for x = 1:1:width {
			set grow(y, (2 * x) - 1) = growy(y, x)
			if (growy(y, x) = "-") || (growy(y, x) = "F") || (growy(y, x) = "L") {
				set grow(y, 2 * x) = "-"
			} else {
				if (growy(y, x) = "S") && ((movedFromStart(1) = "right") || (movedFromStart(2) = "right")) {
					set grow(y, 2 * x) = "-"
				} else {
					set grow(y, 2 * x) = " "
				}
			}
		}
	}

	// Find point to start flood fill
	set fx = -1
	set fy = -1
	for y = 1:1:gheight {
		for x = 1:1:(gwidth - 2) {
			if ((grow(y, x) = ".") || (grow(y, x) = " ")) && ((grow(y, x + 1) '= ".") && (grow(y, x + 1) '= " ")) && ((grow(y, x + 2) = ".") || (grow(y, x + 2) = " ")) {
				set fy = y
				set fx = x + 2
				QUIT
			}
		}
		if fx '= -1 {
			QUIT
		}
	}
	// write fy, " ", fx, !

	for y = 1:1:gheight {
		for x = 1:1:gwidth {
			set visited(y, x) = 0
		}
	}

	set qSize = 1
	set i = 0
	set q(1, 1) = fy
	set q(1, 2) = fx
	set next(1,1) = -1
	set next(1,2) =  0
	set next(2,1) =  1
	set next(2,2) =  0
	set next(3,1) =  0
	set next(3,2) = -1
	set next(4,1) =  0
	set next(4,2) =  1
	
	while i < qSize {
		set i = i + 1
		set y = q(i, 1)
		set x = q(i, 2)
		if 'visited(y, x) {
			if grow(y, x) = "." {
				set result = result + 1
			}
			set visited(y, x) = 1
			for j = 1:1:4 {
				set ny = y + next(j, 1)
				set nx = x + next(j, 2)
				if ((grow(ny, nx) = " ") || (grow(ny, nx) = ".")) && ('visited(ny, nx)) {
					set qSize = qSize + 1
					set q(qSize, 1) = ny
					set q(qSize, 2) = nx
				}
			}
		}
	}

	return result
}

}
