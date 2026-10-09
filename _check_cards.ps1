Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap("images\Main.png")

# Let's inspect card boxes in all 3 rows:
# Card boxes typically have a white card background with a shadow.
# Let's find card outer dimensions:
# Look at y=750 (where card white body is below image, card 1 text area)
# Let's check where the card box boundaries are:
Write-Output "Checking row 1 cards x boundaries:"
for ($x = 30; $x -lt 1340; $x += 10) {
    # check pixel at y=700
    $c = $bmp.GetPixel($x, 700)
    # Write-Output "$x : ($($c.R),$($c.G),$($c.B))"
}

# Let's check card 1: image y range
# In row 1: image is around y=495 to y=667
# In row 2: around y=970 to y=1140? Let's check:
for ($y = 900; $y -lt 1200; $y += 10) {
    $c = $bmp.GetPixel(200, $y)
    # Write-Output "y=$y : ($($c.R),$($c.G),$($c.B))"
}

$bmp.Dispose()
