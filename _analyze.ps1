Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap("images\Main.png")
$W = $bmp.Width; $H = $bmp.Height
Write-Output "SIZE $W x $H"

# --- row brightness profile (transitions only) ---
$prev = -1.0
for ($y = 0; $y -lt $H; $y += 4) {
  $sum = 0; $n = 0
  for ($x = 0; $x -lt $W; $x += 8) { $c = $bmp.GetPixel($x, $y); $sum += ($c.R + $c.G + $c.B); $n++ }
  $avg = $sum / (3.0 * $n)
  if ($prev -lt 0 -or [math]::Abs($avg - $prev) -gt 6) { Write-Output ("ROW {0} avg={1:N1}" -f $y, $avg) }
  $prev = $avg
}

# --- colour samples inside the hero band ---
Write-Output "HERO SAMPLES"
foreach ($y in 110, 150, 200, 250, 300, 340, 380) {
  $line = "y=$y : "
  foreach ($x in 5, 60, 200, 340, 430, 700, 1000, 1350) {
    $c = $bmp.GetPixel($x, $y)
    $line += "$x=($($c.R),$($c.G),$($c.B)) "
  }
  Write-Output $line
}

# --- column profiles for given y ranges ---
function ColProfile([int]$y0, [int]$y1, [string]$tag) {
  Write-Output "COLS $tag y=$y0..$y1"
  $script:prev = -1.0
  for ($x = 0; $x -lt $script:W; $x += 2) {
    $sum = 0; $n = 0
    for ($y = $y0; $y -lt $y1; $y += 6) { $c = $script:bmp.GetPixel($x, $y); $sum += ($c.R + $c.G + $c.B); $n++ }
    $avg = $sum / (3.0 * $n)
    if ($script:prev -lt 0 -or [math]::Abs($avg - $script:prev) -gt 6) { Write-Output ("  COL {0} avg={1:N1}" -f $x, $avg) }
    $script:prev = $avg
  }
}
$bmp2 = $bmp
$script:bmp = $bmp2
$script:W = $W
ColProfile 500 660 "BAND1-IMAGES"
ColProfile 1740 2050 "DLI-AREA"
$bmp.Dispose()
