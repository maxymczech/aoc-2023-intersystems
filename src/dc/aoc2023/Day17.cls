Class dc.aoc2023.Day17 Extends dc.aoc2023.Base
{

Parameter InputFile = "input17.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Calculate(minDist, maxDist) As %Integer
{
    set dirDown = 1
    set dirLeft = 2
    set dirRight = 3
    set dirUp = 4
    set costHorizontal = 1
    set costVertical = 2
	set dirs(dirDown,  1) =  1
	set dirs(dirDown,  2) =  0
	set dirs(dirLeft,  1) =  0
	set dirs(dirLeft,  2) =  1
	set dirs(dirRight, 1) =  0
	set dirs(dirRight, 2) = -1
	set dirs(dirUp,    1) = -1
	set dirs(dirUp,    2) =  0
	set nextDirs(costHorizontal, 1) = dirUp
	set nextDirs(costHorizontal, 2) = dirDown
	set nextDirs(costVertical, 1) = dirLeft
	set nextDirs(costVertical, 2) = dirRight

    set stream = ..GetInput(..#InputFile)
    set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set height = height + 1
		set width = $length(line)
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
		}
    }
    for y = 1:1:height {
	    for x = 1:1:width {
		    set cost(y, x, costHorizontal) = 99999999
		    set cost(y, x, costVertical)   = 99999999
	    }
    }
    
    // Circular buffer BFS queue
    set qSize = 10000000
    set qRead = 1
    set qWrite = 3
    set q(1, 1) = 1
    set q(1, 2) = 1
    set q(1, 3) = dirLeft
    set q(1, 4) = 0
    set q(2, 1) = 1
    set q(2, 2) = 1
    set q(2, 3) = dirDown
    set q(2, 4) = 0
    
    // BFS
    while (qRead '= qWrite) {
	    set y = q(qRead, 1)
	    set x = q(qRead, 2)
	    set dir = q(qRead, 3)
	    set c = q(qRead, 4)
	    set qRead = qRead + 1
	    // BFS runs very slow, has abot 40..50 million iterations
	    // Finds solution to both parts in about 2 minutes on my laptop
	    // if '(qRead # 1000000) {
		//     write qRead, !
	    // }
	    if qRead > qSize {
		    set qRead = 1
	    }
	    if (dir = dirLeft) || (dir = dirRight) {
		    set costKey = costHorizontal
	    } else {
		    set costKey = costVertical
	    }

	    if (cost(y, x, costKey) > c) {
		    set cost(y, x, costKey) = c
		    
		    for i = 1:1:2 {
			    set nd = nextDirs(costKey, i)
			    set tc = 0
			    for j = 1:1:maxDist {
				    set ny = y + (j * dirs(nd, 1))
				    set nx = x + (j * dirs(nd, 2))
				    if (nx < 1) || (ny < 1) || (nx > width) || (ny > height) {
					    QUIT
				    } else {
					    set tc = tc + data(ny, nx)
					    if j >= minDist {
						    set q(qWrite, 1) = ny
						    set q(qWrite, 2) = nx
						    set q(qWrite, 3) = nd
						    set q(qWrite, 4) = c + tc
						    set qWrite = qWrite + 1
						    if qWrite > qSize {
							    set qWrite = 1
						    }
					    }
				    }
			    }
		    }
	    }
    }
    
    if (cost(height, width, costHorizontal) < cost(height, width, costVertical)) {
	    return cost(height, width, costHorizontal)
    }
    return cost(height, width, costVertical)
}

ClassMethod Part1(verbose = 0) As %Integer
{
	return ..Calculate(1, 3)
}

ClassMethod Part2(verbose = 0) As %Integer
{
	return ..Calculate(4, 10)
}

}
