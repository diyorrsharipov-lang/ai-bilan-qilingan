param(
  [string]$src,
  [string]$dst,
  [int]$x,
  [int]$y,
  [int]$w,
  [int]$h,
  [int]$outW = 0
)
Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile($src)
$srcRect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
$dstW = $w
$dstH = $h
if ($outW -gt 0) { $dstW = $outW; $dstH = [int]($h * $outW / $w) }
$bmp = New-Object System.Drawing.Bitmap $dstW, $dstH
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = 'HighQualityBicubic'
$g.DrawImage($img, (New-Object System.Drawing.Rectangle 0, 0, $dstW, $dstH), $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
if ($dst -like "*.jpg") {
  $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
  $enc = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $enc.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]82)
  $bmp.Save($dst, $codec, $enc)
} else {
  $bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
}
$bmp.Dispose()
$img.Dispose()
Write-Output ("cropped " + $dst + " " + $dstW + "x" + $dstH)
