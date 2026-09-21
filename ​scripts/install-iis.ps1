# Install IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Create CloudLab web page
Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CloudLab - Azure</title>
</head>
<body>
    <h1>CloudLab</h1>
    <h2>Secure Web Application</h2>
    <p>Running on Microsoft Azure</p>
    <p>Windows Server 2025 + IIS</p>
    <p>Environment: Lab</p>
</body>
</html>
"@
