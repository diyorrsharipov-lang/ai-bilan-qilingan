Add-Type -AssemblyName System.Drawing
$b = New-Object System.Drawing.Bitmap "images/Main.png"

function Runs($y, $x0, $x1, $bg, $thr, $label) {
  Write-Output ("== y=$y bg=$bg $label")
  $inRun = $false; $start = 0
  for ($x = $x0; $x -lt $x1; $x++) {
    $c = $b.GetPixel($x, $y)
    $d = [Math]::Max([Math]::Max([Math]::Abs($c.R - $bg[0]), [Math]::Abs($c.G - $bg[1])), [Math]::Abs($c.B - $bg[2]))
    $fg = $d -gt $thr
    if ($fg -and -not $inRun) { $inRun = $true; $start = $x }
    if ((-not $fg) -and $inRun) { $inRun = $false; if ($x - $start -gt 2) { Write-Output ("  x=$start..$($x-1) w=$($x-$start)") } }
  }
  if ($inRun) { Write-Output ("  x=$start..$($x1-1) w=$($x1-$start)") }
}
function VRuns($x, $y0, $y1, $bg, $thr, $label) {
  Write-Output ("== x=$x bg=$bg $label")
  $inRun = $false; $start = 0
  for ($y = $y0; $y -lt $y1; $y++) {
    $c = $b.GetPixel($x, $y)
    $d = [Math]::Max([Math]::Max([Math]::Abs($c.R - $bg[0]), [Math]::Abs($c.G - $bg[1])), [Math]::Abs($c.B - $bg[2]))
    $fg = $d -gt $thr
    if ($fg -and -not $inRun) { $inRun = $true; $start = $y }
    if ((-not $fg) -and $inRun) { $inRun = $false; if ($y - $start -gt 2) { Write-Output ("  y=$start..$($y-1) h=$($y-$start)") } }
  }
  if ($inRun) { Write-Output ("  y=$start..$($y1-1) h=$($y1-$start)") }
}

# header: white-ish elements on black
Runs 40 0 1360 @(0,0,0) 40 "header white elements"
Runs 55 0 1360 @(0,0,0) 40 "header row2"
# hero heading lines
Runs 110 0 500 @(0,0,0) 40 "hero line1"
Runs 155 0 500 @(0,0,0) 40 "hero line2"
VRuns 60 60 385 @(0,0,0) 40 "hero text col x=60"
# buy now button (green)
Runs 330 0 500 @(0,0,0) 40 "buy now row"
VRuns 100 250 385 @(0,0,0) 40 "buy now col"
# carousel dots
Runs 365 400 900 @(0,0,0) 30 "dots row"
# heading1 extents (black text on #F5F5F5)
Runs 440 0 1360 @(245,245,245) 60 "heading1 Gaming"
VRuns 680 385 495 @(245,245,245) 60 "heading1 vertical"
Runs 875 0 1360 @(245,245,245) 60 "heading2"
VRuns 680 840 935 @(245,245,245) 60 "heading2 vertical"
Runs 1330 0 1360 @(245,245,245) 60 "heading3 Networking"
VRuns 680 1272 1392 @(245,245,245) 60 "heading3 vertical"
# card1 title / shop rows row1
Runs 690 50 340 @(255,255,255) 60 "card1 title line1"
Runs 770 50 340 @(255,255,255) 40 "card1 shop row"
VRuns 190 659 796 @(255,255,255) 60 "card1 text col"
# DLI: vertical at x=850 (heading/button column) on white card bg
VRuns 850 1733 2084 @(255,252,252) 40 "DLI col x=850"
Runs 1800 770 1330 @(255,252,252) 40 "DLI heading row"
Runs 1930 770 1330 @(255,252,252) 40 "DLI subtitle row"
Runs 2030 770 1330 @(255,252,252) 40 "DLI button row"
VRuns 900 1980 2084 @(255,252,252) 40 "DLI button vertical"
# DLI photo horizontal extent
Runs 1900 0 1360 @(255,252,252) 20 "DLI photo row"
VRuns 400 1733 2090 @(255,252,252) 20 "DLI photo vertical"
# footer content rows
Runs 2130 44 1320 @(255,255,255) 30 "footer y2130"
Runs 2210 44 1320 @(255,255,255) 30 "footer y2210"
VRuns 100 2091 2302 @(255,255,255) 30 "footer logo vertical"
Runs 2260 44 1320 @(255,255,255) 30 "footer y2260"
# search box vertical extent
VRuns 1200 0 120 @(0,0,0) 40 "search box vertical"
# nav vertical
VRuns 320 0 100 @(0,0,0) 40 "nav text vertical"
$b.Dispose()
