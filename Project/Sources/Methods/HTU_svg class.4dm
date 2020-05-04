//%attributes = {}
C_OBJECT:C1216($svg)

$svg:=cs:C1710.svg.new()


$svg.group("root").push("testGroup").attributes("id";"test")

$svg.square(20;"root").position(2.5;2.5).attributes("fill";"blue")


$svg.square(100;"testGroup").attributes("fill";"red").position(10;10)

$svg.show().close()
