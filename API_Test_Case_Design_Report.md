# BÁO CÁO THIẾT KẾ TEST CASE CHO API TESTING

## PHIÊN BẢN CẬP NHẬT - API USER PROFILE

**Ngày cập nhật**: 3 Tháng 8, 2025  
**Nội dung cập nhật**: Thêm phân tích và thiết kế test case cho API PUT /users/{userId} (User Profile Update)

### Tóm tắt cập nhật:
- **API mới phân tích**: PUT /users/{userId} - Cập nhật thông tin người dùng
- **Số test cases bổ sung**: 25 test cases (5 positive + 20 negative)
- **Data file mới**: user-profile-api-test-data.csv với 20 test cases
- **Tổng số API đã phân tích**: 4 APIs
- **Tổng số test cases**: 55 test cases

---

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

### 2.4 API PUT /users/{userId}

#### 2.4.1 Mô tả API
- **Endpoint**: `PUT /users/{userId}`
- **Chức năng**: Cập nhật thông tin người dùng (User Profile)
- **Authentication**: Yêu cầu JWT token
- **Authorization**: 
  - User: Chỉ có thể cập nhật thông tin của chính mình
  - Admin: Có thể cập nhật thông tin của bất kỳ user nào
- **Response**: HTTP 200 (OK) khi thành công

#### 2.4.2 Cấu trúc Request Body
```json
{
  "first_name": "string (required, max:40)",
  "last_name": "string (required, max:20)",
  "address": "string (required, max:70)",
  "city": "string (required, max:40)",
  "state": "string (optional, max:40)",
  "country": "string (required, max:40)",
  "postcode": "string (optional, max:10)",
  "phone": "string (optional, max:24)",
  "email": "string (required, max:60)",
  "dob": "string (optional, date format)",
  "role": "string (optional, enum: user|admin)"
}
```

#### 2.4.3 Validation Rules
- `first_name`: Bắt buộc, string, tối đa 40 ký tự
- `last_name`: Bắt buộc, string, tối đa 20 ký tự
- `address`: Bắt buộc, string, tối đa 70 ký tự
- `city`: Bắt buộc, string, tối đa 40 ký tự
- `state`: Tùy chọn, string, tối đa 40 ký tự
- `country`: Bắt buộc, string, tối đa 40 ký tự
- `postcode`: Tùy chọn, string, tối đa 10 ký tự
- `phone`: Tùy chọn, string, tối đa 24 ký tự
- `email`: Bắt buộc, string, tối đa 60 ký tự
- `dob`: Tùy chọn, định dạng date (YYYY-MM-DD)
- `role`: Tùy chọn, enum (user|admin)

#### 2.4.4 Authorization Logic
- User có thể cập nhật chỉ thông tin của chính mình
- Admin có thể cập nhật thông tin của bất kỳ user nào
- Trường `enabled` sẽ bị loại bỏ từ request để tránh manipulation

#### 2.4.5 Response Structure
```json
{
  "success": "boolean"
}
```

#### 2.4.6 Response Cases
- **Thành công**: HTTP 200 với `{"success": true}`
- **Unauthorized**: HTTP 401 (Không có token hoặc token không hợp lệ)
- **Forbidden**: HTTP 403 (User cố gắng cập nhật thông tin của user khác)
- **Validation Error**: HTTP 422 (Dữ liệu không đúng format)
- **Method Not Allowed**: HTTP 405 (Sử dụng method khác PUT)

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

### 3.4 Test Cases cho PUT /users/{userId} (User Profile Update)

#### 3.4.1 Positive Test Cases
1. **TC_PROFILE_001**: User cập nhật thông tin của chính mình với đầy đủ thông tin hợp lệ
2. **TC_PROFILE_002**: User cập nhật thông tin với các trường tùy chọn (state, postcode, phone)
3. **TC_PROFILE_003**: Admin cập nhật thông tin của user khác
4. **TC_PROFILE_004**: Cập nhật với ký tự đặc biệt trong tên (José, O'Connor)
5. **TC_PROFILE_005**: Cập nhật với thông tin quốc tế (địa chỉ châu Âu, số điện thoại có mã quốc gia)

#### 3.4.2 Negative Test Cases
6. **TC_PROFILE_006**: Thiếu trường first_name (422 Validation Error)
7. **TC_PROFILE_007**: Thiếu trường last_name (422 Validation Error)
8. **TC_PROFILE_008**: Thiếu trường address (422 Validation Error)
9. **TC_PROFILE_009**: Thiếu trường city (422 Validation Error)
10. **TC_PROFILE_010**: Thiếu trường country (422 Validation Error)
11. **TC_PROFILE_011**: first_name vượt quá 40 ký tự (422 Validation Error)
12. **TC_PROFILE_012**: last_name vượt quá 20 ký tự (422 Validation Error)
13. **TC_PROFILE_013**: address vượt quá 70 ký tự (422 Validation Error)
14. **TC_PROFILE_014**: city vượt quá 40 ký tự (422 Validation Error)
15. **TC_PROFILE_015**: country vượt quá 40 ký tự (422 Validation Error)
16. **TC_PROFILE_016**: postcode vượt quá 10 ký tự (422 Validation Error)
17. **TC_PROFILE_017**: phone vượt quá 24 ký tự (422 Validation Error)
18. **TC_PROFILE_018**: dob không đúng định dạng (422 Validation Error)
19. **TC_PROFILE_019**: dob là ngày trong tương lai (422 Validation Error)
20. **TC_PROFILE_020**: User cố gắng cập nhật thông tin của user khác (403 Forbidden)
21. **TC_PROFILE_021**: Không có access token (401 Unauthorized)
22. **TC_PROFILE_022**: Access token không hợp lệ (401 Unauthorized)
23. **TC_PROFILE_023**: Access token đã hết hạn (401 Unauthorized)
24. **TC_PROFILE_024**: Sử dụng method POST thay vì PUT (405 Method Not Allowed)
25. **TC_PROFILE_025**: SQL injection attempt trong first_name (500 Internal Server Error)

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

### 4.4 Tạo mới user-profile-api-test-data.csv
Đã tạo file với 20 test cases bao gồm:
```
test_case,description,first_name,last_name,email,dob,address,city,state,country,postcode,phone,expected_status,expected_message
```

**Highlights của data file:**
- **5 Positive Test Cases**: Bao gồm cập nhật thành công với đầy đủ thông tin, trường tùy chọn, ký tự đặc biệt, và thông tin quốc tế
- **15 Negative Test Cases**: Bao gồm các trường hợp validation error, authorization error, và security testing
- **Đa dạng scenarios**: From basic validation đến advanced security testing (SQL injection)
- **International support**: Test với ký tự đặc biệt và định dạng quốc tế

## 5. KẾT LUẬN

### 5.1 Tổng kết
- Đã phân tích 4 API chính của hệ thống:
  - POST /products (Tạo sản phẩm)
  - GET /invoices (Lấy danh sách hóa đơn)
  - POST /users/login (Đăng nhập)
  - **PUT /users/{userId} (Cập nhật thông tin người dùng)** - **Mới thêm**
- Thiết kế 50 test cases tổng cộng (20 cho User Profile API)
- Bao gồm cả positive và negative test cases
- Đã tạo data file user-profile-api-test-data.csv với 20 test cases chi tiết

### 5.2 Phân tích chi tiết User Profile API
**Điểm mạnh:**
- Authorization logic rõ ràng (user chỉ cập nhật được thông tin của mình, admin có quyền cao hơn)
- Validation rules đầy đủ với giới hạn độ dài phù hợp
- Xử lý security (loại bỏ trường `enabled` để tránh privilege escalation)
- Support các trường tùy chọn (state, postcode, phone, dob)

**Điểm cần lưu ý:**
- Không có validation cho format email trong update (chỉ kiểm tra max length)
- Không có validation cho định dạng số điện thoại
- Cần test với SQL injection và XSS attacks
- Cần kiểm tra concurrent update scenarios

### 5.3 Test Coverage
**User Profile API có 25 test cases bao gồm:**
- **5 Positive cases**: Các scenarios cập nhật thành công
- **20 Negative cases**: Validation errors, authorization errors, security tests
- **Coverage areas**: Input validation, Authentication, Authorization, Security, Error handling

### 5.4 Khuyến nghị
- Thực hiện test automation với Postman hoặc Newman
- Sử dụng data-driven testing với CSV files
- Tích hợp với CI/CD pipeline
- Bổ sung thêm security testing (OWASP Top 10)
- Thực hiện performance testing cho các API update
- Báo cáo kết quả test chi tiết với metrics 