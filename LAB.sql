create database LAB;
use LAB;
/* For Category Table */
create table Category(CAT_ID int,CAT_NAME varchar(20) NOT NULL, primary key(CAT_ID));
insert into Category values(1,'BOOKS'),(2,'GAMES'),(3,'GROCERIES'),(4,'ELECTRONICS'),
(5,'CLOTHES');
/* For Product Table */
create table Product(PRO_ID int primary key,PRO_NAME varchar(20) NOT NULL default 'dummy',
PRO_DESC varchar(60),CAT_ID int,
foreign key(CAT_ID) references Category(CAT_ID));
insert into Product values
(1,'GTA','V Windows 7 and above with i5 processor and 8GB RAM',2),
(2,'TSHIRT','SIZE-L with Black, Blue and White variations',5),
(3,'ROG LAPTOP','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),
(4,'OATS','Highly Nutritious from Nestle',3),
(5,'HARRY POTTER','Best Collection of all time by J.K Rowling',1),
(6,'MILK','1L Toned MIlk',3),
(7,'Boat Earphones','1.5Meter long Dolby Atmos',4),
(8,'Jeans','Stretchable Denim Jeans with various sizes and color',5),
(9,'Project IGI','compatible with windows 7 and above',2),
(10,'Hoodie', 'Black GUCCI for 13 yrs and above',5),
(11,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),
(12,'Train Your Brain','By Shireen Stephen',1);
/* For Supplier Table */
create table Supplier(SUPP_ID int primary key, SUPP_NAME varchar(50) not null,
SUPP_CITY varchar(50) not null,SUPP_PHONE varchar(50) not null);
insert into Supplier values(1,'Rajesh Retails','Delhi','1234567890'),
(2,'Appario Ltd.','Mumbai','2589631470'),
(3,'Knome products','Banglore','9785462315'),
(4,'Bansal Retails', 'Kochi','8975463285'),
(5,'Mittal Ltd.','Lucknow','7898456532');
/* For Supllier_pricing Table */
create table Supllier_pricing(PRICING_ID int primary key,PRO_ID int,SUPP_ID int,SUPP_PRICE int default 0,
foreign key(PRO_ID) references Product(PRO_ID),
foreign key(SUPP_ID) references Supplier(SUPP_ID));
insert into Supllier_pricing values
(1,1,2,1500),
(2,3,5,30000),
(3,5,1,3000),
(4,2,3,2500),
(5,4,1,1000),
(6,12,2,780),
(7,12,4,789),
(8,3,1,31000),
(9,1,5,1450),
(10,4,2,999);
/*For Customer Table */
create table Customer(CUS_ID int primary key,CUS_NAME varchar(20) not null,
CUS_PHONE varchar(10) not null, CUS_CITY varchar(30) not null,CUS_GENDER char);
insert into Customer values
(1,'AAKASH','9999999999','DELHI','M'),
(2,'AMAN','9785463215','NOIDA','M'),
(3,'NEHA','9999999999','MUMBAI','F'),
(4,'MEGHA','9994562399','KOLKATA','F'),
(5,'PULKIT','7895999999','LUCKNOW','M');
/* For Orders Table */
create table Orders(ORD_ID int primary key,ORD_AMOUNT int not null,
ORD_DATE date not null,CUS_ID int,PRICING_ID int,
foreign key(CUS_ID) references Customer(CUS_ID),
foreign key(PRICING_ID) references Supllier_pricing(PRICING_ID));
insert into Orders values
(101,1500,'2021-10-06',2,1);
insert into Orders values(102,1000,'2021-10-12',3,5);
insert into Orders values(103,30000,'2021-09-16',5,2);
insert into Orders values(104,1500,'2021-10-05',1,1);
insert into Orders values(105,3000,'2021-08-16',4,3);
insert into Orders values(106,1450,'2021-08-18',1,9);
insert into Orders values(107,789,'2021-09-01',3,7);
insert into Orders values(108,780,'2021-09-07',5,6);
insert into Orders values(109,3000,'2021-09-10',5,3);
insert into Orders values(110,2500,'2021-09-10',2,4);
insert into Orders values(111,1000,'2021-09-15',4,5);
insert into Orders values(112,789,'2021-09-16',4,7);
insert into Orders values(113,31000,'2021-09-16',1,8);
insert into Orders values(114,1000,'2021-09-16',3,5);
insert into Orders values(115,3000,'2021-09-16',5,3);
insert into Orders values(116,999,'2021-09-17',2,10);
/* For Rating Table */
create table Rating(RAT_ID int primary key,ORD_ID int,
RAT_RATSTARS int,
foreign key(ORD_ID) references Orders(ORD_ID));
insert into Rating values
(1,101,4),
(2,102,3),
(3,103,1),
(4,104,2),
(5,105,4),
(6,106,3),
(7,107,4),
(8,108,4),
(9,109,3),
(10,110,5),
(11,111,3),
(12,112,4),
(13,113,2),
(14,114,1),
(15,115,1),
(16,116,0);
/* Q1. Display the total number of customers based on gender 
who have placed individual orders of worth at least Rs.3000. */
select CUS_GENDER, count(*) from Customer 
join Orders using (CUS_ID) 
join Supllier_pricing using (PRICING_ID) 
where SUPP_PRICE>=3000 group by CUS_GENDER;
/* Q2. Display all the orders along with product name 
ordered by a customer having Customer_Id=2 */
select CUS_ID,ORD_DATE,ORD_AMOUNT,PRO_NAME from Customer
 join Orders using (CUS_ID)
 join Supllier_pricing using (PRICING_ID) 
 join Product using (PRO_ID) having CUS_ID=2; 

/* Q3. Display the Supplier details who can supply more than one product. */
select SUPP_NAME,count(*),SUPP_CITY,SUPP_PHONE from Supplier 
join Supllier_pricing using(SUPP_ID) 
join Product using (PRO_ID) 
group by SUPP_NAME,SUPP_CITY,SUPP_PHONE having count(*)>1;

/* Q4. Find the least expensive product from each category 
and print the table with category id, name, product name and price of the product */
select CAT_NAME,PRO_NAME,PRO_DESC,min(SUPP_PRICE) from Category 
join Product using (CAT_ID) 
join Supllier_pricing using (PRO_ID) 
group by CAT_NAME,PRO_NAME,PRO_DESC;

/* Q5. Display the Id and Name of the Product ordered after “2021-10-05”.*/
select PRO_ID,PRO_NAME,ORD_DATE from Product 
join Supllier_pricing using (PRO_ID) 
join Orders using (PRICING_ID) 
where ORD_DATE>'2021-10-05';

/* Q6. Display customer name and gender whose names start or end with character 'A'. */
select CUS_NAME,CUS_GENDER from Customer where CUS_NAME like 'A%' or CUS_NAME like '%A';

/* Q7. Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and
Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average
Service” else print “Poor Service”. Note that there should be one rating per supplier. */
DELIMITER &&
	create procedure supplierRating()
	BEGIN
	select SUPP_ID,SUPP_NAME,avg(RAT_RATSTARS),
		Case
		when avg(RAT_RATSTARS)=5 then 'EXCELLENT SERVICE'
		when avg(RAT_RATSTARS)>4 then 'GOOD SERVICE'
		when avg(RAT_RATSTARS)>2 then 'AVERAGE SERVICE'
		else 'POOR SERVICE'
		end as 'TYPE OF SERVICE'
from Supplier 
join Supllier_pricing using (SUPP_ID) 
join Orders using (PRICING_ID) 
join Rating using (ORD_ID) 
group by SUPP_ID,SUPP_NAME;
	END && 
	#DELIMITER;

#Callin procedure supplierRating()
call supplierRating()


