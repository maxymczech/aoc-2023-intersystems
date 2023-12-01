Class dc.aoc2023.Base Extends %RegisteredObject
{

Parameter Folder = "D:\work\_competitions\adventofcode\2023\aoc-2023-intersystems\data\";

ClassMethod GetInput(fn) As %Stream
{
    set fn=..#Folder_fn
    set stream = ##Class(%Stream.FileCharacter).%New()
    do stream.LinkToFile(fn)
    return stream
}

}
