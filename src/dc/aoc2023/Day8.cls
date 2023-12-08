Class dc.aoc2023.Day8 Extends dc.aoc2023.Base
{

Parameter InputFile = "input8.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod ReadData(ByRef route, ByRef mapData, ByRef nodesCount, ByRef nodes)
{
    set stream=..GetInput(..#InputFile)
    set route = $zstrip(stream.ReadLine(), "*C")
    
    set nodesCount = 0
    set tmp = $zstrip(stream.ReadLine(), "*C")
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set node = $extract(line, 1, 3)
		set l = $extract(line, 8, 10)
		set r = $extract(line, 13, 15)
		set nodesCount = nodesCount + 1
		set nodes(nodesCount) = node
		set mapData(node, 1) = l
		set mapData(node, 2) = r
	}
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
    set result = 0
    do ..ReadData(.route, .mapData, .nodesCount, .nodes)
    set node = "AAA"
    while 1 {
	    for i = 1:1:$length(route) {
		    set next = $extract(route, i)
		    if next = "L" {
			    set node = mapData(node, 1)
		    }
		    if next = "R" {
			    set node = mapData(node, 2)
		    }
		    set result = result + 1
		    if node = "ZZZ" {
			    return result
		    }
	    }
    }
}

ClassMethod Part2(verbose = 0) As %Integer
{
    do ..ReadData(.route, .mapData, .nodesCount, .nodes)
    
    set aNodesCount = 0
    for i = 1:1:nodesCount {
	    if $extract(nodes(i), 3) = "A" {
		    set aNodesCount = aNodesCount + 1
		    set aNodes(aNodesCount) = nodes(i)
	    }
    }
    
    for j = 1:1:aNodesCount {
	    set node = aNodes(j)
	    set done = 0
	    set runtime = 0
	    while 'done {
	    	for i = 1:1:$length(route) {
		    	set next = $extract(route, i)
		    	if next = "L" {
				    set node = mapData(node, 1)
			    }
			    if next = "R" {
				    set node = mapData(node, 2)
		    	}
		    	set runtime = runtime + 1
			    if $extract(node, 3) = "Z" {
				    set runtimes(j) = runtime
				    set done = 1
				    QUIT
			    }
	    	}
    	}
    }
    
    set result = runtimes(1)
    for i = 2:1:aNodesCount {
	    set result = ..lcm(result, runtimes(i))
    }
    
    return result
}

}
