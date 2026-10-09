Add-Type -AssemblyName System.Drawing
$src = "images\_main_preview.jpg"
$img = New-Object System.Drawing.Bitmap([System.Drawing.Image]::FromFile($src))
$g = [System.Drawing.Graphics]::FromImage($img)
$g.SmoothingMode = 'AntiAlias'
$penR = New-Object System.Drawing.Pen ([System.Drawing.Color]::Red), 1
$penC = New-Object System.Drawing.Pen ([System.Drawing.Color]::Cyan), 1
$font = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$yb = [System.Drawing.Brushes]::Yellow
$bk = [System.Drawing.Brushes]::Black
for ($y = 0; $y -lt $img.Height; $y += 50) {
  $g.DrawLine($penR, 0, $y, $img.Width, $y)
  if (($y % 100) -eq 0) {
    $g.DrawString("$y", $font, $bk, 3, $y + 2)
    $g.DrawString("$y", $font, $yb, 2, $y + 1)
    $g.DrawString("$y", $font, $bk, $img.Width - 62, $y + 2)
    $g.DrawString("$y", $font, $yb, $img.Width - 63, $y + 1)
  }
}
for ($x = 0; $x -lt $img.Width; $x += 50) {
  $g.DrawLine($penC, $x, 0, $x, $img.Height)
  if (($x % 100) -eq 0) {
    $g.DrawString("$x", $font, $bk, $x + 3, 3)
    $g.DrawString("$x", $font, $yb, $x + 2, 2)
    $g.DrawString("$x", $font, $bk, $x + 3, $img.Height - 22)
    $g.DrawString("$x", $font, $yb, $x + 2, $img.Height - 23)
  }
}
$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$enc = New-Object System.Drawing.Imaging.EncoderParameters(1)
$enc.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]85)
$img.Save("images\_grid.jpg", $codec, $enc)
$g.Dispose()
$img.Dispose()
Write-Output "grid saved"
