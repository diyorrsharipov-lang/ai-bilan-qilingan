Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap("images\Main.png")
$W = $bmp.Width
$H = $bmp.Height

# Find hero height: check rows where average brightness turns white (>200)
for ($y = 350; $y -lt 450; $y++) {
    $c = $bmp.GetPixel(680, $y)
    if ($c.R -gt 200 -and $c.G -gt 200 -and $c.B -gt 200) {
        Write-Output "Hero ends around y=$y"
        break
    }
}

# Let's inspect the cards in row 1 (Gaming):
# In _grid.jpg, cards are around y=400..700 in preview, which is y=480..850 in Main.png
# Let's scan along y=550 to find the 4 card image left/right bounds
$inCard = $false
$cardStart = 0
Write-Output "--- Scanning Row 1 (y=550) ---"
for ($x = 0; $x -lt $W; $x++) {
    $c = $bmp.GetPixel($x, 550)
    # Cards have images with darker or colored pixels, background between cards is white (255,255,255)
    $isWhite = ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240)
    if (-not $isWhite -and -not $inCard) {
        $inCard = $true
        $cardStart = $x
    } elseif ($isWhite -and $inCard) {
        $inCard = $false
        Write-Output "Card Image X: $cardStart to $($x-1) (width: $($x - $cardStart))"
    }
}

# Let's find top and bottom of card images in column of Card 1 (say x=150)
$inImg = $false
$imgStart = 0
for ($y = 400; $y -lt 700; $y++) {
    $c = $bmp.GetPixel(150, $y)
    $isWhite = ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240)
    if (-not $isWhite -and -not $inImg) {
        $inImg = $true
        $imgStart = $y
    } elseif ($isWhite -and $inImg) {
        $inImg = $false
        Write-Output "Card 1 Image Y: $imgStart to $($y-1) (height: $($y - $imgStart))"
    }
}

$bmp.Dispose()
