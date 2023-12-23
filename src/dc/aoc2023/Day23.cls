Class dc.aoc2023.Day23 Extends dc.aoc2023.Base
{

Parameter InputFile = "input23.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod onPath(ByRef path, pathSize, y, x) As %Integer
{
	for i = pathSize:-1:1 {
		if (path(i, 1) = y) && (path(i, 2) = x) {
			return 1
		}
	}
	return 0
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set dirDown = 1
    set dirRight = 2
    set dirLeft = 3
    set dirUp = 4
	set dirs(dirDown,  1) =  1
	set dirs(dirDown,  2) =  0
	set dirs(dirRight, 1) =  0
	set dirs(dirRight, 2) =  1
	set dirs(dirLeft,  1) =  0
	set dirs(dirLeft,  2) = -1
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
		}
    }

    // DFS
    set qSize = 1
    set q(1, 1) = 1
    set q(1, 2) = 2
    set q(1, 3) = 0
    set result = 0
    while qSize {
	    set y = q(qSize, 1)
	    set x = q(qSize, 2)
	    set pathSize = q(qSize, 3)
	    set qSize = qSize - 1
	    
		if (y = height) && (pathSize > result){
			set result = pathSize
		} else {
			set ndCount = 1
			if data(y, x) = "^" {
				set nextDirs(1) = dirUp
			}
			if data(y, x) = "v" {
				set nextDirs(1) = dirDown
			}
			if data(y, x) = "<" {
				set nextDirs(1) = dirLeft
			}
			if data(y, x) = ">" {
				set nextDirs(1) = dirRight
			}
			if data(y, x) = "." {
				set ndCount = 4
				for d = 1:1:4 {
					set nextDirs(d) = d
				}
			}
			for i = 1:1:ndCount {
				set ny = y + dirs(nextDirs(i), 1)
				set nx = x + dirs(nextDirs(i), 2)
	    		if (nx < 1) || (ny < 1) || (nx > width) || (ny > height) {
	    		} else {
		    		if (data(ny, nx) '= "#") && '(..onPath(.path, pathSize, ny, nx)) {
					    set path(pathSize + 1, 1) = y
					    set path(pathSize + 1, 2) = x
					    set qSize = qSize + 1
					    set q(qSize, 1) = ny
					    set q(qSize, 2) = nx
					    set q(qSize, 3) = pathSize + 1
				    }
	    		}
			}
		}

    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set dirDown = 1
    set dirRight = 2
    set dirLeft = 3
    set dirUp = 4
	set dirs(dirDown,  1) =  1
	set dirs(dirDown,  2) =  0
	set dirs(dirRight, 1) =  0
	set dirs(dirRight, 2) =  1
	set dirs(dirLeft,  1) =  0
	set dirs(dirLeft,  2) = -1
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
		}
    }
    
    // Build graph & remove long passages
    for y = 1:1:height {
	    for x = 1:1:width {
		    if data(y, x) '= "#" {
			    set nCount(y, x) = 0
			    for i = 1:1:4 {
					set ny = y + dirs(i, 1)
					set nx = x + dirs(i, 2)
		    		if (nx < 1) || (ny < 1) || (nx > width) || (ny > height) {
		    		} else {
			    		if data(ny, nx) '= "#" {
				    		set nCount(y, x) = nCount(y, x) + 1
				    		set neighbors(y, x, nCount(y, x), 1) = ny
				    		set neighbors(y, x, nCount(y, x), 2) = nx
				    		set neighbors(y, x, nCount(y, x), 3) = 1
			    		}
		    		}
			    }
		    }
	    }
    }
    while 1 {
	    set isOk = 1
	    for y = 1:1:height {
		    for x = 1:1:width {
			    if (data(y, x) '= "#") && (nCount(y, x) = 2) {
				    set isOk = 0
				    for i = 1:1:2 {
					    set cy = neighbors(y, x, i, 1)
					    set cx = neighbors(y, x, i, 2)
					    set dy = neighbors(y, x, 3 - i, 1)
					    set dx = neighbors(y, x, 3 - i, 2)
					    set dist = neighbors(y, x, 3 - i, 3)
					    for j = 1:1:nCount(cy, cx) {
						    set ny = neighbors(cy, cx, j, 1)
						    set nx = neighbors(cy, cx, j, 2)
						    if (ny = y) && (nx = x) {
							    set neighbors(cy, cx, j, 1) = dy
							    set neighbors(cy, cx, j, 2) = dx
							    set neighbors(cy, cx, j, 3) = neighbors(cy, cx, j, 3) + dist
						    }
					    }
				    }
				    set nCount(y, x) = 0
			    }
		    }
	    }
	    if isOk {
		    QUIT
	    }
    }

    for y = 1:1:height {
	    for x = 1:1:width {
		    if (data(y, x) '= "#") && nCount(y, x) {
			    // write "(", y, ", ", x, "): "
			    for i = 1:1:nCount(y, x) {
			    	set ny = neighbors(y, x, i, 1)
			    	set nx = neighbors(y, x, i, 2)
			    	set dist = neighbors(y, x, i, 3)
			    	set distances(y, x, ny, nx) = dist
			    	// write "(", ny, ", ", nx, ", ", dist, ") "
			    }
		    	// write !
		    }
	    }
    }

	// DFS
    set qSize = 1
    set q(1, 1) = 1
    set q(1, 2) = 2
    set q(1, 3) = 0
    set result = 0
    while qSize {
	    set y = q(qSize, 1)
	    set x = q(qSize, 2)
	    set pathSize = q(qSize, 3)
	    set qSize = qSize - 1

		if (y = height) {
			set dist = 0 
			set py = y
			set px = x
			for i = pathSize:-1:1 {
				set dist = dist + distances(py, px, path(i, 1), path(i, 2))
				set py = path(i, 1)
				set px = path(i, 2)
			}
			if dist > result {
				set result = dist
				// write result,!
			}
		} else {
			for i = 1:1:nCount(y, x) {
				set ny = neighbors(y, x, i, 1)
				set nx = neighbors(y, x, i, 2)
	    		if '(..onPath(.path, pathSize, ny, nx)) {
		    		set path(pathSize + 1, 1) = y
		    		set path(pathSize + 1, 2) = x
		    		set qSize = qSize + 1
		    		set q(qSize, 1) = ny
		    		set q(qSize, 2) = nx
		    		set q(qSize, 3) = pathSize + 1
	    		}
			}
		}

    }
    return result
}

}
