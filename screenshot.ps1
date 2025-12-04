# --- Load screenshot dependencies ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Dropbox token
$token = "sl.u.AGLd9pjQPHQ_3-GL4If3CJKxsWhPptXGjT7v1o5F8jn7k1mA3o-_KMADaw6TnHh04LVhGhLZw5vVxiyXlBvoQID17DfOQ8wgeYJi8ZFWU21j2R_jfqeX2zad82o23jXRbEIGxOkvIz4LTEf9edn5UNIWfQ2iM9Ecdn4w7fEKOgv_er1klLMTmRU1pw13B5BHHViCmOYwKhDhlooNZ-TNcmNjZDc0VHJFMkgwxIlN4zCbMmsbWGiiLSyMA3bkOJ_NwSKE3xDEWDs8GU9cZfc4UPYOJ53x7-9pxbMWnf6BW6TwNdMF62RPGlNRM46NTaNCsKuPq44tO_VmGu3Rr5VUpgKdFTXH7LdjX_kvnCZf5aYhXHoHkEKTRAkiMWxoD41uMsfsquuwgRg308CXmq30F3eLjJrCPUu4WK5rqHbPvCQpouTiHg2N2a4INNQvbC_y6g-gOB_Qht3ui9K8MEer27RXlMz9Qu2oobroYB-CPxd1e476hKsdxqdmLEAp7s02_zmK4Jm5nFfH4F0XIqhZAQYHrd2GxTXZaL3pF527xQhG0UPzjpGIwegfvFhAXB4Vnvf-9oWIkTpwLzM8pgJUd39b0orJij4WE44DEt8e0L1LHiR_YjOPeCDk-kiV3tocmiZv2sK0cTLuCSjGg8YC3mt9q6yUD2Q9AsSZroHN0RTfDXorqE9HvbEEw5AgNg0Vf58wL3JnJImpnIabr91fgt4H_fn9oyqEDnBIusJKOUJzdIhrP6-a9ovkBLpkhh2nrXG5aMk0jJ4VjX89AXM5m-nfDCX0BeJfrkGR_DVkzhk6WJnhnrXBg5x9JUJvrg9IuSX8F3N5YhMlKNFYJxotNWl-M61jrD1N7jxTSMDYbtON76g1zvXvAtoRv8Q8GH7QZmVKar7lx9oxWIdnGaJArJ5UkQyWSgxftyx2Pqo7BkcufDRaOC8kgFupjHMAzCi6ZEcJ8JWUHfUGQIhn3I6z3-yPg4f6T1TxoGnPNWZsOrWsnvbcPUkm696dsEyY9R_xxEBlCKKu5GMrj6195k8brDTQ1h3MQvIm_QqsnBC6ihvjNqw0bYgKKLZnRIFN4-KKjdxHoKqEH2xI_lxivqwaupPrpHXpWshm50dGVZD7z_d2lMtxG0orapt4hYw2wfMraxbko0HYo_nLlDGwTkmVZJcRsPwQdC5b5ey5Y4P-J-IxXQH4nrmjzSMiUlu8GgYK3uRlpgS8tnB6Y7Ok4ZIaVclSNZIK9BpDBEVvtMhD815vND4BE1M1XiJPnJmjAksB_zMPjznz-A_Tz4kPKI3CClIX"   # ضع توكنك هنا

# Temporary folder
$tempFolder = "$env:TEMP\screenshots"
if (!(Test-Path $tempFolder)) { New-Item -ItemType Directory -Path $tempFolder | Out-Null }

Write-Host "Starting live screenshot upload to Dropbox..."
Write-Host "Press CTRL+C to stop."

while ($true) {
    # Take screenshot
    $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bmp = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $bmp.Size)

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $localFile = "$tempFolder\screenshot_$timestamp.png"
    $bmp.Save($localFile)

    $graphics.Dispose()
    $bmp.Dispose()

    # Upload to Dropbox
    $url = "https://content.dropboxapi.com/2/files/upload"
    $headers = @{
        "Authorization" = "Bearer $token"
        "Dropbox-API-Arg" = "{`"path`": `"/screenshots/screenshot_$timestamp.png`", `"mode`": `"add`", `"autorename`": true, `"mute`": false}"
        "Content-Type" = "application/octet-stream"
    }
    Invoke-RestMethod -Uri $url -Method Post -Headers $headers -InFile $localFile

    # Delete local file after upload
    Remove-Item $localFile -Force

    # Wait 1 second
    Start-Sleep -Seconds 1
}
