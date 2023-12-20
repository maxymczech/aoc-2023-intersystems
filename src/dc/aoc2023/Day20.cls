Class dc.aoc2023.Day20 Extends dc.aoc2023.Base
{

Parameter InputFile = "input20.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod gcd(a, b)
{
	if b = 0 {
		return a
	}
	return ..gcd(b, a # b)
}

ClassMethod lcm(a, b)
{
	return a * b / ..gcd(a, b)
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set nodeCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set p1 = $piece(line, " -> ", 1)
		set p2 = $piece(line, " -> ", 2)
		if p1 = "broadcaster" {
			set type = "button"
			set name = "broadcaster"
		} else {
			set type = $extract(p1, 1)
			set name = $extract(p1, 2, $length(line))
		}
		set nodeCount = nodeCount + 1
		set allNodes(nodeCount) = name
		set nextCount(name) = 0
		for i = 1:1:100 {
			set nn = $piece(p2, ", ", i)
			if nn = "" {
				QUIT
			} else {
				set nextCount(name) = nextCount(name) + 1
				set nextNode(name, i) = nn
			}
		}
		set nodeType(name) = type
		set nodeState(name) = 0
		set predCount(name) = 0
    }
	set nodeType("rx") = ""
	set nextCount("rx") = 0

	for i = 1:1:nodeCount {
		set name = allNodes(i)
		for j = 1:1:nextCount(name) {
			set nn = nextNode(name, j)
			if nodeType(nn) = "&" {
				set predCount(nn) = predCount(nn) + 1
				set predSignal(name, nn) = 0
			}
		}
	}
	
	set l = 0
	set h = 0
	for i = 1:1:1000 {
		set qSize = 1
		set q(1, "id") = "broadcaster"
		set q(1, "input") = 0
		set q(1, "from") = ""
		set l = l + 1 // button press low signal
		while qSize {
			set qNextSize = 0

			for j = 1:1:qSize {
				set id = q(j, "id")
				set input = q(j, "input")
				set from = q(j, "from")
				
				if nodeType(id) = "button" {
					for k = 1:1:nextCount(id) {
						set qNextSize = qNextSize + 1
						set qNext(qNextSize, "id") = nextNode(id, k)
						set qNext(qNextSize, "input") = 0
						set qNext(qNextSize, "from") = id
						set l = l + 1
					}
				}
				if nodeType(id) = "%" {
					if input = 0 {
						set nodeState(id) = 1 - nodeState(id)
						for k = 1:1:nextCount(id) {
							set qNextSize = qNextSize + 1
							set qNext(qNextSize, "id") = nextNode(id, k)
							set qNext(qNextSize, "input") = nodeState(id)
							set qNext(qNextSize, "from") = id
							if nodeState(id) {
								set h = h + 1
							} else {
								set l = l + 1
							}
						}
					}
				}
				if nodeType(id) = "&" {
					if input '= predSignal(from, id) {
						if (input) {
							set nodeState(id) = nodeState(id) + 1
						} else {
							set nodeState(id) = nodeState(id) - 1
						}
						set predSignal(from, id) = input
					}
					if predCount(id) = nodeState(id) {
						set output = 0
					} else {
						set output = 1
					}
					for k = 1:1:nextCount(id) {
						set qNextSize = qNextSize + 1
						set qNext(qNextSize, "id") = nextNode(id, k)
						set qNext(qNextSize, "input") = output
						set qNext(qNextSize, "from") = id
						if output {
							set h = h + 1
						} else {
							set l = l + 1
						}
					}
				}
			}

			set qSize = qNextSize
			for j = 1:1:qNextSize {
				set q(j, "id") = qNext(j, "id")
				set q(j, "input") = qNext(j, "input")
				set q(j, "from") = qNext(j, "from")
			}
		}
	}
    
    return l * h
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set nodeCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set p1 = $piece(line, " -> ", 1)
		set p2 = $piece(line, " -> ", 2)
		if p1 = "broadcaster" {
			set type = "button"
			set name = "broadcaster"
		} else {
			set type = $extract(p1, 1)
			set name = $extract(p1, 2, $length(line))
		}
		set nodeCount = nodeCount + 1
		set allNodes(nodeCount) = name
		set nextCount(name) = 0
		for i = 1:1:100 {
			set nn = $piece(p2, ", ", i)
			if nn = "" {
				QUIT
			} else {
				set nextCount(name) = nextCount(name) + 1
				set nextNode(name, i) = nn
			}
		}
		set nodeType(name) = type
		set nodeState(name) = 0
		set predCount(name) = 0
    }
	set nodeType("rx") = ""
	set nextCount("rx") = 0

	for i = 1:1:nodeCount {
		set name = allNodes(i)
		for j = 1:1:nextCount(name) {
			set nn = nextNode(name, j)
			if nodeType(nn) = "&" {
				set predCount(nn) = predCount(nn) + 1
				set predSignal(name, nn) = 0
			}
		}
	}
	
	// Predecessors of rx
	set predRxCount = 0
	set predRxDone = 0
	for i = 1:1:nodeCount {
		set name = allNodes(i)
		for j = 1:1:nextCount(name) {
			set nn1 = nextNode(name, j)
			for k = 1:1:nextCount(nn1) {
				set nn2 = nextNode(nn1, k)
				if nn2 = "rx" {
					set predRxCount = predRxCount + 1
					set predRxName(predRxCount) = name
					set predRxIter(predRxCount) = 0
				}
			}
		}
	}

	set l = 0
	set h = 0
	for i = 1:1:1000000 {
		set qSize = 1
		set q(1, "id") = "broadcaster"
		set q(1, "input") = 0
		set q(1, "from") = ""
		set l = l + 1 // button press low signal
		while qSize {
			set qNextSize = 0

			for j = 1:1:qSize {
				set id = q(j, "id")
				set input = q(j, "input")
				set from = q(j, "from")
				
				if nodeType(id) = "button" {
					for k = 1:1:nextCount(id) {
						set qNextSize = qNextSize + 1
						set qNext(qNextSize, "id") = nextNode(id, k)
						set qNext(qNextSize, "input") = 0
						set qNext(qNextSize, "from") = id
						set l = l + 1
					}
				}
				if nodeType(id) = "%" {
					if input = 0 {
						set nodeState(id) = 1 - nodeState(id)
						for k = 1:1:nextCount(id) {
							set qNextSize = qNextSize + 1
							set qNext(qNextSize, "id") = nextNode(id, k)
							set qNext(qNextSize, "input") = nodeState(id)
							set qNext(qNextSize, "from") = id
							if nodeState(id) {
								set h = h + 1
							} else {
								set l = l + 1
							}
						}
					}
				}
				if nodeType(id) = "&" {
					if input '= predSignal(from, id) {
						if (input) {
							set nodeState(id) = nodeState(id) + 1
						} else {
							set nodeState(id) = nodeState(id) - 1
						}
						set predSignal(from, id) = input
					}
					if predCount(id) = nodeState(id) {
						set output = 0
					} else {
						set output = 1
					}
					if output = 1 {
						for k = 1:1:predRxCount {
							if (id = predRxName(k)) && (predRxIter(k) = 0) {
								set predRxIter(k) = i
								set predRxDone = predRxDone + 1
							}
						}
					}
					for k = 1:1:nextCount(id) {
						set qNextSize = qNextSize + 1
						set qNext(qNextSize, "id") = nextNode(id, k)
						set qNext(qNextSize, "input") = output
						set qNext(qNextSize, "from") = id
						if output {
							set h = h + 1
						} else {
							set l = l + 1
						}
					}
				}
			}

			set qSize = qNextSize
			for j = 1:1:qNextSize {
				set q(j, "id") = qNext(j, "id")
				set q(j, "input") = qNext(j, "input")
				set q(j, "from") = qNext(j, "from")
			}
		}
		if predRxDone = predRxCount {
			QUIT
		}
	}
	set result = 1
	for i = 1:1:predRxCount {
		set result = ..lcm(result, predRxIter(i))
	}
	return result
}

}
