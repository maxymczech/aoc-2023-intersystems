Class dc.aoc2023.Day16 Extends dc.aoc2023.Base
{

Parameter InputFile = "input16.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Calculate(ByRef data, height, width, sy, sx, sdir) As %Integer
{
	set dirs("down", 1) = 1
	set dirs("down", 2) = 0
	set dirs("left", 1) = 0
	set dirs("left", 2) = -1
	set dirs("right", 1) = 0
	set dirs("right", 2) = 1
	set dirs("up", 1) = -1
	set dirs("up", 2) = 0

	for y = 1:1:height {
		for x = 1:1:width {
			set visited(y, x, "down") = 0
			set visited(y, x, "left") = 0
			set visited(y, x, "right") = 0
			set visited(y, x, "up") = 0
		}
	}

	set beamsCount = 1
	set beams(1, 1) = sy
	set beams(1, 2) = sx
	set beams(1, 3) = sdir
	while beamsCount {
		set nextBeamsCount = 0
		for i = 1:1:beamsCount {
			set dir = beams(i, 3)
			set ny = beams(i, 1) + dirs(dir, 1)
			set nx = beams(i, 2) + dirs(dir, 2)
			if (ny < 1) || (ny > height) || (nx < 1) || (nx > width) || (visited(ny, nx, dir)) {
			} else {
				set visited(ny, nx, dir) = 1
				set nextBeamsCount = nextBeamsCount + 1
				set nextBeams(nextBeamsCount, 1) = ny
				set nextBeams(nextBeamsCount, 2) = nx
				if dir = "left" {
					if data(ny, nx) = "/" {
						set nextBeams(nextBeamsCount, 3) = "down"
					} else {
						if data(ny, nx) = "\" {
							set nextBeams(nextBeamsCount, 3) = "up"
						} else {
							if data(ny, nx) = "|" {
								set nextBeams(nextBeamsCount, 3) = "up"
								set nextBeamsCount = nextBeamsCount + 1
								set nextBeams(nextBeamsCount, 1) = ny
								set nextBeams(nextBeamsCount, 2) = nx
								set nextBeams(nextBeamsCount, 3) = "down"
							} else {
								set nextBeams(nextBeamsCount, 3) = dir
							}
						}
					}
				}
				if dir = "right" {
					if data(ny, nx) = "/" {
						set nextBeams(nextBeamsCount, 3) = "up"
					} else {
						if data(ny, nx) = "\" {
							set nextBeams(nextBeamsCount, 3) = "down"
						} else {
							if data(ny, nx) = "|" {
								set nextBeams(nextBeamsCount, 3) = "up"
								set nextBeamsCount = nextBeamsCount + 1
								set nextBeams(nextBeamsCount, 1) = ny
								set nextBeams(nextBeamsCount, 2) = nx
								set nextBeams(nextBeamsCount, 3) = "down"
							} else {
								set nextBeams(nextBeamsCount, 3) = dir
							}
						}
					}
				}
				if dir = "down" {
					if data(ny, nx) = "/" {
						set nextBeams(nextBeamsCount, 3) = "left"
					} else {
						if data(ny, nx) = "\" {
							set nextBeams(nextBeamsCount, 3) = "right"
						} else {
							if data(ny, nx) = "-" {
								set nextBeams(nextBeamsCount, 3) = "left"
								set nextBeamsCount = nextBeamsCount + 1
								set nextBeams(nextBeamsCount, 1) = ny
								set nextBeams(nextBeamsCount, 2) = nx
								set nextBeams(nextBeamsCount, 3) = "right"
							} else {
								set nextBeams(nextBeamsCount, 3) = dir
							}
						}
					}
				}
				if dir = "up" {
					if data(ny, nx) = "/" {
						set nextBeams(nextBeamsCount, 3) = "right"
					} else {
						if data(ny, nx) = "\" {
							set nextBeams(nextBeamsCount, 3) = "left"
						} else {
							if data(ny, nx) = "-" {
								set nextBeams(nextBeamsCount, 3) = "left"
								set nextBeamsCount = nextBeamsCount + 1
								set nextBeams(nextBeamsCount, 1) = ny
								set nextBeams(nextBeamsCount, 2) = nx
								set nextBeams(nextBeamsCount, 3) = "right"
							} else {
								set nextBeams(nextBeamsCount, 3) = dir
							}
						}
					}
				}
			}
		}
		set beamsCount = nextBeamsCount
		for i = 1:1:beamsCount {
			set beams(i, 1) = nextBeams(i, 1)
			set beams(i, 2) = nextBeams(i, 2)
			set beams(i, 3) = nextBeams(i, 3)
		}
	}
	set count = 0
	for y = 1:1:height {
		for x = 1:1:width {
			if visited(y, x, "down") || visited(y, x, "up") || visited(y, x, "left") || visited(y, x, "right") {
				set count = count + 1
			}
		}
	}
	return count
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set height = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set height = height + 1
		set width = $length(line)
		for x = 1:1:width {
			set data(height, x) = $extract(line, x)
		}
    }
    set result = ..Calculate(.data, height, width, 1, 0, "right")
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set height = 0
    set result = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set height = height + 1
		set width = $length(line)
		for x = 1:1:width {
			set data(height, x) = $extract(line, x)
		}
    }
    for y = 1:1:height {
	    set count = ..Calculate(.data, height, width, y, 0, "right")
	    if count > result {
		    set result = count
	    }
	    set count = ..Calculate(.data, height, width, y, width + 1, "left")
	    if count > result {
		    set result = count
	    }
    }
    for x = 1:1:width {
	    set count = ..Calculate(.data, height, width, 0, x, "down")
	    if count > result {
		    set result = count
	    }
	    set count = ..Calculate(.data, height, width, height + 1, x, "up")
	    if count > result {
		    set result = count
	    }
    }
    
    return result
}

}
