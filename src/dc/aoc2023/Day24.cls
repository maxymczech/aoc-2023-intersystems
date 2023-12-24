Class dc.aoc2023.Day24 Extends dc.aoc2023.Base
{

Parameter InputFile = "input24.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod Part1(verbose = 0) As %Integer
{
	set cmin = 200000000000000
	set cmax = 400000000000000
    set stream = ..GetInput(..#InputFile)
    set numLines = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set numLines = numLines + 1
		set p = $piece(line, " @ ", 1)
		set v = $piece(line, " @ ", 2)
		for i = 1:1:3 {
			set data(numLines, "p", i) = $piece(p, ", ", i)
			set data(numLines, "v", i) = $piece(v, ", ", i)
		}
    }

    set result = 0
    for i = 2:1:numLines {
	    for j = 1:1:(i - 1) {
		    set a = data(i, "v", 1)
		    set b = -data(j, "v", 1)
		    set c = data(j, "p", 1) - data(i, "p", 1)
		    set d = data(i, "v", 2)
		    set e = -data(j, "v", 2)
		    set f = data(j, "p", 2) - data(i, "p", 2)
		    set div = e - ((b * d) / a)
		    if div {
			    set u = (f - ((c * d) / a)) / div
			    set t = (c - (b * u)) / a
			    if (u > 0) && (t > 0) {
				    set cx = data(j, "p", 1) + (u * data(j, "v", 1))
				    set cy = data(j, "p", 2) + (u * data(j, "v", 2))
				    if (cx >= cmin) && (cx <= cmax) && (cy >= cmin) && (cy <= cmax) {
					    set result = result + 1
				    }
			    }
		    }
	    }
    }
    return result
}

ClassMethod Cross(ByRef data, i, pi, j, pj, ByRef c)
{
	set c(1) = (data(i, pi, 2) * data(j, pj, 3)) - (data(i, pi, 3) * data(j, pj, 2))
	set c(2) = (data(i, pi, 3) * data(j, pj, 1)) - (data(i, pi, 1) * data(j, pj, 3))
	set c(3) = (data(i, pi, 1) * data(j, pj, 2)) - (data(i, pi, 2) * data(j, pj, 1))
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set numLines = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set numLines = numLines + 1
		set p = $piece(line, " @ ", 1)
		set v = $piece(line, " @ ", 2)
		for i = 1:1:3 {
			set data(numLines, "p", i) = $piece(p, ", ", i)
			set data(numLines, "v", i) = $piece(v, ", ", i)
		}
    }

    // Prepare linear system
    set i1 = 1
    set i2 = 2
    set i3 = 3
    for i = 1:1:3 {
	    set dp1(i) = data(i1, "p", i) - data(i2, "p", i)
	    set dv1(i) = data(i1, "v", i) - data(i2, "v", i)
	    set dp2(i) = data(i1, "p", i) - data(i3, "p", i)
	    set dv2(i) = data(i1, "v", i) - data(i3, "v", i)
    }
    do ..Cross(.data, i1, "p", i1, "v", .c11)
    do ..Cross(.data, i2, "p", i2, "v", .c12)
    do ..Cross(.data, i1, "p", i1, "v", .c21)
    do ..Cross(.data, i3, "p", i3, "v", .c22)
    set A(1, 1) = 0
    set A(1, 2) = dv1(3)
    set A(1, 3) = -dv1(2)
    set A(1, 4) = 0
    set A(1, 5) = dp1(3)
    set A(1, 6) = -dp1(2)
    set A(2, 1) = -dv1(3)
    set A(2, 2) = 0
    set A(2, 3) = dv1(1)
    set A(2, 4) = -dp1(3)
    set A(2, 5) = 0
    set A(2, 6) = dp1(1)
    set A(3, 1) = dv1(2)
    set A(3, 2) = -dv1(1)
    set A(3, 3) = 0
    set A(3, 4) = dp1(2)
    set A(3, 5) = -dp1(1)
    set A(3, 6) = 0
    set A(4, 1) = 0
    set A(4, 2) = dv2(3)
    set A(4, 3) = -dv2(2)
    set A(4, 4) = 0
    set A(4, 5) = dp2(3)
    set A(4, 6) = -dp2(2)
    set A(5, 1) = -dv2(3)
    set A(5, 2) = 0
    set A(5, 3) = dv2(1)
    set A(5, 4) = -dp2(3)
    set A(5, 5) = 0
    set A(5, 6) = dp2(1)
    set A(6, 1) = dv2(2)
    set A(6, 2) = -dv2(1)
    set A(6, 3) = 0
    set A(6, 4) = dp2(2)
    set A(6, 5) = -dp2(1)
    set A(6, 6) = 0

    set A(1, 7) = c11(1) - c12(1)
    set A(2, 7) = c11(2) - c12(2)
    set A(3, 7) = c11(3) - c12(3)
    set A(4, 7) = c21(1) - c22(1)
    set A(5, 7) = c21(2) - c22(2)
    set A(6, 7) = c21(3) - c22(3)
    
    // Gauss-Jordan elimination
    set h = 1
    set k = 1
    set m = 6
    set n = 7
    while (h <= m) && (k <= n) {
	    set iMax = h
	    for i = (h+1):1:m {
		    if $zabs(A(i, k)) > $zabs(A(iMax, k)) {
			    set iMax = i
		    }
	    }
	    if A(iMax, k) = 0 {
		    set k = k + 1
	    } else {
		    for j = 1:1:n {
			    set t = A(h, j)
			    set A(h, j) = A(iMax, j)
			    set A(iMax, j) = t
		    }
		    for i = (h+1):1:m {
			    set f = A(i, k) / A(h, k)
			    set A(i, k) = 0
			    for j = (k+1):1:n {
				    set A(i, j) = A(i, j) - (A(h, j) * f)
			    }
		    }
		    set h = h + 1
		    set k = k + 1
	    }
    }
    for i = m:-1:1 {
	    set s(i) = A(i, n) / A(i, i)

	    for j = i:-1:1 {
		    set A(j, n) = A(j, n) - (s(i) * A(j, i))
	    }
    }
    
    // Round result for minor numerical errors
    set result = s(1) + s(2) + s(3)
    set result = $number(result, 0)

    return result
}

}
