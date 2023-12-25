Class dc.aoc2023.Day25 Extends dc.aoc2023.Base
{

Parameter InputFile = "input25.set2.txt";

ClassMethod Run()
{
	set part1 = ..Part1()

    write part1,!
}

ClassMethod bfs(ByRef res, s, t, ByRef parent, ByRef visited, nodeCount) As %Integer
{
	for i = 1:1:nodeCount {
		set parent(i) = 0
		set visited(i) = 0
	}
	set visited(s) = 1
	set qSize = 1
	set q(1) = s
	set i = 1
	while i <= qSize {
		set v = q(i)
		set i = i + 1
		for j = 1:1:nodeCount {
			if (res(v, j) > 0) && 'visited(j) {
				set qSize = qSize + 1
				set q(qSize) = j
				set visited(j) = 1
				set parent(j) = v
			}
		}
	}
	return visited(t)
}

ClassMethod Part1(verbose = 0) As %Integer
{
	set result = 0
    set stream = ..GetInput(..#InputFile)
    set nodeCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set a = $piece(line, ": ", 1)
		set rest = $piece(line, ": ", 2)
		set isOk = 1
		for j = 1:1:nodeCount {
			if allNodes(j) = a {
				set isOk = 0
				set aIndex = j
			}
		}
		if isOk {
			set nodeCount = nodeCount + 1
			set allNodes(nodeCount) = a
			set nodeIndex(a) = nodeCount
		}
		for i = 1:1:1000 {
			set b = $piece(rest, " ", i)
			if b = "" {
				QUIT
			} else {
				set isOk = 1
				for j = 1:1:nodeCount {
					if allNodes(j) = b {
						set isOk = 0
					}
				}
				if isOk {
					set nodeCount = nodeCount + 1
					set allNodes(nodeCount) = b
					set nodeIndex(b) = nodeCount
				}
				set conn(nodeIndex(a), nodeIndex(b)) = 1
				set conn(nodeIndex(b), nodeIndex(a)) = 1
			}
		}
    }

    set s = 1
    while 1 {
	    // This works better than sequential t=2:1:nodeCount
	    // Assume two subgraphs after cut are approx. same size
	    // Then probability to place source and target correctly is P = 0.5
    	set t = $random(nodeCount - 2) + 2
    	
    	for i = 1:1:nodeCount {
	    	set del(i) = 0
		    for j = 1:1:nodeCount {
			    if $get(conn(i, j), 0) {
				    set W(i, j) = 1
				    set res(i, j) = 1
			    } else {
				    set W(i, j) = 0
				    set res(i, j) = 0
			    }
		    }
	    }

	    while ..bfs(.res, s, t, .parent, .visited, nodeCount) {
		    set pFlow = 999999999
		    set v = t
		    while v '= s {
			    set u = parent(v)
			    if res(u, v) < pFlow {
				    set pFlow = res(u, v)
			    }
			    set v = parent(v)
		    }
		    
		    set v = t
		    while v '= s {
			    set u = parent(v)
	            set res(u, v) = res(u, v) - pFlow
	            set res(v, u) = res(v, u) + pFlow
			    set v = parent(v)
		    }
	    }
	    
	    do ..bfs(.res, s, t, .parent, .visited, nodeCount)
	    set cutSize = 0
	    for i = 1:1:nodeCount {
		    for j = 1:1:nodeCount {
			    if (W(i, j) > 0) && visited(i) && 'visited(j) {
				    set cutSize = cutSize + 1
			    }
		    }
	    }

		set result = 0
	    if cutSize = 3 {
		    set a = 0
		    for i = 1:1:nodeCount {
			    if visited(i) {
				    set a = a + 1
			    }
		    }
		    set b = nodeCount - a
		    set result = a * b
		    QUIT
	    }
    }

    return result
}

}
