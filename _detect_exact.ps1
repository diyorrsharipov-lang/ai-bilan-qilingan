Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap("images\Main.png")

# Find green logo: search for green pixels (G > 150, R < 150, B < 50) near bottom
Write-Output "Searching green logo near y=2100..2300:"
for ($y = 2150; $y -lt 2300; $y += 2) {
    for ($x = 20; $x -lt 250; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.G -gt 150 -and $c.R -lt 150 -and $c.B -lt 50) {
            Write-Output "Found green at x=$x, y=$y : ($($c.R),$($c.G),$($c.B))"
            break
        }
    }
}

# Also let's check card 1 bounds in Row 1:
# Let's find exactly where card 1 image starts and ends (x and y)
Write-Output "Scanning Card 1 image exact bounding box in Row 1:"
$minX = 9999; $maxX = 0; $minY = 9999; $maxY = 0
for ($y = 480; $y -lt 680; $y++) {
    for ($x = 40; $x -lt 360; $x++) {
        $c = $bmp.GetPixel($x, $y)
        # card image background is dark/green, not card white (255,255,255)
        if ($c.R -lt 240 -or $c.G -lt 240 -or $c.B -lt 240) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}
Write-Output "Card 1 img: x=$minX..$maxX (w=$($maxX-$minX+1)), y=$minY..$maxY (h=$($maxY-$minY+1))"

$bmp.Dispose()
