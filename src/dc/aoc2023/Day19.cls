Class dc.aoc2023.Day19 Extends dc.aoc2023.Base
{

Parameter InputFile = "input19.txt";

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
    set partsCount = 0
    set isParts = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line = "" {
			set isParts = 1
		} else {
			if isParts {
				set partsCount = partsCount + 1
				set part = $extract(line, 2, $length(line) - 1)
				for i = 1:1:100 {
					set prop = $piece(part, ",", i)
					if prop = "" {
						QUIT
					} else {
						set k = $piece(prop, "=", 1)
						set v = $piece(prop, "=", 2)
						set parts(partsCount, k) = v
					}
				}
			} else {
				set i1 = $find(line, "{")
				set wfName = $extract(line, 1, i1 - 2)
				set wfCounts(wfName) = 0
				set rest =  $extract(line, i1, $length(line) - 1)
				for i = 1:1:100 {
					set step = $piece(rest, ",", i)
					if step = "" {
						QUIT
					} else {
						set wfCounts(wfName) = wfCounts(wfName) + 1
						if $find(step, ":") {
							set wfStepNames(wfName, wfCounts(wfName)) = $piece(step, ":", 2)
							set tmp = $piece(step, ":", 1)
							if $find(tmp, "<") {
								set wfStepCondition(wfName, wfCounts(wfName)) = "<"
								set wfStepKey(wfName, wfCounts(wfName)) = $piece(tmp, "<", 1)
								set wfStepValue(wfName, wfCounts(wfName)) = $piece(tmp, "<", 2)
							} else {
								set wfStepCondition(wfName, wfCounts(wfName)) = ">"
								set wfStepKey(wfName, wfCounts(wfName)) = $piece(tmp, ">", 1)
								set wfStepValue(wfName, wfCounts(wfName)) = $piece(tmp, ">", 2)
							}
						} else {
							set wfStepNames(wfName, wfCounts(wfName)) = step
							set wfStepCondition(wfName, wfCounts(wfName)) = ""
						}
					}
				}
			}
		}
    }
    for i = 1:1:partsCount {
	    set wf = "in"
	    set partValue = parts(i, "x") + parts(i, "m") + parts(i, "a") + parts(i, "s")
	    set isDone = 0
	    while 1 {
		    for j = 1:1:wfCounts(wf) {
			    set stepOk = 1
			    if wfStepCondition(wf, j) '= "" {
				    set k = wfStepKey(wf, j)
				    set v = wfStepValue(wf, j)
				    if wfStepCondition(wf, j) = "<" {
					    if parts(i, k) < v {
						    set stepOk = 1
					    } else {
						    set stepOk = 0
					    }
				    } else {
					    if parts(i, k) > v {
						    set stepOk = 1
					    } else {
						    set stepOk = 0
					    }
				    }
			    }
			    if stepOk {
				    if wfStepNames(wf, j) = "A" {
					    set result = result + partValue
					    set isDone = 1
				    } elseif wfStepNames(wf, j) = "R" {
					    set isDone = 1
				    } else {
					    set wf = wfStepNames(wf, j)
				    }
				    QUIT
			    }
		    }
		    if isDone {
			    QUIT
		    }
	    }
    }
    return result
}

ClassMethod Rec(wf, ByRef range, ByRef wfCounts, ByRef wfStepKey, ByRef wfStepValue, ByRef wfStepCondition, ByRef wfStepNames)
{
	if wf = "R" {
		return 0
	}
	if wf = "A" {
		return (range("x", 2) + 1 - range("x", 1)) * (range("m", 2) + 1 - range("m", 1)) * (range("a", 2) + 1 - range("a", 1)) * (range("s", 2) + 1 - range("s", 1))
	}
	set result = 0
	set newRange("x", 1) = range("x", 1)
	set newRange("x", 2) = range("x", 2)
	set newRange("m", 1) = range("m", 1)
	set newRange("m", 2) = range("m", 2)
	set newRange("a", 1) = range("a", 1)
	set newRange("a", 2) = range("a", 2)
	set newRange("s", 1) = range("s", 1)
	set newRange("s", 2) = range("s", 2)
	for j = 1:1:wfCounts(wf) {
		set k = wfStepKey(wf, j)
		set v = wfStepValue(wf, j)
		set s = wfStepCondition(wf, j)
		set nextName = wfStepNames(wf, j)

		if s = "" {
			set result = result + ..Rec(nextName, .newRange, .wfCounts, .wfStepKey, .wfStepValue, .wfStepCondition, .wfStepNames)
		} else {
			if s = "<" {
				set tmp = newRange(k, 2)
				if (v - 1) < newRange(k, 2) {
					set newRange(k, 2) = v - 1
				}
			}
			if s = ">" {
				set tmp = newRange(k, 1)
				if (v + 1) > newRange(k, 1) {
					set newRange(k, 1) = v + 1
				}
			}
			if newRange(k, 2) > newRange(k, 1) {
				set result = result + ..Rec(nextName, .newRange, .wfCounts, .wfStepKey, .wfStepValue, .wfStepCondition, .wfStepNames)
			}
			if s = "<" {
				set newRange(k, 2) = tmp
				if v > newRange(k, 1) {
					set newRange(k, 1) = v
				}
			}
			if s = ">" {
				set newRange(k, 1) = tmp
				if v < newRange(k, 2) {
					set newRange(k, 2) = v
				}
			}
			if newRange(k, 2) < newRange(k, 1) {
				QUIT
			}
		}
	}
	return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set isParts = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		if line = "" {
			set isParts = 1
		} else {
			if isParts {
			} else {
				set i1 = $find(line, "{")
				set wfName = $extract(line, 1, i1 - 2)
				set wfCounts(wfName) = 0
				set rest =  $extract(line, i1, $length(line) - 1)
				for i = 1:1:100 {
					set step = $piece(rest, ",", i)
					if step = "" {
						QUIT
					} else {
						set wfCounts(wfName) = wfCounts(wfName) + 1
						if $find(step, ":") {
							set wfStepNames(wfName, wfCounts(wfName)) = $piece(step, ":", 2)
							set tmp = $piece(step, ":", 1)
							if $find(tmp, "<") {
								set wfStepCondition(wfName, wfCounts(wfName)) = "<"
								set wfStepKey(wfName, wfCounts(wfName)) = $piece(tmp, "<", 1)
								set wfStepValue(wfName, wfCounts(wfName)) = $piece(tmp, "<", 2)
							} else {
								set wfStepCondition(wfName, wfCounts(wfName)) = ">"
								set wfStepKey(wfName, wfCounts(wfName)) = $piece(tmp, ">", 1)
								set wfStepValue(wfName, wfCounts(wfName)) = $piece(tmp, ">", 2)
							}
						} else {
							set wfStepNames(wfName, wfCounts(wfName)) = step
							set wfStepCondition(wfName, wfCounts(wfName)) = ""
							set wfStepKey(wfName, wfCounts(wfName)) = ""
							set wfStepValue(wfName, wfCounts(wfName)) = ""
						}
					}
				}
			}
		}
    }
    
    set range("x", 1) = 1
    set range("x", 2) = 4000
    set range("m", 1) = 1
    set range("m", 2) = 4000
    set range("a", 1) = 1
    set range("a", 2) = 4000
    set range("s", 1) = 1
    set range("s", 2) = 4000
    return ..Rec("in", .range, .wfCounts, .wfStepKey, .wfStepValue, .wfStepCondition, .wfStepNames)
}

}
