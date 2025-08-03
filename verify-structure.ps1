# Test script để verify cấu trúc thư mục mới
Write-Host "🧪 Testing new folder structure..." -ForegroundColor Green

Write-Host "`n📁 Checking Collections folder:" -ForegroundColor Cyan
if (Test-Path "tests/collection") {
    Write-Host "✅ tests/collection exists" -ForegroundColor Green
    Get-ChildItem "tests/collection/*.json" | ForEach-Object {
        Write-Host "  📄 $($_.Name)" -ForegroundColor White
    }
} else {
    Write-Host "❌ tests/collection not found" -ForegroundColor Red
}

Write-Host "`n📁 Checking Data folder:" -ForegroundColor Cyan
if (Test-Path "tests/data") {
    Write-Host "✅ tests/data exists" -ForegroundColor Green
    Get-ChildItem "tests/data/*.csv" | ForEach-Object {
        Write-Host "  📊 $($_.Name)" -ForegroundColor White
    }
} else {
    Write-Host "❌ tests/data not found" -ForegroundColor Red
}

Write-Host "`n🔍 Testing file detection logic:" -ForegroundColor Yellow

# Test each test suite
$testSuites = @(
    @{ Collection = "tests/collection/login-tests.postman_collection.json"; Data = "tests/data/user-accounts.csv"; Name = "Login Tests" },
    @{ Collection = "tests/collection/get-invoices-tests.postman_collection.json"; Data = "tests/data/get-invoices-accounts.csv"; Name = "Get Invoices Tests" },
    @{ Collection = "tests/collection/create-product-tests.postman_collection.json"; Data = "tests/data/create-product-accounts.csv"; Name = "Create Product Tests" },
    @{ Collection = "tests/collection/User-Profile-API-Testing.postman_collection.json"; Data = "tests/data/user-profile-api-test-data.csv"; Name = "User Profile Tests" }
)

foreach ($suite in $testSuites) {
    $collectionExists = Test-Path $suite.Collection
    $dataExists = Test-Path $suite.Data
    
    if ($collectionExists -and $dataExists) {
        Write-Host "✅ $($suite.Name): All files found" -ForegroundColor Green
    } else {
        Write-Host "❌ $($suite.Name): Missing files" -ForegroundColor Red
        if (-not $collectionExists) { Write-Host "  Missing: $($suite.Collection)" -ForegroundColor Yellow }
        if (-not $dataExists) { Write-Host "  Missing: $($suite.Data)" -ForegroundColor Yellow }
    }
}

Write-Host "`n🌍 Environment file:" -ForegroundColor Cyan
if (Test-Path "tests/collection/environment.json") {
    Write-Host "✅ Environment file found: tests/collection/environment.json" -ForegroundColor Green
} elseif (Test-Path "tests/environments/local.postman_environment.json") {
    Write-Host "⚠️ Found legacy environment file: tests/environments/local.postman_environment.json" -ForegroundColor Yellow
} else {
    Write-Host "❌ No environment file found" -ForegroundColor Red
}

Write-Host "`n✅ Structure verification complete!" -ForegroundColor Green
