param(
    [Parameter(Mandatory=$true)]
    [string]$KeyFile,
    
    [Parameter(Mandatory=$true)]
    [string]$Ec2Connection,
    
    [string]$LocalPath = "."
)

if (-not (Test-Path $KeyFile)) {
    Write-Host "Error: Key file '$KeyFile' not found" -ForegroundColor Red
    exit 1
}

$RemotePath = "~/expense-prediction"

Write-Host "Transferring files to EC2 (excluding venv)..." -ForegroundColor Green

ssh -i $KeyFile "$Ec2Connection" "mkdir -p $RemotePath"

$destination = "$Ec2Connection" + ":" + $RemotePath + "/"

$files = @("app.py", "model.pkl", "requirements.txt")
foreach ($file in $files) {
    if (Test-Path "$LocalPath\$file") {
        scp -i $KeyFile "$LocalPath\$file" "$destination"
    }
}

if (Test-Path "$LocalPath\templates") {
    scp -i $KeyFile -r "$LocalPath\templates" "$destination"
}

if (Test-Path "$LocalPath\static") {
    scp -i $KeyFile -r "$LocalPath\static" "$destination"
}

Write-Host "Deployment complete!" -ForegroundColor Green

