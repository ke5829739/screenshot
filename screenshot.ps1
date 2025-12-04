# Load screenshot libs
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$savePath = "screenshots"
if (!(Test-Path $savePath)) { New-Item -ItemType Directory -Path $savePath | Out-Null }

while ($true) {
    $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bmp = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $bmp.Size)

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $bmp.Save("$savePath\screenshot_$timestamp.png")

    $graphics.Dispose()
    $bmp.Dispose()

    Start-Sleep -Seconds 1
}
