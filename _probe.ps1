Add-Type -AssemblyName System.Drawing
$b = New-Object System.Drawing.Bitmap "images/Main.png"

function BBox($x0, $y0, $x1, $y1, $mode, $thr, $label) {
  $minX = 99999; $minY = 99999; $maxX = -1; $maxY = -1
  for ($y = $y0; $y -lt $y1; $y++) {
    for ($x = $x0; $x -lt $x1; $x++) {
      $c = $b.GetPixel($x, $y)
      $hit = $false
      switch ($mode) {
        "white" { $hit = ($c.R -gt $thr -and $c.G -gt $thr -and $c.B -gt $thr) }
        "dark" { $hit = ($c.R -lt $thr -and $c.G -lt $thr -and $c.B -lt $thr) }
        "green" { $hit = ($c.G -gt 90 -and $c.G -gt ($c.R + 25) -and $c.G -gt ($c.B + 25)) }
        "nonblack" { $hit = ([Math]::Max([Math]::Max($c.R, $c.G), $c.B) -gt $thr) }
        "notbg" { $hit = ([Math]::Abs($c.R - $thr) -gt 6 -or [Math]::Abs($c.G - $thr) -gt 6 -or [Math]::Abs($c.B - $thr) -gt 6) }
      }
      if ($hit) { if ($x -lt $minX) { $minX = $x }; if ($x -gt $maxX) { $maxX = $x }; if ($y -lt $minY) { $minY = $y }; if ($y -gt $maxY) { $maxY = $y } }
    }
  }
  Write-Output ("$label : x=$minX..$maxX (w=$($maxX-$minX+1)) y=$minY..$maxY (h=$($maxY-$minY+1))")
}

BBox 30 95 470 250 "white" 150 "hero heading"
BBox 300 30 700 80 "white" 150 "nav links"
BBox 30 30 260 80 "white" 150 "logo text"
BBox 995 15 1340 95 "white" 200 "search box"
BBox 440 85 1360 358 "nonblack" 25 "hero devices"
BBox 60 665 330 735 "dark" 120 "card1 title"
BBox 300 395 1100 470 "dark" 120 "heading1"
BBox 100 845 1300 905 "dark" 120 "heading2"
BBox 500 1285 900 1345 "dark" 120 "heading3"
BBox 790 1895 1300 1975 "dark" 120 "DLI subtitle"
BBox 60 750 330 792 "notbg" 255 "card1 shop row"
BBox 1100 2185 1315 2240 "notbg" 255 "footer country"
BBox 60 2185 320 2245 "notbg" 255 "footer logo"
# DLI card left edge at y=1740
$row = 1740
for ($x = 0; $x -lt 120; $x++) {
  $c = $b.GetPixel($x, $row)
  if ([Math]::Abs($c.R - 245) -gt 4 -or [Math]::Abs($c.G - 245) -gt 4) { Write-Output ("DLI card left edge x=$x rgb=$($c.R),$($c.G),$($c.B)"); break }
}
# footer card left edge at y=2100
for ($x = 0; $x -lt 120; $x++) {
  $c = $b.GetPixel($x, 2100)
  if ([Math]::Abs($c.R - 245) -gt 4) { Write-Output ("footer left edge x=$x rgb=$($c.R),$($c.G),$($c.B)"); break }
}
# dots row: find runs of nonblack in y368..374
Write-Output "dots:"
for ($x = 600; $x -lt 800; $x++) {
  $found = $false
  for ($y = 365; $y -lt 380; $y++) {
    $c = $b.GetPixel($x, $y)
    if ([Math]::Max([Math]::Max($c.R, $c.G), $c.B) -gt 30) {
      $found = $true
      if ($x % 10 -eq 0) { Write-Output ("  x=$x y=$y rgb=$($c.R),$($c.G),$($c.B)") }
      break
    }
  }
}
# exact dot colors at y=372
Write-Output "dot colors y=372:"
for ($x = 655; $x -lt 735; $x += 3) {
  $c = $b.GetPixel($x, 372)
  if ([Math]::Max([Math]::Max($c.R, $c.G), $c.B) -gt 25) { Write-Output ("  x=$x rgb=$($c.R),$($c.G),$($c.B)") }
}
# hero heading line extents separately
BBox 30 95 470 170 "white" 150 "hero line1"
BBox 30 170 470 250 "white" 150 "hero line2"
# DLI heading line1 / line2 green bboxes
BBox 790 1750 1300 1818 "green" 0 "DLI h line1"
BBox 790 1818 1300 1880 "green" 0 "DLI h line2"
$b.Dispose()
