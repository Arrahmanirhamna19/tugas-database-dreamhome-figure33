-- ============================================================================
-- TUGAS BASIS DATA - ORACLE
-- Sumber: Database Systems (Connolly & Begg), Halaman 80, Figure 3.3
-- Skema : DreamHome Rental Database
-- ============================================================================

-- ----------------------------------------------------------------------------
-- BAGIAN 1: PEMBUATAN STRUKTUR TABEL (DDL)
-- Urutan pembuatan dimulai dari tabel induk (Primary Key) ke tabel anak (Foreign Key)
-- ----------------------------------------------------------------------------

CREATE TABLE Branch (
    branchNo VARCHAR2(5)  CONSTRAINT pk_branch PRIMARY KEY,
    street   VARCHAR2(50) NOT NULL,
    city     VARCHAR2(30) NOT NULL,
    postcode VARCHAR2(15) NOT NULL
);

CREATE TABLE Staff (
    staffNo  VARCHAR2(5)  CONSTRAINT pk_staff PRIMARY KEY,
    fName    VARCHAR2(30) NOT NULL,
    lName    VARCHAR2(30) NOT NULL,
    position VARCHAR2(20) NOT NULL,
    sex      CHAR(1)      CONSTRAINT chk_staff_sex CHECK (sex IN ('M', 'F')),
    DOB      DATE         NOT NULL,
    salary   NUMBER(8,2)  NOT NULL,
    branchNo VARCHAR2(5)  CONSTRAINT fk_staff_branch REFERENCES Branch(branchNo)
);

CREATE TABLE PrivateOwner (
    ownerNo  VARCHAR2(5)  CONSTRAINT pk_owner PRIMARY KEY,
    fName    VARCHAR2(30) NOT NULL,
    lName    VARCHAR2(30) NOT NULL,
    address  VARCHAR2(80) NOT NULL,
    telNo    VARCHAR2(20) NOT NULL
);

CREATE TABLE PropertyForRent (
    propertyNo VARCHAR2(5)  CONSTRAINT pk_property PRIMARY KEY,
    street     VARCHAR2(50) NOT NULL,
    city       VARCHAR2(30) NOT NULL,
    postcode   VARCHAR2(15) NOT NULL,
    type       VARCHAR2(10) NOT NULL,
    rooms      NUMBER(2)    NOT NULL,
    rent       NUMBER(7,2)  NOT NULL,
    ownerNo    VARCHAR2(5)  NOT NULL CONSTRAINT fk_prop_owner REFERENCES PrivateOwner(ownerNo),
    staffNo    VARCHAR2(5)  CONSTRAINT fk_prop_staff REFERENCES Staff(staffNo),
    branchNo   VARCHAR2(5)  NOT NULL CONSTRAINT fk_prop_branch REFERENCES Branch(branchNo)
);

CREATE TABLE Client (
    clientNo VARCHAR2(5)  CONSTRAINT pk_client PRIMARY KEY,
    fName    VARCHAR2(30) NOT NULL,
    lName    VARCHAR2(30) NOT NULL,
    telNo    VARCHAR2(20) NOT NULL,
    prefType VARCHAR2(10) NOT NULL,
    maxRent  NUMBER(7,2)  NOT NULL
);

CREATE TABLE Viewing (
    clientNo   VARCHAR2(5) NOT NULL CONSTRAINT fk_view_client REFERENCES Client(clientNo),
    propertyNo VARCHAR2(5) NOT NULL CONSTRAINT fk_view_prop REFERENCES PropertyForRent(propertyNo),
    viewDate   DATE        NOT NULL,
    comments   VARCHAR2(100),
    CONSTRAINT pk_viewing PRIMARY KEY (clientNo, propertyNo, viewDate)
);

CREATE TABLE Registration (
    clientNo   VARCHAR2(5) NOT NULL CONSTRAINT fk_reg_client REFERENCES Client(clientNo),
    branchNo   VARCHAR2(5) NOT NULL CONSTRAINT fk_reg_branch REFERENCES Branch(branchNo),
    staffNo    VARCHAR2(5) NOT NULL CONSTRAINT fk_reg_staff REFERENCES Staff(staffNo),
    dateJoined DATE        NOT NULL,
    CONSTRAINT pk_registration PRIMARY KEY (clientNo, branchNo)
);

-- ----------------------------------------------------------------------------
-- BAGIAN 2: PENGISIAN DATA INSTANCE (DML) SESUAI FIGURE 3.3
-- ----------------------------------------------------------------------------

-- 1. Data Tabel Branch
INSERT INTO Branch VALUES ('B005', '22 Deer Rd', 'London', 'SW1 4EH');
INSERT INTO Branch VALUES ('B007', '16 Argyll St', 'Aberdeen', 'AB2 3SU');
INSERT INTO Branch VALUES ('B003', '163 Main St', 'Glasgow', 'G11 9QX');
INSERT INTO Branch VALUES ('B004', '32 Manse Rd', 'Bristol', 'BS99 1NZ');
INSERT INTO Branch VALUES ('B002', '56 Clover Dr', 'London', 'NW10 6EU');

-- 2. Data Tabel Staff
INSERT INTO Staff VALUES ('SL21', 'John', 'White', 'Manager', 'M', TO_DATE('01-Oct-1945', 'DD-Mon-YYYY'), 30000, 'B005');
INSERT INTO Staff VALUES ('SG37', 'Ann', 'Beech', 'Assistant', 'F', TO_DATE('10-Nov-1960', 'DD-Mon-YYYY'), 12000, 'B003');
INSERT INTO Staff VALUES ('SG14', 'David', 'Ford', 'Supervisor', 'M', TO_DATE('24-Mar-1958', 'DD-Mon-YYYY'), 18000, 'B003');
INSERT INTO Staff VALUES ('SA9', 'Mary', 'Howe', 'Assistant', 'F', TO_DATE('19-Feb-1970', 'DD-Mon-YYYY'), 9000, 'B007');
INSERT INTO Staff VALUES ('SG5', 'Susan', 'Brand', 'Manager', 'F', TO_DATE('03-Jun-1940', 'DD-Mon-YYYY'), 24000, 'B003');
INSERT INTO Staff VALUES ('SL41', 'Julie', 'Lee', 'Assistant', 'F', TO_DATE('13-Jun-1965', 'DD-Mon-YYYY'), 9000, 'B005');

-- 3. Data Tabel PrivateOwner
INSERT INTO PrivateOwner VALUES ('CO46', 'Joe', 'Keogh', '2 Fergus Dr, Aberdeen AB2 7SX', '01224-861212');
INSERT INTO PrivateOwner VALUES ('CO87', 'Carol', 'Farrel', '6 Achray St, Glasgow G32 9DX', '0141-357-7419');
INSERT INTO PrivateOwner VALUES ('CO40', 'Tina', 'Murphy', '63 Well St, Glasgow G42', '0141-943-1728');
INSERT INTO PrivateOwner VALUES ('CO93', 'Tony', 'Shaw', '12 Park Pl, Glasgow G4 0QR', '0141-225-7025');

-- 4. Data Tabel PropertyForRent
INSERT INTO PropertyForRent VALUES ('PA14', '16 Holhead', 'Aberdeen', 'AB7 5SU', 'House', 6, 650, 'CO46', 'SA9', 'B007');
INSERT INTO PropertyForRent VALUES ('PL94', '6 Argyll St', 'London', 'NW2', 'Flat', 4, 400, 'CO87', 'SL41', 'B005');
INSERT INTO PropertyForRent VALUES ('PG4', '6 Lawrence St', 'Glasgow', 'G11 9QX', 'Flat', 3, 350, 'CO40', NULL, 'B003');
INSERT INTO PropertyForRent VALUES ('PG36', '2 Manor Rd', 'Glasgow', 'G32 4QX', 'Flat', 3, 375, 'CO93', 'SG37', 'B003');
INSERT INTO PropertyForRent VALUES ('PG21', '18 Dale Rd', 'Glasgow', 'G12', 'House', 5, 600, 'CO87', 'SG37', 'B003');
INSERT INTO PropertyForRent VALUES ('PG16', '5 Novar Dr', 'Glasgow', 'G12 9AX', 'Flat', 4, 450, 'CO93', 'SG14', 'B003');

-- 5. Data Tabel Client
INSERT INTO Client VALUES ('CR76', 'John', 'Kay', '0207-774-5632', 'Flat', 425);
INSERT INTO Client VALUES ('CR56', 'Aline', 'Stewart', '0141-848-1825', 'Flat', 350);
INSERT INTO Client VALUES ('CR74', 'Mike', 'Ritchie', '01475-392178', 'House', 750);
INSERT INTO Client VALUES ('CR62', 'Mary', 'Tregear', '01224-196720', 'Flat', 600);

-- 6. Data Tabel Viewing
INSERT INTO Viewing VALUES ('CR56', 'PA14', TO_DATE('24-May-2004', 'DD-Mon-YYYY'), 'too small');
INSERT INTO Viewing VALUES ('CR76', 'PG4', TO_DATE('20-Apr-2004', 'DD-Mon-YYYY'), 'too remote');
INSERT INTO Viewing VALUES ('CR56', 'PG4', TO_DATE('26-May-2004', 'DD-Mon-YYYY'), NULL);
INSERT INTO Viewing VALUES ('CR62', 'PA14', TO_DATE('14-May-2004', 'DD-Mon-YYYY'), 'no dining room');
INSERT INTO Viewing VALUES ('CR56', 'PG36', TO_DATE('28-Apr-2004', 'DD-Mon-YYYY'), NULL);

-- 7. Data Tabel Registration
INSERT INTO Registration VALUES ('CR76', 'B005', 'SL41', TO_DATE('02-Jan-2004', 'DD-Mon-YYYY'));
INSERT INTO Registration VALUES ('CR56', 'B003', 'SG37', TO_DATE('11-Apr-2003', 'DD-Mon-YYYY'));
INSERT INTO Registration VALUES ('CR74', 'B003', 'SG37', TO_DATE('16-Nov-2002', 'DD-Mon-YYYY'));
INSERT INTO Registration VALUES ('CR62', 'B007', 'SA9', TO_DATE('07-Mar-2003', 'DD-Mon-YYYY'));
