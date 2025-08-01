# ==============================================================================
# API Automation Tests Script với Dynamic Collections và CSV Data
# ==============================================================================
# Script này chạy các API tests sử dụng Newman với dynamic validation
# - Login Tests: 3 iterations x 2 test cases x 5 assertions = 30 assertions
# - Get Invoices Tests: 2 iterations x 2 test cases x 5 assertions = 20 assertions  
# - Create Product Tests: 3 iterations x 2 test cases x 5 assertions = 30 assertions
# ==============================================================================

Write-Host "[START] Starting API Dynamic Tests với CSV Data..." -ForegroundColor Green

# Start Docker services
# Write-Host "[DOCKER] Starting Docker containers..." -ForegroundColor Yellow
# docker compose -f docker-compose.yml up -d --force-recreate

# # Wait for services
# Write-Host "[WAIT] Waiting for services to be ready..." -ForegroundColor Yellow
# Start-Sleep -Seconds 30

# # Setup database
# Write-Host "[DATABASE] Setting up database..." -ForegroundColor Yellow
# docker compose exec laravel-api php artisan migrate --force
# docker compose exec laravel-api php artisan db:seed --force

# # Check if Newman is installed
# if (-not (Get-Command newman -ErrorAction SilentlyContinue)) {
#     Write-Host "[INSTALL] Installing Newman..." -ForegroundColor Cyan
#     npm install -g newman newman-reporter-htmlextra
# }

# # Run tests
# Write-Host "[TESTS] Running API tests..." -ForegroundColor Green

# Test basic endpoints first
Write-Host "[TEST] Testing API status endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8091/status" -Headers @{"Accept"="application/json"} -ErrorAction Stop
    Write-Host "[SUCCESS] Status endpoint: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Status endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test products endpoint
Write-Host "[TEST] Testing products endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8091/products" -Headers @{"Accept"="application/json"} -ErrorAction Stop
    Write-Host "[SUCCESS] Products endpoint: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Products endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Run Newman tests with dynamic collections and CSV data
$testSuites = @(
    @{
        Collection = "tests/api/login-tests.postman_collection.json"
        Data = "tests/api/user-accounts.csv"
        Name = "login-tests"
    },
    @{
        Collection = "tests/api/get-invoices-tests.postman_collection.json"
        Data = "tests/api/get-invoices-accounts.csv"
        Name = "get-invoices-tests"
    },
    @{
        Collection = "tests/api/create-product-tests.postman_collection.json"
        Data = "tests/api/create-product-accounts.csv"
        Name = "create-product-tests"
    }
)

foreach ($testSuite in $testSuites) {
    $collectionFile = $testSuite.Collection
    $dataFile = $testSuite.Data
    $testName = $testSuite.Name
    
    if ((Test-Path $collectionFile) -and (Test-Path $dataFile)) {
        Write-Host "[NEWMAN] Running test collection: $collectionFile with data: $dataFile" -ForegroundColor Cyan
        
        # Run Newman with CSV data and CLI reporter
        Write-Host "[TEST] Executing tests with iteration data..." -ForegroundColor Yellow
        newman run $collectionFile --iteration-data $dataFile --reporters cli
        
        # Generate HTML report if htmlextra reporter is available
        Write-Host "[REPORT] Generating HTML report for $testName..." -ForegroundColor Cyan
        $htmlResult = newman run $collectionFile --iteration-data $dataFile --reporters htmlextra --reporter-htmlextra-export "reports/$testName.html" 2>$null
        
        if (Test-Path "reports/$testName.html") {
            Write-Host "[SUCCESS] HTML report generated: reports/$testName.html" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] HTML report generation failed for $testName" -ForegroundColor Yellow
        }
        
        Write-Host "[INFO] Test suite '$testName' completed" -ForegroundColor Magenta
        Write-Host "----------------------------------------" -ForegroundColor Gray
    } else {
        if (-not (Test-Path $collectionFile)) {
            Write-Host "[SKIP] Collection file not found: $collectionFile" -ForegroundColor Yellow
        }
        if (-not (Test-Path $dataFile)) {
            Write-Host "[SKIP] Data file not found: $dataFile" -ForegroundColor Yellow
        }
    }
}
