Class dc.aoc2023.Day15 Extends dc.aoc2023.Base
{

Parameter InputFile = "input15.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Hash(str) As %Integer
{
	set hash = 0
	for i = 1:1:$length(str) {
		set hash = ((hash + $ascii(str, i)) * 17) # 256
	}
	return hash
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set line = $zstrip(stream.ReadLine(), "*C")
    set result = 0
    for i = 1:1:10000 {
	    set step = $piece(line, ",", i)
	    if step = "" {
		    QUIT
	    } else {
		    set result = result + ..Hash(step)
	    }
    }
    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set line = $zstrip(stream.ReadLine(), "*C")
    set result = 0
    for i = 1:1:256 {
	    set boxCount(i) = 0
    }
    for i = 1:1:10000 {
	    set step = $piece(line, ",", i)
	    if step = "" {
		    QUIT
	    } else {
		    if $find(step, "-") {
			    set op = "-"
			    set label = $piece(step, "-", 1)
		    } else {
			    set op = "="
			    set label = $piece(step, "=", 1)
			    set focal = $piece(step, "=", 2)
		    }
		    set boxNumber = ..Hash(label) + 1
		    set inBox = 0
		    for j = 1:1:boxCount(boxNumber) {
			    if boxLabel(boxNumber, j) = label {
				    set inBox = j
			    }
		    }
		    if (op = "-") && inBox {
			    for j = (inBox + 1):1:boxCount(boxNumber) {
				    set boxLabel(boxNumber, j - 1) = boxLabel(boxNumber, j)
				    set boxFocal(boxNumber, j - 1) = boxFocal(boxNumber, j)
			    }
			    set boxCount(boxNumber) = boxCount(boxNumber) - 1
		    }
		    if op = "=" {
			    if inBox {
				    set boxFocal(boxNumber, inBox) = focal
			    } else {
				    set boxCount(boxNumber) = boxCount(boxNumber) + 1
				    set boxLabel(boxNumber, boxCount(boxNumber)) = label
				    set boxFocal(boxNumber, boxCount(boxNumber)) = focal

			    }
		    }
	    }
    }
    for i = 1:1:256 {
	    for j = 1:1:boxCount(i) {
		    set fp = i * j * boxFocal(i, j)
		    set result = result + fp
	    }
    }
    return result
}

}
