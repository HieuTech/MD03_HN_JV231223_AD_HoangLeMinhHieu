use QuanLyBanHang;

INSERT INTO Customers (customer_id, name, email, phone, address)
VALUES ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

INSERT INTO Products (product_id, name, description, price, status)
VALUES ('P001', 'iPhone 13 Pro Max', 'Bản 512GB, xanh lá', 22999999, 1),
       ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999, 1),
       ('P003', 'Macbook Pro M2', '8 CPU, 10 GPU, 8GB, 256GB', 28999999, 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000, 1);

INSERT INTO Orders (order_id, customer_id, order_date, total_amount)
VALUES ('H001', 'C001', '2023-02-22', 52999997),
       ('H002', 'C004', '2023-03-11', 80999997),
       ('H003', 'C001', '2023-01-22', 54359998),
       ('H004', 'C002', '2023-03-14', 102999995),
       ('H005', 'C003', '2023-03-12', 80999997),
       ('H006', 'C004', '2023-02-01', 110449994),
       ('H007', 'C005', '2023-03-29', 79999996),
       ('H008', 'C001', '2023-02-14', 29999998),
       ('H009', 'C002', '2023-01-10', 28999999),
       ('H010', 'C001', '2023-04-01', 149999994);

INSERT INTO orders_details (order_id, product_id, quantity, price)
VALUES ('H001', 'P002', 1, 14999999),
       ('H001', 'P004', 2, 18999999),
       ('H002', 'P001', 1, 22999999),
       ('H002', 'P003', 2, 28999999),
       ('H003', 'P004', 2, 18999999),
       ('H003', 'P005', 4, 4090000),
       ('H004', 'P002', 3, 14999999),
       ('H004', 'P003', 2, 28999999),
       ('H005', 'P001', 1, 22999999),
       ('H005', 'P003', 2, 28999999),
       ('H006', 'P005', 5, 4090000),
       ('H006', 'P002', 6, 14999999),
       ('H007', 'P004', 3, 18999999),
       ('H007', 'P001', 1, 22999999),
       ('H008', 'P002', 2, 14999999),
       ('H001', 'P003', 1, 28999999),
       ('H009', 'P003', 2, 28999999),
       ('H010', 'P001', 4, 22999999),
       ('H010', 'P002', 1, 14999999);



-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
-- [4 điểm]

select name, email, phone, address
from customers;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
-- thoại và địa chỉ khách hàng). [4 điểm]

select cs.name, cs.phone, cs.address
from customers cs
         join orders od on od.customer_id = cs.customer_id
where year(od.order_date) = '2023'
  and month(od.order_date) = '03';

-- 3. Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
-- tháng và tổng doanh thu ). [4 điểm]

    select total_amount from orders where month(order_date) in (1,2,3,4);

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
-- hàng, địa chỉ , email và số điên thoại). [4 điểm]

select customer_id
from customers
where customer_id not in (select orders.customer_id
                          from orders
                                   join customers cs on cs.customer_id = orders.customer_id
                          where month(order_date) = 2
                          group by orders.customer_id);



-- 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
-- sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]

    select  count(od.quantity) as TotalPerProduct from orders join orders_details od on od.order_id = orders.order_id
    where month(orders.order_date) = 3
    group by od.product_id
    ;

-- 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]

    select  sum(total_amount) as TongChiTieu, cs.name  from customers cs join orders on cs.customer_id = orders.customer_id
    where year(orders.order_date) = 2023
                                             group by orders.customer_id
    order by TongChiTieu desc;

-- 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) . [5 điểm]

select cs.name, orders.total_amount, orders.order_date, sum(od.quantity) as TongSoLuong from customers cs join orders on cs.customer_id = orders.customer_id
join orders_details od on od.order_id = orders.order_id
where od.quantity > 5
group by cs.name, orders.total_amount, orders.order_date
