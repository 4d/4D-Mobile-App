//%attributes = {}
C_OBJECT:C1216($svg)

$svg:=cs:C1710.svg.new()


$svg.group("root").push("testGroup").setAttribute("id";"test")
$svg.square(20;"root").position(2.5;2.5).setAttributes("fill";"blue")
$svg.square(100;"testGroup").setAttributes("fill";"red").position(10;10)
$svg.show().close()
