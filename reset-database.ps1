# ==============================================================================
# Reset Database Script - Hoàn toàn reset database và khởi tạo lại
# ==============================================================================

Write-Host "[START] Bắt đầu reset database hoàn toàn..." -ForegroundColor Green

# Set environment variable nếu chưa có
if (-not $env:SPRINT_FOLDER) {
    $env:SPRINT_FOLDER = "sprint5-with-bugs"
    Write-Host "[ENV] Thiết lập SPRINT_FOLDER=$env:SPRINT_FOLDER" -ForegroundColor Yellow
}

# Stop và xóa tất cả containers và volumes
Write-Host "[CLEANUP] Dừng và xóa tất cả containers..." -ForegroundColor Yellow
docker compose -f docker-compose.yml down -v --remove-orphans

# Xóa images cũ (optional - uncomment nếu cần)
# Write-Host "[CLEANUP] Xóa images cũ..." -ForegroundColor Yellow
# docker compose -f docker-compose.yml down --rmi all

# Xóa volumes database cũ
Write-Host "[CLEANUP] Xóa volumes database cũ..." -ForegroundColor Yellow
docker volume prune -f

# Build và khởi động lại containers
Write-Host "[DOCKER] Build và khởi động containers..." -ForegroundColor Yellow
docker compose -f docker-compose.yml up -d --build --force-recreate

# Wait cho MariaDB khởi động hoàn toàn
Write-Host "[WAIT] Chờ MariaDB khởi động hoàn toàn..." -ForegroundColor Yellow
Start-Sleep -Seconds 45

# Kiểm tra MariaDB connection
Write-Host "[CHECK] Kiểm tra kết nối MariaDB..." -ForegroundColor Cyan
$maxRetries = 10
$retryCount = 0
do {
    $retryCount++
    Write-Host "[RETRY $retryCount/$maxRetries] Kiểm tra MariaDB..." -ForegroundColor Gray
    $dbCheck = docker compose exec mariadb mysqladmin ping -h localhost -u root -proot 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] MariaDB đã sẵn sàng!" -ForegroundColor Green
        break
    }
    Start-Sleep -Seconds 5
} while ($retryCount -lt $maxRetries)

if ($retryCount -eq $maxRetries) {
    Write-Host "[ERROR] MariaDB không thể khởi động sau $maxRetries lần thử!" -ForegroundColor Red
    exit 1
}

# Chạy composer install
Write-Host "[COMPOSER] Chạy composer install..." -ForegroundColor Yellow
docker compose run --rm composer

# Tạo database structure
Write-Host "[DATABASE] Chạy migration..." -ForegroundColor Yellow
docker compose exec laravel-api php artisan migrate:fresh --force

# Seed database với data
Write-Host "[DATABASE] Seed database với data..." -ForegroundColor Yellow
docker compose exec laravel-api php artisan db:seed --force

# Kiểm tra API endpoint
Write-Host "[TEST] Kiểm tra API endpoints..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8091/status" -Headers @{"Accept"="application/json"} -ErrorAction Stop
    Write-Host "[SUCCESS] API Status: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] API chưa sẵn sàng: $($_.Exception.Message)" -ForegroundColor Yellow
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8091/products" -Headers @{"Accept"="application/json"} -ErrorAction Stop
    Write-Host "[SUCCESS] Products endpoint: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Products endpoint chưa sẵn sàng: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ DATABASE RESET HOÀN TẤT!" -ForegroundColor Green
Write-Host "📊 Bạn có thể truy cập:" -ForegroundColor Cyan
Write-Host "   - API: http://localhost:8091" -ForegroundColor White
Write-Host "   - UI: http://localhost:4200" -ForegroundColor White  
Write-Host "   - phpMyAdmin: http://localhost:8000" -ForegroundColor White
Write-Host "   - MailCatcher: http://localhost:1080" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Thông tin database:" -ForegroundColor Cyan
Write-Host "   - Host: localhost:3306" -ForegroundColor White
Write-Host "   - Database: toolshop" -ForegroundColor White
Write-Host "   - Username: root" -ForegroundColor White
Write-Host "   - Password: root" -ForegroundColor White
Write-Host ""