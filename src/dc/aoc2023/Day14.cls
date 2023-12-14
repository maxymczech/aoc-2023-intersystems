Class dc.aoc2023.Day14 Extends dc.aoc2023.Base
{

Parameter InputFile = "input14.txt";

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
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		set height = height + 1
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
		}
    }

    for y=1:1:height {
	    for x = 1:1:width {
		    if data(y,x) = "O" {
			    for ty = (y - 1):-1:1 {
				    if data(ty, x) = "." {
					    set data(ty, x) = "O"
					    set data(ty + 1, x) = "."
				    } else {
					    QUIT
				    }
			    }
		    }
	    }
    }
    
    for y=1:1:height {
	    for x = 1:1:width {
		    if data(y,x) = "O" {
			    set result = result + height + 1 - y
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
    set cacheSize = 0
    set cacheUsed = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set width = $length(line)
		set height = height + 1
		for i = 1:1:width {
			set data(height, i) = $extract(line, i)
		}
    }
    set keySize = width * height

	for c = 1:1:1000000000 {
		// n
	    for y=1:1:height {
		    for x = 1:1:width {
			    if data(y,x) = "O" {
				    for ty = (y - 1):-1:1 {
					    if data(ty, x) = "." {
						    set data(ty, x) = "O"
						    set data(ty + 1, x) = "."
					    } else {
						    QUIT
					    }
				    }
			    }
		    }
	    }
		// w
		for x = 1:1:width {
	    	for y=1:1:height {
			    if data(y,x) = "O" {
				    for tx = (x - 1):-1:1 {
					    if data(y, tx) = "." {
						    set data(y, tx) = "O"
						    set data(y, tx + 1) = "."
					    } else {
						    QUIT
					    }
				    }
			    }
		    }
	    }
		// s
	    for y=height:-1:1 {
		    for x = width:-1:1 {
			    if data(y,x) = "O" {
				    for ty = (y + 1):1:height {
					    if data(ty, x) = "." {
						    set data(ty, x) = "O"
						    set data(ty - 1, x) = "."
					    } else {
						    QUIT
					    }
				    }
			    }
		    }
	    }
		// e
		for x = width:-1:1 {
	    	for y=height:-1:1 {
			    if data(y,x) = "O" {
				    for tx = (x + 1):1:width {
					    if data(y, tx) = "." {
						    set data(y, tx) = "O"
						    set data(y, tx - 1) = "."
					    } else {
						    QUIT
					    }
				    }
			    }
		    }
	    }
	    set count = 0
    	for y=1:1:height {
		    for x = 1:1:width {
			    if data(y,x) = "O" {
			    	set count = count + height + 1 - y
			    }
		    }
	    }
	    if 'cacheUsed {
		    set ki = 0
			for x = 1:1:width {
		    	for y=1:1:height {
			    	set ki = ki + 1
			    	set key(ki) = data(y, x)
		    	}
			}
			set inCache = 0
			set cacheFound = -1
			for ci = 1:1:cacheSize {
				set keyOk = 1
				for j = 1:1:keySize {
					if cacheKeys(ci, j) '= key(j) {
						set keyOk = 0
						QUIT
					}
				}
				if keyOk {
					set inCache = 1
					set cacheFound = ci
					QUIT
				}
			}
			if 'inCache {
				set cacheSize = cacheSize + 1
				set cacheReps(cacheSize) = 1
				for j = 1:1:keySize {
					set cacheKeys(cacheSize, j) = key(j)
				}
			} else {
				if cacheReps(cacheFound) = 1 {
					set cacheReps(cacheFound) = cacheReps(cacheFound) + 1
				} else {
					set cacheUsed = 1
					set twos = 0
					for ci = 1:1:cacheSize {
						if cacheReps(ci) = 2 {
							set twos = twos + 1
						}
					}
					while (c + twos) < 1000000000 {
						set c = c + twos
					}
				}
			}

	    }
	}
    
    for y=1:1:height {
	    for x = 1:1:width {
		    if data(y,x) = "O" {
			    set result = result + height + 1 - y
		    }
	    }
    }

    return result
}

}
