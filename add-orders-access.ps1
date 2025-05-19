# PowerShell script to add orders-access.js to all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -Recurse -File | Where-Object { $_.FullName -notlike "*\admin\*" }

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if file already contains orders-access.js
    if ($content -notmatch "orders-access\.js") {
        # Look for </body> tag
        if ($content -match "</body>") {
            # Add the script before the closing body tag
            $newContent = $content -replace "</body>", "<script src=`"js/orders-access.js`"></script>`n</body>"
            Set-Content -Path $file.FullName -Value $newContent
            Write-Host "Added orders-access.js to $($file.Name)"
        }
        else {
            Write-Host "Could not find </body> tag in $($file.Name)"
        }
    }
    else {
        Write-Host "orders-access.js already exists in $($file.Name)"
    }
}

Write-Host "Script completed. Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
