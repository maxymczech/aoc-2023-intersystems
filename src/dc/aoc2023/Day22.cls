Class dc.aoc2023.Day22 Extends dc.aoc2023.Base
{

Parameter InputFile = "input22.txt";

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
    set brickCount = 0
    set max(1) = 0
    set max(2) = 0
    set max(3) = 0
    set voxGround = -2
    set voxEmpty = -1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set brickCount = brickCount + 1
		set a = $piece(line, "~", 1)
		set b = $piece(line, "~", 2)
		for i = 1:1:3 {
			set bricks(brickCount, 1, i) = $piece(a, ",", i)
			set bricks(brickCount, 2, i) = $piece(b, ",", i)
			if bricks(brickCount, 2, i) > max(i) {
				set max(i) = bricks(brickCount, 2, i)
			}
		}
    }

	// Bubble sort :)
	for i = 1:1:brickCount {
		for j = 1:1:(brickCount - i) {
			set cmp = bricks(j, 1, 3) - bricks(j + 1, 1, 3)
			if cmp > 0 {
				for k = 1:1:2 {
					for l = 1:1:3 {
						set t = bricks(j, k, l)
						set bricks(j, k, l) = bricks(j + 1, k, l)
						set bricks(j + 1, k, l) = t
					}
				}
			}
		}
	}

    for x = 0:1:max(1) {
	    for y = 0:1:max(2) {
		    for z = 0:1:max(3) {
			    set data(x, y, z) = voxEmpty
		    }
		    set data(x, y, 0) = voxGround
	    }
    }

    for bi = 1:1:brickCount {
	    set height = bricks(bi, 2, 3) + 1 - bricks(bi, 1, 3)
	    for z = bricks(bi, 1, 3):-1:1 {
		    set isOk = 1
		    for x = bricks(bi, 1, 1):1:bricks(bi, 2, 1) {
			    for y = bricks(bi, 1, 2):1:bricks(bi, 2, 2) {
				    if data(x, y, z - 1) '= -1 {
					    set isOk = 0
					    QUIT
				    }
			    }
			    if 'isOk {
				    QUIT
			    }
		    }
		    if 'isOk {
			    for x = bricks(bi, 1, 1):1:bricks(bi, 2, 1) {
				    for y = bricks(bi, 1, 2):1:bricks(bi, 2, 2) {
					    for i = 1:1:height {
						    set data(x, y, z + i - 1) = bi
					    }
				    }
			    }
			    QUIT
		    }
	    }
    }

    for bi = 1:1:brickCount {
	    set supportsCount(bi) = 0
	    set supportedCount(bi) = 0
    }
    for z = 1:1:(max(3)-1) {
    	for x = 0:1:max(1) {
		    for y = 0:1:max(2) {
			    if (data(x, y, z) '= data(x, y, z + 1)) && (data(x, y, z) '= -1) && (data(x, y, z + 1) '= -1) {
				    set inSupports = 0
				    for i = 1:1:supportsCount(data(x, y, z)) {
					    if (supports(data(x, y, z), i) = data(x, y, z + 1)) {
						    set inSupports = 1
					    }
				    }
				    if 'inSupports {
					    set supportsCount(data(x, y, z)) = supportsCount(data(x, y, z)) + 1
					    set supports(data(x, y, z), supportsCount(data(x, y, z))) = data(x, y, z + 1)
				    }
				    
				    set inSupported = 0
				    for i = 1:1:supportedCount(data(x, y, z + 1)) {
					    if (supported(data(x, y, z + 1), i) = data(x, y, z)) {
						    set inSupported = 1
					    }
				    }
				    if 'inSupported {
					    set supportedCount(data(x, y, z + 1)) = supportedCount(data(x, y, z + 1)) + 1
					    set supported(data(x, y, z + 1), supportedCount(data(x, y, z + 1))) = data(x, y, z)
				    }
			    }
		    }
    	}
    }
    
    set result = 0
    for bi = 1:1:brickCount {
	    if 'supportsCount(bi) {
		    set isOk = 1
	    } else {
		    set isOk = 1
		    for i = 1:1:supportsCount(bi) {
			    set x = supports(bi, i)
			    if supportedCount(x) <= 1 {
				    set isOk = 0
			    }
		    }
	    }
	    if isOk {
		    set result = result + 1
	    }
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set brickCount = 0
    set max(1) = 0
    set max(2) = 0
    set max(3) = 0
    set voxGround = -2
    set voxEmpty = -1
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set brickCount = brickCount + 1
		set a = $piece(line, "~", 1)
		set b = $piece(line, "~", 2)
		for i = 1:1:3 {
			set bricks(brickCount, 1, i) = $piece(a, ",", i)
			set bricks(brickCount, 2, i) = $piece(b, ",", i)
			if bricks(brickCount, 2, i) > max(i) {
				set max(i) = bricks(brickCount, 2, i)
			}
		}
    }

	// Bubble sort :)
	for i = 1:1:brickCount {
		for j = 1:1:(brickCount - i) {
			set cmp = bricks(j, 1, 3) - bricks(j + 1, 1, 3)
			if cmp > 0 {
				for k = 1:1:2 {
					for l = 1:1:3 {
						set t = bricks(j, k, l)
						set bricks(j, k, l) = bricks(j + 1, k, l)
						set bricks(j + 1, k, l) = t
					}
				}
			}
		}
	}

    for x = 0:1:max(1) {
	    for y = 0:1:max(2) {
		    for z = 0:1:max(3) {
			    set data(x, y, z) = voxEmpty
		    }
		    set data(x, y, 0) = voxGround
	    }
    }

    for bi = 1:1:brickCount {
	    set height = bricks(bi, 2, 3) + 1 - bricks(bi, 1, 3)
	    for z = bricks(bi, 1, 3):-1:1 {
		    set isOk = 1
		    for x = bricks(bi, 1, 1):1:bricks(bi, 2, 1) {
			    for y = bricks(bi, 1, 2):1:bricks(bi, 2, 2) {
				    if data(x, y, z - 1) '= -1 {
					    set isOk = 0
					    QUIT
				    }
			    }
			    if 'isOk {
				    QUIT
			    }
		    }
		    if 'isOk {
			    for x = bricks(bi, 1, 1):1:bricks(bi, 2, 1) {
				    for y = bricks(bi, 1, 2):1:bricks(bi, 2, 2) {
					    for i = 1:1:height {
						    set data(x, y, z + i - 1) = bi
					    }
				    }
			    }
			    QUIT
		    }
	    }
    }

    for bi = 1:1:brickCount {
	    set supportsCount(bi) = 0
	    set supportedCount(bi) = 0
    }
    for z = 1:1:(max(3)-1) {
    	for x = 0:1:max(1) {
		    for y = 0:1:max(2) {
			    if (data(x, y, z) '= data(x, y, z + 1)) && (data(x, y, z) '= -1) && (data(x, y, z + 1) '= -1) {
				    set inSupports = 0
				    for i = 1:1:supportsCount(data(x, y, z)) {
					    if (supports(data(x, y, z), i) = data(x, y, z + 1)) {
						    set inSupports = 1
					    }
				    }
				    if 'inSupports {
					    set supportsCount(data(x, y, z)) = supportsCount(data(x, y, z)) + 1
					    set supports(data(x, y, z), supportsCount(data(x, y, z))) = data(x, y, z + 1)
				    }
				    
				    set inSupported = 0
				    for i = 1:1:supportedCount(data(x, y, z + 1)) {
					    if (supported(data(x, y, z + 1), i) = data(x, y, z)) {
						    set inSupported = 1
					    }
				    }
				    if 'inSupported {
					    set supportedCount(data(x, y, z + 1)) = supportedCount(data(x, y, z + 1)) + 1
					    set supported(data(x, y, z + 1), supportedCount(data(x, y, z + 1))) = data(x, y, z)
				    }
			    }
		    }
    	}
    }
    
    set result = 0
    for bi = 1:1:brickCount {
	    set willFallCount = 0
	    for i = 1:1:supportsCount(bi) {
		    set x = supports(bi, i)
		    if supportedCount(x) = 1 {
			    set willFallCount = willFallCount + 1
			    set willFall(willFallCount) = x
		    }
	    }
	    set i = 1
	    while i <= willFallCount {
		    for j = 1:1:supportsCount(willFall(i)) {
			    set by = supports(willFall(i), j)
			    set alreadyFalls = 0
			    for k = 1:1:willFallCount {
				    if willFall(k) = by {
					    set alreadyFalls = 1
				    }
			    }
			    if 'alreadyFalls {
				    set isOk = 1
				    for k = 1:1:supportedCount(by) {
					    set t = 0
					    for l = 1:1:willFallCount {
						    if willFall(l) = supported(by, k) {
							    set t = 1
							    QUIT
						    }
					    }
					    if 't {
						    set isOk = 0
						    QUIT
					    }
				    }
				    if isOk {
					    set willFallCount = willFallCount + 1
					    set willFall(willFallCount) = by
				    }
			    }
		    }
		    set i = i + 1
	    }
	    set result = result + willFallCount
    }
    return result
}

}
