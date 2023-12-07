Class dc.aoc2023.Day7 Extends dc.aoc2023.Base
{

Parameter InputFile = "input7.txt";

ClassMethod Run()
{
	set part1 = ..Part1()
	set part2 = ..Part2()

    write part1,!
    write part2,!
}

ClassMethod GetCardRank(card, jValue) As %Integer
{
	if card = "2" { return 2 }
	if card = "3" { return 3 }
	if card = "4" { return 4 }
	if card = "5" { return 5 }
	if card = "6" { return 6 }
	if card = "7" { return 7 }
	if card = "8" { return 8 }
	if card = "9" { return 9 }
	if card = "T" { return 10 }
	if card = "J" { return jValue }
	if card = "Q" { return 12 }
	if card = "K" { return 13 }
	if card = "A" { return 14 }
}

ClassMethod Strength(cards, jokers) As %Integer
{
	set uniqueCount = 0
	set allCards = "23456789TJQKA"
	for i = 1:1:5 {
		set isUnique = 1
		for j = 1:1:uniqueCount {
			if unique(j) = $extract(cards, i) {
				set isUnique = 0
			}
		}
		if isUnique {
			set uniqueCount = uniqueCount + 1
			set unique(uniqueCount) = $extract(cards, i)
		}
	}
	for i = 1:1:uniqueCount {
		set counts(i) = 0
	}
	for i = 1:1:5 {
		for j = 1:1:uniqueCount {
			if unique(j) = $extract(cards, i) {
				set counts(j) = counts(j) + 1
			}
		}
	}
	
	// Bubble sort :)
	for i = 1:1:uniqueCount {
		for j = 1:1:(uniqueCount - i) {
			set cmp = counts(j) - counts(j + 1)
			if cmp > 0 {
				set t = unique(j)
				set unique(j) = unique(j + 1)
				set unique(j + 1) = t
				set t = counts(j)
				set counts(j) = counts(j + 1)
				set counts(j + 1) = t
			}
		}
	}

	if (jokers) {
		for i = 1:1:uniqueCount {
			if unique(i) = "J" {
				if counts(i) = 5 {
				} else {
					if counts(i) = 4 {
						set uniqueCount = 1
						set counts(1) = 5
					} else {
						if i = uniqueCount {
							set counts(i - 1) = counts(i - 1) + counts(i)
						} else {
							set counts(uniqueCount) = counts(uniqueCount) + counts(i)
							for j = (i + 1):1:uniqueCount {
								set counts(j - 1) = counts(j)
							}
						}
						set uniqueCount = uniqueCount - 1
					}
				}
				QUIT
			}
		}
	}

	if (uniqueCount = 1) {
		return 7
	}
	if (uniqueCount = 2) && (counts(1) = 1) && (counts(2) = 4) {
		return 6
	}
	if (uniqueCount = 2) && (counts(1) = 2) && (counts(2) = 3) {
		return 5
	}
	if (uniqueCount = 3) && (counts(1) = 1) && (counts(2) = 1) && (counts(3) = 3) {
		return 4
	}
	if (uniqueCount = 3) && (counts(1) = 1) && (counts(2) = 2) && (counts(3) = 2) {
		return 3
	}
	if (uniqueCount = 4) && (counts(1) = 1) && (counts(2) = 1) && (counts(3) = 1) && (counts(4) = 2) {
		return 2
	}
	return 1
}

ClassMethod Part1(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set lineCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set lineCount = lineCount + 1
		set cards(lineCount) = $piece(line, " ", 1)
		set bids(lineCount) = $piece(line, " ", 2)
		set str(lineCount) = ..Strength(cards(lineCount), 0)
    }
    
	// Bubble sort :)
	for i = 1:1:lineCount {
		for j = 1:1:(lineCount - i) {
			set cmp = str(j) - str(j + 1)
			if cmp = 0 {
				for k = 1:1:5 {
					set a = $extract(cards(j), k)
					set b = $extract(cards(j + 1), k)
					set cmp = (..GetCardRank(a, 11)) - (..GetCardRank(b, 11))
					if cmp '= 0 {
						QUIT
					}
				}
			}
			if cmp > 0 {
				set t = cards(j)
				set cards(j) = cards(j + 1)
				set cards(j + 1) = t
				set t = bids(j)
				set bids(j) = bids(j + 1)
				set bids(j + 1) = t
				set t = str(j)
				set str(j) = str(j + 1)
				set str(j + 1) = t
			}
		}
	}
	
	for i = 1:1:lineCount {
		set result = result + (bids(i) * i)
	}

    return result
}

ClassMethod Part2(verbose = 0) As %Integer
{
    set stream = ..GetInput(..#InputFile)
    set result = 0
    set lineCount = 0
	while 'stream.AtEnd {
		set line = $zstrip(stream.ReadLine(), "*C")
		set lineCount = lineCount + 1
		set cards(lineCount) = $piece(line, " ", 1)
		set bids(lineCount) = $piece(line, " ", 2)
		set str(lineCount) = ..Strength(cards(lineCount), 1)
    }

	// Bubble sort :)
	for i = 1:1:lineCount {
		for j = 1:1:(lineCount - i) {
			set cmp = str(j) - str(j + 1)
			if cmp = 0 {
				for k = 1:1:5 {
					set a = $extract(cards(j), k)
					set b = $extract(cards(j + 1), k)
					set cmp = (..GetCardRank(a, 1)) - (..GetCardRank(b, 1))
					if cmp '= 0 {
						QUIT
					}
				}
			}
			if cmp > 0 {
				set t = cards(j)
				set cards(j) = cards(j + 1)
				set cards(j + 1) = t
				set t = bids(j)
				set bids(j) = bids(j + 1)
				set bids(j + 1) = t
				set t = str(j)
				set str(j) = str(j + 1)
				set str(j + 1) = t
			}
		}
	}
	
	for i = 1:1:lineCount {
		set result = result + (bids(i) * i)
	}

    return result
}

}
