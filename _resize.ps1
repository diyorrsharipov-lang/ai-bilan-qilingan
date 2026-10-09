Add-Type -AssemblyName System.Drawing
$src = $args[0]
$dst = $args[1]
$maxW = [int]$args[2]
$img = [System.Drawing.Image]::FromFile($src)
Write-Output ("original: " + $img.Width + "x" + $img.Height)
$scale = 1.0
if ($img.Width -gt $maxW) { $scale = $maxW / $img.Width }
$w = [int]($img.Width * $scale)
$h = [int]($img.Height * $scale)
$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = 'HighQualityBicubic'
$g.DrawImage($img, 0, 0, $w, $h)
$g.Dispose()
if ($dst -like "*.jpg") {
  $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
  $enc = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $enc.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]72)
  $bmp.Save($dst, $codec, $enc)
} else {
  $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
}
$bmp.Dispose()
$img.Dispose()
Write-Output ("saved: " + $w + "x" + $h)
