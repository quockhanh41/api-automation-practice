# Test script để kiểm tra logic workflow
Write-Host "🧪 Testing workflow file detection logic..."

# Test suite 1: Login tests
if (Test-Path "tests/api/login-tests.postman_collection.json" -and Test-Path "tests/api/data/user-accounts.csv") {
    Write-Host "✅ Login test files found!"
} else {
    Write-Host "❌ Login test files not found"
}

# Test suite 2: Get invoices tests
if (Test-Path "tests/api/get-invoices-tests.postman_collection.json" -and Test-Path "tests/api/data/get-invoices-accounts.csv") {
    Write-Host "✅ Get invoices test files found!"
} else {
    Write-Host "❌ Get invoices test files not found"
}

# Test suite 3: Create product tests
if (Test-Path "tests/api/create-product-tests.postman_collection.json" -and Test-Path "tests/api/data/create-product-accounts.csv") {
    Write-Host "✅ Create product test files found!"
} else {
    Write-Host "❌ Create product test files not found"
}

# Test suite 4: User profile tests
if (Test-Path "tests/api/User-Profile-API-Testing.postman_collection.json" -and Test-Path "tests/api/data/user-profile-api-test-data.csv") {
    Write-Host "✅ User profile test files found!"
} else {
    Write-Host "❌ User profile test files not found"
}

# Test environment file
if (Test-Path "tests/api/environment.json") {
    Write-Host "✅ Environment file found!"
} else {
    Write-Host "❌ Environment file not found"
}

Write-Host "`n📋 File listing:"
Write-Host "Collections:"
Get-ChildItem "tests/api/*.json" | Select-Object Name

Write-Host "`nCSV Data files:"
Get-ChildItem "tests/api/data/*.csv" | Select-Object Name
