create database if not exists QuanLyBanhang;
       use QuanLyBanHang;
# drop database QuanLyBanhang;
create table if not exists customers(
    customer_id varchar(4) primary key ,
    name varchar(100) not null ,
    email varchar(100) not null ,
    phone varchar(25) not null ,
    address varchar(255) not null

);


create table if not exists products(
    product_id varchar(4) primary key ,
    name varchar(255) not null ,
    description text,
    price double not null,
    status bit(1) not null
);

create table if not exists orders(
    order_id varchar(4) primary key ,
    customer_id varchar(4) not null ,
    order_date date not null ,
    total_amount double not null
);
alter table orders add constraint
    foreign key (customer_id) references customers(customer_id);


create table if not exists orders_details(
    order_id varchar(4) not null ,
    product_id varchar(4) not null,
    quantity int(11) not null,
    price double not null,
    primary key (order_id, product_id)
);
alter table orders_details add constraint
foreign key (product_id) references products(product_id),
add constraint foreign key (order_id) references orders(order_id);

-- Bài 4: Tạo View, Procedure [30 điểm]:
-- 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn . [3 điểm]

create view view_info1
as
    select cs.name, cs.phone, cs.address, o.total_amount, o.order_date
    from customers cs join orders o on cs.customer_id = o.customer_id;

# select * from view_info1;

-- 2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
-- số đơn đã đặt. [3 điểm]

create view view_info2
as
select cs.name, cs.phone, cs.address, count(od.order_id)
from customers cs join orders o on cs.customer_id = o.customer_id
join orders_details od on od.order_id = o.order_id
group by cs.name, cs.phone, cs.address



;
# select * from view_info2;

-- 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm.

create view view_info3
as
select p.name, p.description, p.price, sum(od.quantity)
    from products p join orders_details od on p.product_id = od.product_id
group by od.product_id;

;
# select * from view_info3;

-- 4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]

    create index index_phone_email on customers(phone,email);


-- 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]

    delimiter //
    create procedure procedure_5(in customer_id_in varchar(4))
    begin
        select * from customers where customer_id = customer_id_in;

    end ;//
#     call procedure_5('C001');
-- 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]

delimiter //
create procedure procedure_6()
begin
    select * from products;

end ;//
# call procedure_6();
-- 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]

delimiter //
create procedure procedure_7(in customer_id_in varchar(4))
begin
    select * from orders where customer_id = customer_id_in;

end ;//
# call procedure_7('C001');
#
-- 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]

delimiter //
create procedure procedure_8(in customer_id_in varchar(4),
    in total_amount_in double,
    in order_date_in date,
    in order_id_in varchar(4)
)
begin
    insert into orders (order_id, customer_id, order_date, total_amount) VALUES
    (order_id_in, customer_id_in, order_date_in, total_amount_in);
    select order_id_in;
end ;//
# call procedure_8('C001',232323,'2024-04-04','H100');

-- 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]

delimiter //
create procedure procedure_9(
                             in start_date int,
                             in end_date int
)
begin
    select sum(quantity) from orders join orders_details od on od.order_id = orders.order_id
    where day(orders.order_date) between  start_date  and end_date;

end ;//
# call procedure_9(03,22);

-- 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. [3 điểm]

delimiter //
create procedure procedure_10(
    in month_in int,
    in year_in int
)
begin
    select sum(od.quantity) TongSanPham from orders  join orders_details od on od.order_id = orders.order_id
    where YEAR(orders.order_date) = year_in and MONTH(orders.order_date) = month_in
    group by product_id
    order by TongSanPham desc;


end ;//
# call procedure_10(3, 2023);

