# BÁO CÁO THIẾT KẾ TEST CASE CHO API TESTING

## 1. TỔNG QUAN DỰ ÁN

### 1.1 Mô tả hệ thống
Hệ thống là một ứng dụng e-commerce với các chức năng chính:
- Quản lý sản phẩm (Products)
- Quản lý hóa đơn (Invoices) 
- Xác thực người dùng (User Authentication)

### 1.2 Công nghệ sử dụng
- **Backend**: Laravel PHP Framework
- **Frontend**: Angular
- **Database**: MySQL
- **Authentication**: JWT (JSON Web Token)
- **Testing**: Postman Collections

## 2. PHÂN TÍCH API DESIGN

### 2.1 API POST /products

#### 2.1.1 Mô tả API
- **Endpoint**: `POST /products`
- **Chức năng**: Tạo sản phẩm mới
- **Authentication**: Yêu cầu quyền admin
- **Response**: HTTP 201 (Created) khi thành công

#### 2.1.2 Cấu trúc Request Body
```json
{
  "name": "string (required, max:120)",
  "description": "string (optional, max:1250)", 
  "price": "numeric (required)",
  "category_id": "string (required)",
  "brand_id": "string (required)",
  "product_image_id": "string (required)",
  "is_location_offer": "boolean (required)",
  "is_rental": "boolean (required)"
}
```

#### 2.1.3 Validation Rules
- `name`: Bắt buộc, string, tối đa 120 ký tự, không chứa subscript/superscript
- `description`: Tùy chọn, string, tối đa 1250 ký tự
- `price`: Bắt buộc, numeric
- `category_id`: Bắt buộc, phải tồn tại trong bảng categories
- `brand_id`: Bắt buộc, phải tồn tại trong bảng brands
- `product_image_id`: Bắt buộc, string
- `is_location_offer`: Bắt buộc, boolean
- `is_rental`: Bắt buộc, boolean

### 2.2 API GET /invoices

#### 2.2.1 Mô tả API
- **Endpoint**: `GET /invoices`
- **Chức năng**: Lấy danh sách hóa đơn
- **Authentication**: Yêu cầu JWT token
- **Authorization**: 
  - Admin: Xem tất cả hóa đơn
  - User: Chỉ xem hóa đơn của mình
- **Response**: HTTP 200 (OK) khi thành công

#### 2.2.2 Query Parameters
- `page`: Số trang (optional)

#### 2.2.3 Response Structure
```json
{
  "current_page": "integer",
  "data": "array of InvoiceResponse",
  "from": "integer", 
  "last_page": "integer",
  "per_page": "integer",
  "to": "integer",
  "total": "integer"
}
```

### 2.3 API POST /users/login

#### 2.3.1 Mô tả API
- **Endpoint**: `POST /users/login`
- **Chức năng**: Đăng nhập người dùng
- **Authentication**: Không yêu cầu (public endpoint)
- **Response**: HTTP 200 (OK) khi thành công

#### 2.3.2 Cấu trúc Request Body
```json
{
  "email": "string (required)",
  "password": "string (required)",
  "access_token": "string (optional)",
  "totp": "string (optional)"
}
```

#### 2.3.3 Validation Rules
- `email`: Bắt buộc, phải tồn tại trong bảng users
- `password`: Bắt buộc, phải khớp với password trong database
- `access_token`: Tùy chọn, cho social login
- `totp`: Tùy chọn, cho 2FA

#### 2.3.4 Response Cases
- **Thành công**: Trả về JWT token
- **Tài khoản bị khóa**: HTTP 423 (Locked)
- **Tài khoản bị vô hiệu hóa**: HTTP 403 (Forbidden)
- **Thông tin đăng nhập sai**: HTTP 401 (Unauthorized)
- **Yêu cầu TOTP**: HTTP 200 với flag requires_totp

## 3. THIẾT KẾ TEST CASES

### 3.1 Test Cases cho POST /products

#### 3.1.1 Positive Test Cases
1. **TC_PRODUCT_001**: Tạo sản phẩm với đầy đủ thông tin hợp lệ
2. **TC_PRODUCT_002**: Tạo sản phẩm với description tùy chọn
3. **TC_PRODUCT_003**: Tạo sản phẩm với giá 0
4. **TC_PRODUCT_004**: Tạo sản phẩm với giá cao (999999.99)
5. **TC_PRODUCT_005**: Tạo sản phẩm với tên dài nhất (120 ký tự)

#### 3.1.2 Negative Test Cases
6. **TC_PRODUCT_006**: Thiếu trường name (validation error)
7. **TC_PRODUCT_007**: Thiếu trường price (validation error)
8. **TC_PRODUCT_008**: Category_id không tồn tại (validation error)
9. **TC_PRODUCT_009**: Brand_id không tồn tại (validation error)
10. **TC_PRODUCT_010**: Tên sản phẩm chứa ký tự đặc biệt (subscript/superscript)

### 3.2 Test Cases cho GET /invoices

#### 3.2.1 Positive Test Cases
1. **TC_INVOICE_001**: Lấy danh sách hóa đơn với token admin hợp lệ
2. **TC_INVOICE_002**: Lấy danh sách hóa đơn với token user hợp lệ
3. **TC_INVOICE_003**: Lấy danh sách hóa đơn với pagination (page=1)
4. **TC_INVOICE_004**: Lấy danh sách hóa đơn với pagination (page=2)
5. **TC_INVOICE_005**: Lấy danh sách hóa đơn khi không có hóa đơn nào

#### 3.2.2 Negative Test Cases
6. **TC_INVOICE_006**: Không có access token (401 Unauthorized)
7. **TC_INVOICE_007**: Access token không hợp lệ (401 Unauthorized)
8. **TC_INVOICE_008**: Access token đã hết hạn (401 Unauthorized)
9. **TC_INVOICE_009**: Access token sai format (401 Unauthorized)
10. **TC_INVOICE_010**: Sử dụng method POST thay vì GET (405 Method Not Allowed)

### 3.3 Test Cases cho POST /users/login

#### 3.3.1 Positive Test Cases
1. **TC_LOGIN_001**: Đăng nhập với email và password hợp lệ
2. **TC_LOGIN_002**: Đăng nhập với tài khoản admin
3. **TC_LOGIN_003**: Đăng nhập với tài khoản customer
4. **TC_LOGIN_004**: Đăng nhập với email có chữ hoa
5. **TC_LOGIN_005**: Đăng nhập với access_token hợp lệ

#### 3.3.2 Negative Test Cases
6. **TC_LOGIN_006**: Email không tồn tại (401 Unauthorized)
7. **TC_LOGIN_007**: Password sai (401 Unauthorized)
8. **TC_LOGIN_008**: Thiếu trường email (validation error)
9. **TC_LOGIN_009**: Thiếu trường password (validation error)
10. **TC_LOGIN_010**: Tài khoản bị khóa do đăng nhập sai nhiều lần (423 Locked)

## 4. CẬP NHẬT DATA FILES

### 4.1 Cập nhật create-product-accounts.csv
Thêm 10 test cases mới với format:
```
name,description,price,category_id,brand_id,product_image_id,is_location_offer,is_rental,expected_status
```

### 4.2 Cập nhật get-invoices-accounts.csv  
Thêm 10 test cases mới với format:
```
access_token,expected_status
```

### 4.3 Cập nhật user-accounts.csv
Thêm 10 test cases mới với format:
```
email,password,expected_status
```

## 5. KẾT LUẬN

### 5.1 Tổng kết
- Đã phân tích 3 API chính của hệ thống
- Thiết kế 30 test cases (10 cho mỗi API)
- Bao gồm cả positive và negative test cases
- Cập nhật data files theo format yêu cầu

### 5.2 Khuyến nghị
- Thực hiện test automation với Postman
- Sử dụng data-driven testing với CSV files
- Tích hợp với CI/CD pipeline
- Báo cáo kết quả test chi tiết 