drop table order_detail, product;
drop table vendor,  cus_order, customer;


CREATE TABLE VENDOR (
 V_CODE     NUMERIC(5)   NOT NULL,
 V_NAME     VARCHAR(35) NOT NULL,
 V_CONTACT  VARCHAR(15) NOT NULL,
 V_AREACODE VARCHAR(3)     NOT NULL,
 V_PHONE    VARCHAR(8)     NOT NULL,
 V_STATE    VARCHAR(3)     NOT NULL,
 V_ORDER    VARCHAR(1)     NOT NULL,
 CONSTRAINT VENDOR_PK PRIMARY KEY (V_CODE));

CREATE TABLE PRODUCT (
 P_CODE     varchar(10)
   CONSTRAINT PRODUCT_P_CODE_PK PRIMARY KEY,
 P_DESCRIPT varchar(35) NOT NULL,
 P_INDATETIME   DATETIME         NOT NULL,

 -- total number of products current in stock
 P_ONHAND   NUMERIC(4)    NOT NULL,

 -- recommended minimum number of products to be sold in each order
 P_MIN      NUMERIC(4)    NOT NULL,

 P_PRICE    NUMERIC(8,2)  NOT NULL,
 P_DISCOUNT NUMERIC(4,2)  NOT NULL CHECK (P_DISCOUNT >= 0 AND P_DISCOUNT < 1),
 V_CODE     NUMERIC(5),
   CONSTRAINT PRODUCT_V_CODE_FK
   FOREIGN KEY (V_CODE) REFERENCES VENDOR);


CREATE TABLE CUSTOMER (
CUS_CODE       	NUMERIC(6)
 CONSTRAINT CUSTOMER_PK PRIMARY KEY,
CUS_LNAME       varchar(15) NOT NULL,
CUS_FNAME       varchar(15) NOT NULL,
CUS_INITIAL     CHAR(1),
CUS_AREACODE 	VARCHAR(3) DEFAULT '02' NOT NULL CHECK(CUS_AREACODE IN ('03','07','08')),
CUS_PHONE       VARCHAR(8) NOT NULL,
CUS_BALANCE     NUMERIC(9,2) DEFAULT 0.00);

CREATE TABLE CUS_ORDER (
ORDER_CODE       NUMERIC(6)
 CONSTRAINT ORDER_PK PRIMARY KEY,
CUS_CODE       NUMERIC(6) NOT NULL
/*
CONSTRAINT CUS_ORDER_FK FOREIGN KEY(CUS_CODE) REFERENCES CUSTOMER
*/
,
ORDDATETIME       DATETIME);

CREATE TABLE ORDER_DETAIL(
ORDER_CODE	NUMERIC(6),
PRODUCT_CODE	VARCHAR(10),
QUANTITY	NUMERIC(4) DEFAULT 1 CHECK (QUANTITY >=0),
  CONSTRAINT ORD_DETAIL_PK PRIMARY KEY(ORDER_CODE,PRODUCT_CODE),
  CONSTRAINT ORD_DETAIL_FK1 FOREIGN KEY (ORDER_CODE) REFERENCES CUS_ORDER(ORDER_CODE),
  CONSTRAINT ORD_DETAIL_FK2 FOREIGN KEY (PRODUCT_CODE) REFERENCES PRODUCT(P_CODE));

SET NOCOUNT ON

INSERT INTO VENDOR
VALUES (21225,'Bryson, Inc.','Stan Smithson','02','223-3234','NSW','Y');


INSERT INTO VENDOR
VALUES (21226,'Superloo, Inc.','Mary Flushing','02','215-8995','NSW','N');

INSERT INTO VENDOR
VALUES (21227,'Blackwell','Bob Jones','02','215-9999','NSW','N');

INSERT INTO VENDOR
VALUES (21999,'ABC Victoria','Ali Nasour','03','662-8789','VIC','N');

INSERT INTO VENDOR
VALUES (22333,'Stewart Brothers','Yan Wong','03','445-8888','VIC','N');

INSERT INTO VENDOR
VALUES (66777,'Buchner Pty Ltd','Stu Buchner','02','215-4444','NSW','N');

INSERT INTO VENDOR
VALUES (33322,'Blue Seas','Lee','03','395-8995','VIC','Y');


INSERT INTO Product
VALUES ('11QER/31','Power painter, 15 psi., 3-nozzle','03-NOV-03',8,5,109.99,0.00,21225);

INSERT INTO Product
VALUES ('13-Q2/P2','7.25-in. pwr. saw blade','13-DEC-03',32,15,14.99, 0.05,22333);


INSERT INTO Product
VALUES ('BRT-345','Titanium drill bit', '18-OCT-02', 75, 10, 4.50, 0.06, 21225);

INSERT INTO Product
VALUES ('13-Q3/P4','10.5-in. pwr. saw blade','13-DEC-03',3,15,54.00, 0.05,22333);

INSERT INTO Product
VALUES ('LZQ202','10.5-in. pwr. saw blade','13-NOV-03',3,15,54.00, 0.05,66777);

INSERT INTO Product
VALUES ('PB101','professional paintbrush pack','11-DEC-03',71,15,11.50, 0.05,66777);

INSERT INTO Customer
VALUES (555555, 'Jackson', 'Suzanne', 'S', '07', '12345678', 5523.76);

INSERT INTO Customer
VALUES (888888, 'Hazal', 'Ali', 'A','08', '98989898', 0.0);

INSERT INTO Customer
VALUES (333333, 'Wang', 'Phan', 'P','08', '56565656', 10.05);

INSERT INTO Customer
VALUES (111111, 'Tudor-Smith', 'Toby', 'T','03', '98989898', 978.45);

INSERT INTO Cus_order
VALUES (444555, 888888, '23-SEP-05');


INSERT INTO Cus_order
VALUES (444333, 888888, '24-SEP-05');

INSERT INTO Cus_order
VALUES (333111, 888888, '23-SEP-05');

INSERT INTO Cus_order
VALUES (555555, 333333, '23-SEP-05');

INSERT INTO Cus_order
VALUES (999999, 333333, '20-SEP-05');


INSERT INTO ORDER_DETAIL
VALUES (999999, 'LZQ202', 10);  -- not all in stock

INSERT INTO ORDER_DETAIL
VALUES (999999, 'BRT-345', 15);


INSERT INTO ORDER_DETAIL
VALUES (999999, 'PB101', 20);


INSERT INTO ORDER_DETAIL
VALUES (555555, 'BRT-345',20);


INSERT INTO ORDER_DETAIL
VALUES (555555, 'PB101', 20);

INSERT INTO ORDER_DETAIL
VALUES (333111, 'BRT-345', 25);


INSERT INTO ORDER_DETAIL
VALUES (333111, '11QER/31', 5);

SET NOCOUNT OFF

-- 1 - Selected Additional Exercises - Gamma - a 
SELECT P_DESCRIPT, P_PRICE, V_NAME
FROM PRODUCT, VENDOR
WHERE VENDOR.V_CODE = PRODUCT.V_CODE
ORDER BY P_DESCRIPT, V_NAME;

-- b
SELECT DISTINCT P_DESCRIPT, CUSTOMER.CUS_FNAME, CUSTOMER.CUS_LNAME
FROM PRODUCT, CUSTOMER, CUS_ORDER, VENDOR, ORDER_DETAIL
WHERE VENDOR.V_CODE = PRODUCT.V_CODE
AND PRODUCT.P_CODE = ORDER_DETAIL.PRODUCT_CODE
AND CUS_ORDER.ORDER_CODE = ORDER_DETAIL.ORDER_CODE
AND CUSTOMER.CUS_CODE = CUS_ORDER.CUS_CODE
AND CUSTOMER.CUS_FNAME = 'Phan'
AND CUSTOMER.CUS_LNAME = 'Wang';

-- c
SELECT ORDER_DETAIL.ORDER_CODE, SUM(PRODUCT.P_PRICE * ORDER_DETAIL.QUANTITY) AS CHARGE_TO_CUSTOMER
FROM PRODUCT, CUSTOMER, CUS_ORDER, VENDOR, ORDER_DETAIL
WHERE VENDOR.V_CODE = PRODUCT.V_CODE
AND PRODUCT.P_CODE = ORDER_DETAIL.PRODUCT_CODE
AND CUS_ORDER.ORDER_CODE = ORDER_DETAIL.ORDER_CODE
AND CUSTOMER.CUS_CODE = CUS_ORDER.CUS_CODE
GROUP BY ORDER_DETAIL.ORDER_CODE;

-- Pet

CREATE TABLE PetType (
petTypeId VARCHAR(10) PRIMARY KEY,
animalType VARCHAR(20),
breed VARCHAR(20)
);

CREATE TABLE Owner (
ownerId VARCHAR(10) PRIMARY KEY,
firstName VARCHAR(20),
lastName VARCHAR(20) NOT NULL,
homePhoneNumber VARCHAR(20),
streetAddress VARCHAR(80),
suburb VARCHAR(20),
postcode VARCHAR(10)
);

CREATE TABLE Pet (
petId VARCHAR(10) PRIMARY KEY,
petName VARCHAR(20),
sex CHAR(1)
CHECK (sex IN ('M', 'F')),
petTypeId VARCHAR(10)
FOREIGN KEY REFERENCES PetType
);

CREATE TABLE PetAndOwner (
ownerId VARCHAR(10),
petId VARCHAR(10),
PRIMARY KEY (ownerId, petId),
FOREIGN KEY (ownerId) REFERENCES Owner,
FOREIGN KEY (petId) REFERENCES Pet
);

INSERT INTO PetType VALUES ('001', 'dog', 'Bulldog');
INSERT INTO PetType VALUES ('002', 'dog', 'Lhasa Apso');
INSERT INTO PetType VALUES ('003', 'dog', 'Maltese');
INSERT INTO PetType VALUES ('004', 'cat', 'Persian');
INSERT INTO PetType VALUES ('005', 'cat', 'Ragdoll');
INSERT INTO Owner VALUES ('001', 'David', 'Smith', '12345678',
'100 Victoria Road', 'Rydalmere', '2116');
INSERT INTO Owner VALUES ('002', 'Louise', 'Brown', '87654321',
'1 James Ruse Road', 'Rydalmere', '2116');
INSERT INTO Owner VALUES ('003', 'Robert', 'Brown', '11223344',
'2 Wentworth Street', 'Parramatta', '2150');
INSERT INTO Owner VALUES ('004', 'Avatar', 'Phantom', '',
'1 Pandora', 'Na''vi Land', '0000');
INSERT INTO Pet VALUES ('001', 'Mickey Mouse', 'M', '001');
INSERT INTO Pet VALUES ('002', 'Bugs Bunny', 'M', '001');
INSERT INTO Pet VALUES ('003', 'Betty Boop', 'F', '002');
INSERT INTO Pet VALUES ('004', 'Droopy', 'M', '003');
INSERT INTO Pet VALUES ('005', 'Penelope', 'F', '004');
INSERT INTO Pet VALUES ('006', 'Jerry', 'F', '005');
INSERT INTO PetAndOwner VALUES ('001', '001');
INSERT INTO PetAndOwner VALUES ('001', '004');
INSERT INTO PetAndOwner VALUES ('002', '001');
INSERT INTO PetAndOwner VALUES ('002', '005');
INSERT INTO PetAndOwner VALUES ('003', '002');
INSERT INTO PetAndOwner VALUES ('002', '003');
	
-- 1 - Selected Additional Exercises - III

SELECT DISTINCT PetAndOwner.ownerId, Owner.firstName, Owner.lastName
FROM PetAndOwner
INNER JOIN (SELECT ownerId, COUNT(ownerId) 
				AS petCount
				FROM PetAndOwner
				GROUP BY ownerId) 
AS countedPetAndOwner ON PetAndOwner.ownerId = countedPetAndOwner.ownerId 
INNER JOIN Owner ON PetAndOwner.ownerId = Owner.ownerId
WHERE petCount > 1

-- 1 - Selected Additional Exercises - IV - Beta

SELECT Owner.ownerId, Owner.firstName, Owner.lastName, Pet.petName
FROM Owner LEFT JOIN PetAndOwner ON Owner.ownerId = PetAndOwner.ownerId 
LEFT JOIN Pet ON Pet.petId = PetAndOwner.petId

------------------------------------------
--------- 3 - SQL FOR ERD AND GRD --------
------------------------------------------

DROP TABLE Booking;
DROP TABLE TherapistSkill;
DROP TABLE TimeServicePricing;
DROP TABLE TimeServiceSkillLevel;
DROP TABLE Staff;
DROP TABLE TimeService;
DROP TABLE Client;
DROP TABLE ItemService;

-- 3.1

CREATE TABLE Client (
	clientID int identity(1,1),
	fName nvarchar(100) NOT NULL,
	lName nvarchar(100) NOT NULL,
	CONSTRAINT Client_pk PRIMARY KEY (clientID)
);

CREATE TABLE ItemService (
	itemServiceID int identity(1,1),
	name nvarchar(100) NOT NULL,
	item nvarchar(100) NOT NULL,
	price float NOT NULL,
	duration float NOT NULL,
	CONSTRAINT ItemService_pk PRIMARY KEY (itemServiceID)
);

CREATE TABLE TimeServiceSkillLevel (
	skillLevelID int identity(1,1),
	level int NOT NULL,
	CONSTRAINT TimeServiceSkillLevel_pk PRIMARY KEY (skillLevelID)
);

CREATE TABLE Staff (
	staffID int identity(1,1),
	fName nvarchar(100) NOT NULL,
	lName nvarchar(100) NOT NULL,
	salary float NOT NULL,
	CONSTRAINT Staff_pk PRIMARY KEY (staffID)
);

CREATE TABLE TimeService (
	timeServiceID int identity(1,1),
	name nvarchar(100) NOT NULL,
	duration float NOT NULL,
	CONSTRAINT TimeService_pk PRIMARY KEY (timeServiceID),
);

CREATE TABLE Booking (
	dateFrom datetime NOT NULL,
	clientID int NOT NULL,
	staffID int NOT NULL,
	timeServiceID int,
	itemServiceID int,
	dateTo datetime NOT NULL,
	charge int NOT NULL,
	quantity int NOT NULL,
	CONSTRAINT Booking_pk PRIMARY KEY (dateFrom, clientID),
	CONSTRAINT Booking_TimesService_fk FOREIGN KEY (timeServiceID) REFERENCES TimeService,
	CONSTRAINT Booking_ItemService_fk FOREIGN KEY (itemServiceID) REFERENCES ItemService,
	CONSTRAINT Booking_client_fk FOREIGN KEY (clientID) REFERENCES Client,
	CONSTRAINT Booking_Staff_fk FOREIGN KEY (staffID) REFERENCES Staff
);

CREATE TABLE TherapistSkill (
	staffID int NOT NULL,
	timeServiceID int NOT NULL,
	skillLevelID int NOT NULL,
	CONSTRAINT TherapistSkill_pk PRIMARY KEY (staffID, timeServiceID),
	CONSTRAINT TherapistSkill_staff_fk FOREIGN KEY (staffID) REFERENCES Staff,
	CONSTRAINT TherapistSkill_service_fk FOREIGN KEY (timeServiceID) REFERENCES TimeService,
	CONSTRAINT TherapistSkill_skillLevel_fk FOREIGN KEY (skillLevelID) REFERENCES TimeServiceSkillLevel
);

CREATE TABLE TimeServicePricing (
	skillLevelID int NOT NULL,
	timeServiceID  int NOT NULL,
	rate float NOT NULL, -- CHECK THAT > 0 lol
	CONSTRAINT TimeServicePricing_pk PRIMARY KEY (skillLevelID, timeServiceID),
	CONSTRAINT TimeServicePricing_TimeServiceSkillLevel_fk FOREIGN KEY (skillLevelID) REFERENCES TimeServiceSkillLevel,
	CONSTRAINT TimeServicePricing_TimeService_fk FOREIGN KEY (timeServiceID) REFERENCES TimeService
);

-----------------------

INSERT INTO Client (fName, lName)
	VALUES ('Billy', 'Genes');
	
INSERT INTO Client (fName, lName)
	VALUES ('Horace', 'Scope');

INSERT INTO Client (fName, lName)
	VALUES ('Louis', 'Price');

INSERT INTO Client (fName, lName)
	VALUES ('Doris', 'Shut');
	
-------------------------
	
INSERT INTO ItemService (name, item, price, duration) 
	VALUES	 ('waxing', 'wax strips', '50.0', '1.0');
	
INSERT INTO ItemService
	VALUES	 ('pedicue', 'cotton buds', '40.00', '1.0');
	
INSERT INTO ItemService
	VALUES	 ('manicue', 'cotton buds', '30.00', '1.0');

-------------------------

INSERT INTO TimeService (name, duration)
	VALUES	 ('massage', '1.0');
INSERT INTO TimeService
	VALUES	 ('hair washing', '1.0');
INSERT INTO TimeService
	VALUES	 ('hair cutting', '1.0');

-------------------------

INSERT INTO Staff (fName, lName, salary)
	VALUES ('Abe', 'Rudder', 35000);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Alice', 'Tikband', 29750);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Jeff', 'Healitt', 20000);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Paige', 'Turner', 17000);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Noah', 'Count', 33000);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Milly', 'Meter', 28050);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Willy', 'Tert', 40000);
	
INSERT INTO Staff (fName, lName, salary)
	VALUES ('Zelda', 'Kowz', 34000);
		
-------------------------

INSERT INTO TimeServiceSkillLevel (level)
	VALUES ('1')
INSERT INTO TimeServiceSkillLevel (level)
	VALUES ('2')
INSERT INTO TimeServiceSkillLevel (level)
	VALUES ('3')

-------------------------

INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('1','1','60')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('1','2','70')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('1','3','80')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('2','1','70')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('2','2','80')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('2','3','90')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('3','1','80')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('3','2','90')
INSERT INTO TimeServicePricing (skillLevelID, timeServiceID, rate)
	VALUES ('3','3','100')
	
-------------------------

INSERT INTO TherapistSkill (timeServiceID, staffID, skillLevelID)
	VALUES ('1','1', '1')
INSERT INTO TherapistSkill (timeServiceID, staffID, skillLevelID)
	VALUES ('2','2', '2')
INSERT INTO TherapistSkill (timeServiceID, staffID, skillLevelID)
	VALUES ('3','3', '3')
INSERT INTO TherapistSkill (timeServiceID, staffID, skillLevelID)
	VALUES ('2','1', '2')
INSERT INTO TherapistSkill (timeServiceID, staffID, skillLevelID)
	VALUES ('2','3', '1')

-------------------------

INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-11-11 12:00:00', '2', '1',	'2',			NULL,			'2018-11-11 13:00:00', '70', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-03-12 12:00:00', '1', '1',    '1',            NULL,			'2018-03-12 13:00:00', '60', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-01-01 12:00:00', '3', '2',     '3',			NULL,			'2018-01-01 13:00:00', '70', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-05-05 12:00:00', '3', '2',     '1',			NULL,			'2018-05-05 13:00:00', '60', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-11-11 10:00:00', '1', '2',     '2',			NULL,			'2018-11-11 11:00:00', '80', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-11-04 12:00:00', '1', '3',     '3',			NULL,			'2018-11-04 13:00:00', '90', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-05-01 12:00:00', '4', '1',    NULL,			'2',			'2018-05-01 13:00:00', '40', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-07-11 12:00:00', '2', '3',    NULL,			'2',			'2018-07-11 13:00:00', '40', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-09-11 12:00:00', '4', '1',    NULL,			'3',			'2018-09-11 13:00:00', '30', '1')

-- 3.1

SELECT * FROM Staff;
SELECT * FROM Client;
SELECT * FROM TimeService;
SELECT * FROM ItemService;
SELECT * FROM TherapistSkill;
SELECT * FROM TimeServiceSkillLevel;
SELECT * FROM TimeServicePricing;
SELECT * FROM Booking;

-- 3.2 a
SELECT DISTINCT TimeService.name, Staff.fName, Staff.lName
FROM TimeService, Staff, TherapistSkill
WHERE TimeService.timeServiceID = TherapistSkill.timeServiceID AND
TherapistSkill.staffID = Staff.staffID 
ORDER BY TimeService.name;

-- 3.2 b
SELECT DISTINCT Staff.staffID, Staff.fName, Staff.lName
FROM Staff, Booking
WHERE Staff.staffID = Booking.staffID AND
Booking.dateFrom = '2018-11-11'

-- 3.2 c
SELECT DISTINCT Client.clientID, Client.lName, Client.fName, 
COUNT(Booking.dateFrom) AS Total
FROM Client, Booking
WHERE Client.clientID = Booking.clientID
GROUP BY Client.lName, Client.fName, Client.clientID

-- 3.2 d
SELECT DISTINCT Staff.staffID, TimeService.timeServiceID, Staff.fName,
Staff.lName, MIN(TimeServicePricing.rate) As rate
FROM Staff, TimeService, TherapistSkill, TimeServicePricing
WHERE TimeService.timeServiceID = TimeServicePricing.timeServiceID
AND TherapistSkill.staffID = Staff.staffID
AND TherapistSkill.timeServiceID = TimeService.timeServiceID
GROUP BY Staff.staffID, TimeService.timeServiceID, Staff.fName, Staff.lName

-- 3.3

INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-11-11 12:00:00','4','1','2',NULL,'2018-11-11 13:00:00', '70', '1')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-11-11 11:00:00','4','1','2',NULL,'2018-11-11 13:00:00', '70', '2')
INSERT INTO Booking(dateFrom, clientID, staffID, timeServiceID, itemServiceID, dateTo, charge, quantity)
	VALUES ('2018-11-11 12:02:00','4','1','2',NULL,'2018-11-11 13:00:00', '70', '1')
	

SELECT Client.clientID, Booking.dateFrom, Booking.dateTo, Booking.timeServiceID, TimeService.duration
FROM Client, Booking, TimeService
WHERE Client.clientID = Booking.clientID
AND Booking.timeServiceID = TimeService.timeServiceID
AND Client.clientID = 4