//%attributes = {}
var $svg : cs:C1710.svg

// Create a new canvas
$svg:=cs:C1710.svg.new()

// Create a "background" group, its address is automatically memorized
// The object will automatically be added to the latest created "container" ("svg")
// The reference is automatically memorized into the store
$svg.group("background")

// Create a "foreground" group and apply a translation
// We must precise the "root" destination else the group will be included into the "background" one
$svg.group("foreground").translate(45; 45).attachTo("root")

// Create a yellow square & memorize its reference as "original"
// The object will automatically be added to the latest created "container" ("foreground" layer)
$svg.square(20).position(2.5; 2.5).color("yellow").push("original")

// Add, into the "background" layer, a blue circle without fill & with a border of 4 pixels
$svg.circle(50).color("blue").translate(100; 100).fill("none").stroke(4).attachTo("background")

// Clone the "original" square, colore it red, change its dimensions & puts it into the "background" layer
$svg.clone("original").color("red").position(10; 10).dimensions(100; 100).attachTo("background")


// Show the result into teh SVG viewer
// The memory is automatically freed
$svg.preview()