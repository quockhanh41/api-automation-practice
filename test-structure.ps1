# Test script để verify cấu trúc thư mục mới
Write-Host "🧪 Testing new folder structure..." -ForegroundColor Green

Write-Host ""
Write-Host "📁 Checking Collections folder:" -ForegroundColor Cyan
if (Test-Path "tests/collection") {
    Write-Host "✅ tests/collection exists" -ForegroundColor Green
    Write-Host "Collections found:"
    dir "tests/collection/*.json" | Select-Object Name
} else {
    Write-Host "❌ tests/collection not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "📁 Checking Data folder:" -ForegroundColor Cyan
if (Test-Path "tests/data") {
    Write-Host "✅ tests/data exists" -ForegroundColor Green
    Write-Host "CSV files found:"
    dir "tests/data/*.csv" | Select-Object Name
} else {
    Write-Host "❌ tests/data not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔍 Testing specific files:" -ForegroundColor Yellow

# Test each file individually
$files = @(
    "tests/collection/login-tests.postman_collection.json",
    "tests/collection/get-invoices-tests.postman_collection.json", 
    "tests/collection/create-product-tests.postman_collection.json",
    "tests/collection/User-Profile-API-Testing.postman_collection.json",
    "tests/data/user-accounts.csv",
    "tests/data/get-invoices-accounts.csv",
    "tests/data/create-product-accounts.csv",
    "tests/data/user-profile-api-test-data.csv",
    "tests/collection/environment.json"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "✅ $file" -ForegroundColor Green
    } else {
        Write-Host "❌ $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✅ Structure verification complete!" -ForegroundColor Green
