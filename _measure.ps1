Add-Type -AssemblyName System.Drawing
$main = [System.Drawing.Image]::FromFile("images\Main.png")
$prev = [System.Drawing.Image]::FromFile("images\_main_preview.jpg")
Write-Output "Main: $($main.Width) x $($main.Height)"
Write-Output "Preview: $($prev.Width) x $($prev.Height)"
$ratioX = $main.Width / $prev.Width
$ratioY = $main.Height / $prev.Height
Write-Output "Ratio: $ratioX , $ratioY"
$main.Dispose()
$prev.Dispose()
