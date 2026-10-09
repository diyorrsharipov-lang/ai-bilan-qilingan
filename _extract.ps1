Add-Type -AssemblyName System.Drawing

$srcPath = "images\Main.png"
$src = [System.Drawing.Image]::FromFile($srcPath)

function CropImage($name, $x, $y, $w, $h) {
    $rect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.PixelOffsetMode = 'HighQuality'
    $g.SmoothingMode = 'HighQuality'
    $g.DrawImage($src, (New-Object System.Drawing.Rectangle 0, 0, $w, $h), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $dstPath = "images\$name"
    $bmp.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Cropped $name ($w x $h)"
}

# Hero device graphic
CropImage "hero-devices.png" 500 65 760 300

# Row 1 - Gaming
CropImage "gaming-1.png" 50 488 290 178
CropImage "gaming-2.png" 380 488 290 178
CropImage "gaming-3.png" 710 488 290 178
CropImage "gaming-4.png" 1040 488 290 178

# Row 2 - Systems
CropImage "systems-1.png" 50 964 290 178
CropImage "systems-2.png" 380 964 290 178
CropImage "systems-3.png" 710 964 290 178
CropImage "systems-4.png" 1040 964 290 178

# Row 3 - Networking
CropImage "network-1.png" 50 1432 290 178
CropImage "network-2.png" 380 1432 290 178
CropImage "network-3.png" 710 1432 290 178
CropImage "network-4.png" 1040 1432 290 178

# Deep Learning Institute image
CropImage "dli-photo.png" 50 1765 720 330

# Nvidia logo in footer
CropImage "nvidia-logo.png" 60 2225 150 40

$src.Dispose()
Write-Output "Done extracting assets!"
