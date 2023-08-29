CREATE DATABASE Example1
USE Example1;
GO
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Description NVARCHAR(200),
    Unit NVARCHAR(20),
    Price MONEY
);
GO
-- Thêm dữ liệu vào bảng Danh sách mặt hàng
INSERT INTO Product (ProductID, ProductName, Description, Unit, Price)
VALUES
    (1, N'Máy Tính T450', N'Máy nhập mới', N'Chiếc', 1000),
    (2, N'Điện Thoại Nokia5670', N'Điện thoại đang hot', N'Chiếc', 200),
    (3, N'Máy In Samsung 450', N'Máy in đang ế', N'Chiếc', 100);
GO
-- Tạo bảng Đơn đặt hàng
CREATE TABLE OrderHeader (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    Address NVARCHAR(200),
    Phone NVARCHAR(20),
    OrderDate DATE
);
GO
-- Thêm dữ liệu vào bảng Đơn đặt hàng
INSERT INTO OrderHeader (OrderID, CustomerName, Address, Phone, OrderDate)
VALUES
    (123, N'Trần Xuân Lực', N'111 Nguyễn Trãi, Thanh Xuân, Hà Nội', N'987654321', '2023-08-29');
GO
-- Tạo bảng Chi tiết đơn đặt hàng
CREATE TABLE OrderDetail (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    TotalPrice MONEY,
    FOREIGN KEY (OrderID) REFERENCES OrderHeader(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
GO
-- Thêm dữ liệu vào bảng Chi tiết đơn đặt hàng
INSERT INTO OrderDetail (OrderDetailID, OrderID, ProductID, Quantity, TotalPrice)
VALUES
    (1, 123, 1, 1, 1000),
    (2, 123, 2, 2, 400),
    (3, 123, 3, 1, 100);
GO
SELECT DISTINCT CustomerName
FROM OrderHeader;
GO
SELECT ProductName, Price
FROM Product;
GO
SELECT OrderID, CustomerName, OrderDate
FROM OrderHeader;
GO
SELECT CustomerName
FROM OrderHeader
ORDER BY CustomerName ASC;
GO
SELECT ProductName, Price
FROM Product
ORDER BY Price DESC;
GO
SELECT DISTINCT p.ProductName
FROM Product p
INNER JOIN OrderDetail od ON p.ProductID = od.ProductID
INNER JOIN OrderHeader oh ON od.OrderID = oh.OrderID
WHERE oh.CustomerName = N'Trần Xuân Lực';
GO
SELECT COUNT(DISTINCT CustomerName) AS NumberOfCustomers
FROM OrderHeader;
GO
SELECT COUNT(*) AS NumberOfProducts
FROM Product;
GO
SELECT OrderID, SUM(TotalPrice) AS TotalAmount
FROM OrderDetail
GROUP BY OrderID;
GO
UPDATE Product
SET Price = 500 -- Giá tiền mới
WHERE Price <= 0;
GO
UPDATE OrderHeader
SET OrderDate = '2023-08-29' -- Ngày mới
WHERE OrderDate > '2023-08-29';
GO
ALTER TABLE Product
ADD MarketAppearanceDate DATE;
GO
UPDATE Product
SET Price = 0 -- Giá tiền mong muốn
WHERE Price <= 0
GO
UPDATE OrderHeader
SET OrderDate = GETDATE() -- Ngày hiện tại
WHERE OrderDate > GETDATE()
GO
ALTER TABLE Product
ADD MarketAppearanceDate DATE
GO
-- Chỉ mục cho cột Tên hàng
CREATE INDEX idx_ProductName ON Product(ProductName);

-- Chỉ mục cho cột Người đặt hàng
CREATE INDEX idx_CustomerName ON OrderHeader(CustomerName);
GO
CREATE VIEW View_KhachHang AS
SELECT CustomerName, Address, Phone
FROM OrderHeader;
GO
CREATE VIEW View_SanPham AS
SELECT ProductName, Price
FROM Product;
GO
CREATE VIEW View_KhachHang_SanPham AS
SELECT oh.CustomerName, oh.Phone, p.ProductName, od.Quantity, oh.OrderDate
FROM OrderHeader oh
JOIN OrderDetail od ON oh.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID;
GO
CREATE PROCEDURE SP_TimKH_MaKH
    @MaKH INT
AS
BEGIN
    SELECT *
    FROM OrderHeader
    WHERE OrderID = @MaKH;
END;
GO
CREATE PROCEDURE SP_TimKH_MaHD
    @MaHD INT
AS
BEGIN
    SELECT *
    FROM View_KhachHang_SanPham
    WHERE OrderID = @MaHD;
END;
GO