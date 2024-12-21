-- Create the database
create database db_final_project;
use db_final_project

-- Create the Department Table
create table departments (
	department_id int primary key,
	department_name varchar(100) unique not null,
	location varchar(100) not null,
	phone_extension varchar(10) not null
);


-- Create the Patient Table
create table patients (
	patient_id int primary key,
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	date_of_birth date not null,
	gender varchar(10) not null,
	address varchar(100) not null,
	phone_number varchar(20)  not null,
	email varchar(100) unique not null,
	emergency_contact_name varchar(100) not null,
	emergency_contact_phone varchar(20) not null
);

-- Create the Doctor Table
create table doctors (
	doctor_id int primary key,
	first_name varchar(100) not null,
	last_name varchar(100) not null,
	specialization varchar(100) not null,
	phone_number varchar(20) unique not null,
	email varchar(100) unique not null,
	department_id int not null,
	availability bit not null default 1,
	foreign key (department_id) REFERENCES departments(department_id)
);

-- Create the Appointment Table
create table appointments (
    appointment_id int primary key,
    patient_id int not null,
    doctor_id int not null,
    department_id int not null,
    appointment_date date not null,
    appointment_time time not null,
    status varchar(20) not null check (status IN ('Scheduled', 'Completed', 'Cancelled')),
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id),
    foreign key (department_id) references departments(department_id)
);

--Create the Medical Records Table
create table medical_records (
    record_id int primary key,
    patient_id int not null,
    doctor_id int not null,
    visit_date date,
    diagnosis text ,
    treatment_plan text,
    prescription text,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id)
);

-- Create the Medicine Table
create table medicine (
    medicine_id int primary key,
    medicine_name varchar(100) unique not null,
    manufacturer varchar(100) not null,
    stock_quantity int not null,
    price decimal(10, 2) not null
);

-- Create the Prescription Table
create table prescription (
    prescription_id int primary key,
    record_id int not null,
    medicine_id int ,
    dosage varchar(100) ,
    frequency varchar(100) ,
    duration varchar(100),
    foreign key (record_id) references medical_records(record_id),
    foreign key (medicine_id) references medicine(medicine_id)
);

-- Create the Billing Table
create table billings (
    billing_id int primary key,
    patient_id int not null,
    total_amount decimal(10, 2),
    payment_status varchar(10) not null check (payment_status IN ('Paid', 'Unpaid')),
    payment_date date ,
    payment_method varchar(20),
    foreign key (patient_id) references patients(patient_id)
);

-- Create the Staff Table
create table staffs (
    staff_id int primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    role varchar(100) not null,
    department_id int not null,
    phone_number varchar(20) unique not null,
    email varchar(100) unique not null,
    shift_hours varchar(20) not null,
    foreign key (department_id) references departments(department_id)
);

-- Create the Room Table
create table rooms (
    room_id int primary key,
    room_number varchar(10) unique not null,
    department_id int not null,
    room_type varchar(20) not null check (room_type in ('General', 'Private', 'ICU')),
    availability_status varchar(10) not null check (availability_status IN ('Available', 'Occupied')),
    foreign key (department_id) references departments(department_id)
);

-- Create the Room Assignment Table
create table room_assignment (
    assignment_id int primary key,
    room_id int not null,
	staff_id int not null,
    patient_id int not null,
    admission_date date not null,
    discharge_date date not null,
    foreign key (room_id) references rooms(room_id),
    foreign key (staff_id) references staffs(staff_id),
    foreign key (patient_id) references patients(patient_id)
);




-- Create admin users

CREATE LOGIN admin_user WITH PASSWORD = 'Lu12345*';
CREATE USER admin_user FOR LOGIN admin_user;

-- Grant full privileges to the admin user
ALTER ROLE db_owner ADD MEMBER admin_user;




-- Create role for  doctors, and administrator
CREATE ROLE readonly;
-- Grant SELECT privileges to the readonly role
GRANT SELECT  TO readonly;

-- Create role for Financial management
CREATE ROLE Financial_Management_role;
-- Grant SELECT privileges to the Financial_Management_role role
GRANT SELECT ON medicine TO Financial_Management_role;
GRANT SELECT ON billings TO Financial_Management_role;

-- Create role for Nurse
CREATE ROLE nurse_role;
-- Grant SELECT privileges to the Financial_Management_role role
GRANT SELECT ON rooms TO nurse_role;
GRANT SELECT ON room_assignment TO nurse_role;

-- Create normal users and add them to the  roles
CREATE LOGIN Nicholas WITH PASSWORD = 'user_password1';
CREATE USER Nicholas FOR LOGIN Nicholas;
ALTER ROLE readonly ADD MEMBER Nicholas;

CREATE LOGIN Rachel WITH PASSWORD = 'user_password2';
CREATE USER Rachel FOR LOGIN Rachel;
ALTER ROLE readonly ADD MEMBER Rachel;

CREATE LOGIN Ahmad WITH PASSWORD = 'user_password3';
CREATE USER Ahmad FOR LOGIN Ahmad;
ALTER ROLE Financial_Management_role ADD MEMBER Ahmad;

CREATE LOGIN Frank WITH PASSWORD = 'user_password4';
CREATE USER Frank FOR LOGIN Frank;
ALTER ROLE Financial_Management_role ADD MEMBER Frank;

CREATE LOGIN Henry WITH PASSWORD = 'user_password5';
CREATE USER Henry FOR LOGIN Henry;
ALTER ROLE nurse_role ADD MEMBER Henry;
