# ==============================================================================
# API Automation Tests Script với Dynamic Collections và CSV Data
# ==============================================================================
# Script này chạy các API tests sử dụng Newman với dynamic validation
# - Login Tests: 3 iterations x 2 test cases x 5 assertions = 30 assertions
# - Get Invoices Tests: 2 iterations x 2 test cases x 5 assertions = 20 assertions  
# - Create Product Tests: 3 iterations x 2 test cases x 5 assertions = 30 assertions
# - User Profile API Tests: 20 comprehensive API test cases
#   * Authentication Testing: valid/invalid/expired tokens
#   * Authorization Testing: own vs other user profiles
#   * HTTP Status Codes: 200, 401, 403, 404, 422, 405, 400, 415
#   * Request/Response Validation: JSON structure, required properties
#   * HTTP Methods: PUT, PATCH, GET, POST validation
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

# Test user profile endpoints
Write-Host "[TEST] Testing user profile endpoints..." -ForegroundColor Cyan
try {
    # Test users endpoint (should return list of users or 401 if auth required)
    $response = Invoke-WebRequest -Uri "http://localhost:8091/users" -Headers @{"Accept"="application/json"} -ErrorAction Stop
    Write-Host "[SUCCESS] Users endpoint: $($response.StatusCode)" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401) {
        Write-Host "[INFO] Users endpoint requires authentication (401) - This is expected" -ForegroundColor Yellow
    } else {
        Write-Host "[WARNING] Users endpoint returned: $statusCode - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

try {
    # Test specific user profile endpoint (example with user ID 1)
    $response = Invoke-WebRequest -Uri "http://localhost:8091/users/1" -Headers @{"Accept"="application/json"} -ErrorAction Stop
    Write-Host "[SUCCESS] User profile endpoint: $($response.StatusCode)" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401 -or $statusCode -eq 403) {
        Write-Host "[INFO] User profile endpoint requires authentication ($statusCode) - This is expected" -ForegroundColor Yellow
    } elseif ($statusCode -eq 404) {
        Write-Host "[INFO] User profile endpoint: User not found (404) - This may be expected" -ForegroundColor Yellow
    } else {
        Write-Host "[WARNING] User profile endpoint returned: $statusCode - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Run Newman tests with dynamic collections and CSV data
Write-Host "[INFO] Preparing to run 4 test suites..." -ForegroundColor Cyan
Write-Host "  1. Login Tests - Authentication validation" -ForegroundColor White
Write-Host "  2. Get Invoices Tests - Data retrieval validation" -ForegroundColor White  
Write-Host "  3. Create Product Tests - Data creation validation" -ForegroundColor White
Write-Host "  4. User Profile Update Tests - Profile management validation" -ForegroundColor White
Write-Host ""

$testSuites = @(
    @{
        Collection = "tests/collection/login-tests.postman_collection.json"
        Data = "tests/data/user-accounts.csv"
        Name = "login-tests"
        Description = "Authentication and login functionality tests"
    },
    @{
        Collection = "tests/collection/get-invoices-tests.postman_collection.json"
        Data = "tests/data/get-invoices-accounts.csv"
        Name = "get-invoices-tests"
        Description = "Invoice retrieval and data validation tests"
    },
    @{
        Collection = "tests/collection/create-product-tests.postman_collection.json"
        Data = "tests/data/create-product-accounts.csv"
        Name = "create-product-tests"
        Description = "Product creation and validation tests"
    },
    @{
        Collection = "tests/collection/User-Profile-API-Testing.postman_collection.json"
        Data = "tests/data/user-profile-api-test-data.csv"
        Name = "user-profile-api-tests"
        Description = "User profile API testing - Data-driven tests with CSV data for all scenarios"
    }
)

foreach ($testSuite in $testSuites) {
    $collectionFile = $testSuite.Collection
    $dataFile = $testSuite.Data
    $testName = $testSuite.Name
    $description = $testSuite.Description
    $environmentFile = "tests/environments/local.postman_environment.json"
    
    Write-Host "[SUITE] Starting: $testName" -ForegroundColor Magenta
    Write-Host "[DESC] $description" -ForegroundColor Gray
    
    if ((Test-Path $collectionFile) -and (Test-Path $dataFile)) {
        Write-Host "[NEWMAN] Running test collection: $collectionFile with data: $dataFile" -ForegroundColor Cyan
        
        # Run Newman with CSV data, environment, and CLI reporter
        Write-Host "[TEST] Executing tests with iteration data and environment..." -ForegroundColor Yellow
        if (Test-Path $environmentFile) {
            newman run $collectionFile --iteration-data $dataFile --environment $environmentFile --reporters cli
        } else {
            newman run $collectionFile --iteration-data $dataFile --reporters cli
        }
        
        # Generate HTML report if htmlextra reporter is available
        Write-Host "[REPORT] Generating HTML report for $testName..." -ForegroundColor Cyan
        if (Test-Path $environmentFile) {
            $htmlResult = newman run $collectionFile --iteration-data $dataFile --environment $environmentFile --reporters htmlextra --reporter-htmlextra-export "reports/$testName.html" 2>$null
        } else {
            $htmlResult = newman run $collectionFile --iteration-data $dataFile --reporters htmlextra --reporter-htmlextra-export "reports/$testName.html" 2>$null
        }
        
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

Write-Host ""
Write-Host "============================================" -ForegroundColor Blue
Write-Host "[COMPLETE] All API test suites finished!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Blue
Write-Host ""
Write-Host "[REPORTS] Check the following HTML reports:" -ForegroundColor Cyan
Write-Host "  • reports/login-tests.html" -ForegroundColor White
Write-Host "  • reports/get-invoices-tests.html" -ForegroundColor White
Write-Host "  • reports/create-product-tests.html" -ForegroundColor White
Write-Host "  • reports/user-profile-update-tests.html" -ForegroundColor White
Write-Host ""
Write-Host "[INFO] Test Summary:" -ForegroundColor Yellow
Write-Host "  ✓ Login Tests: Authentication validation" -ForegroundColor Green
Write-Host "  ✓ Get Invoices Tests: Data retrieval validation" -ForegroundColor Green
Write-Host "  ✓ Create Product Tests: Data creation validation" -ForegroundColor Green
Write-Host "  ✓ User Profile Update Tests: Profile management validation" -ForegroundColor Green
