Class dc.aoc2023.Day21 Extends dc.aoc2023.Base
{

Parameter InputFile = "input21.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set dirDown = 1
    set dirLeft = 2
    set dirRight = 3
    set dirUp = 4
	set dirs(dirDown,  1) =  1
	set dirs(dirDown,  2) =  0
	set dirs(dirLeft,  1) =  0
	set dirs(dirLeft,  2) =  1
	set dirs(dirRight, 1) =  0
	set dirs(dirRight, 2) = -1
	set dirs(dirUp,    1) = -1
	set dirs(dirUp,    2) =  0

    set stream = ..GetInput(..#InputFile)
    set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set height = height + 1
		set width = $length(line)
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
			if data(height, i) = "S" {
				set data(height, i) = "."
				set sy = height
				set sx = i
			}
		}
    }
    
    set qSize = 1
    set q(1, 1) = sy
    set q(1, 2) = sx
    for i = 1:1:64 {
	    for y = 1:1:height {
		    for x = 1:1:width {
			    set next(y, x) = 0
		    }
	    }
	    for qi = 1:1:qSize {
		    for di = 1:1:4 {
			    set ny = q(qi, 1) + dirs(di, 1)
			    set nx = q(qi, 2) + dirs(di, 2)
			    if (nx < 1) || (ny < 1) || (nx > width) || (ny > height) {
			    } else {
				    if data(ny, nx) '= "#" {
					    set next(ny, nx) = 1
				    }
			    }
		    }
	    }
	    set qSize = 0
	    for y = 1:1:height {
		    for x = 1:1:width {
			    if next(y, x) {
				    set qSize = qSize + 1
				    set q(qSize, 1) = y
				    set q(qSize, 2) = x
			    }
		    }
	    }

    }

    return qSize
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set dirDown = 1
    set dirLeft = 2
    set dirRight = 3
    set dirUp = 4
	set dirs(dirDown,  1) =  1
	set dirs(dirDown,  2) =  0
	set dirs(dirLeft,  1) =  0
	set dirs(dirLeft,  2) =  1
	set dirs(dirRight, 1) =  0
	set dirs(dirRight, 2) = -1
	set dirs(dirUp,    1) = -1
	set dirs(dirUp,    2) =  0

    set stream = ..GetInput(..#InputFile)
    set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set height = height + 1
		set width = $length(line)
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
			if data(height, i) = "S" {
				set data(height, i) = "."
				set sy = height
				set sx = i
			}
		}
    }
    
    set totalSteps = 26501365
    
    set qSize = 1
    set q(1, 1) = sy
    set q(1, 2) = sx
    set aCount = 0
    for i = 1:1:999999 {
	    kill next
	    set nqSize = 0
	    for qi = 1:1:qSize {
		    for di = 1:1:4 {
			    set ny = q(qi, 1) + dirs(di, 1)
			    set nx = q(qi, 2) + dirs(di, 2)
			    set ndy = ((ny - 1) # height) + 1
			    set ndx = ((nx - 1) # width) + 1
			    if data(ndy, ndx) '= "#" {
				    if '$get(next(ny, nx), 0) {
					    set next(ny, nx) = 1
					    set nqSize = nqSize + 1
					    set nq(nqSize, 1) = ny
					    set nq(nqSize, 2) = nx
				    }
			    }
		    }
	    }
	    
	    if ((i - 1) # width) = (totalSteps # width) {
		    set aCount = aCount + 1
		    set a(aCount) = qSize
	    }

	    set qSize = nqSize
	    for j = 1:1:nqSize {
		    set q(j, 1) = nq(j, 1)
		    set q(j, 2) = nq(j, 2)
	    }

		if aCount = 3 {
			QUIT
		}
    }
    
    set x = totalSteps \ width
    set result = a(1) + ((a(2) - a(1)) * x) + (((x * (x - 1)) / 2) * (a(3) + a(1) - (2 * a(2))))

    return result
}

}
