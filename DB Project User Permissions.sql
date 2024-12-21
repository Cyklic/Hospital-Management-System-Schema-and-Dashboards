-- Create admin users

CREATE LOGIN admin_user WITH PASSWORD = 'Lu12345*';
CREATE USER admin_user FOR LOGIN admin_user;

-- Grant full privileges to the admin user
ALTER ROLE db_owner ADD MEMBER admin_user;




-- Create role for  doctors, and administrator
CREATE ROLE readonly;
-- Grant SELECT privileges to the readonly role
GRANT SELECT ON db_final_project TO readonly;

-- Create role for Financial management
CREATE ROLE Financial_Management_role;
-- Grant SELECT privileges to the Financial_Management_role role
GRANT SELECT ON db_final_project.medicine,db_final_project.billings TO Financial_Management_role;

-- Create role for Nurse
CREATE ROLE nurse_role;
-- Grant SELECT privileges to the Financial_Management_role role
GRANT SELECT ON db_final_project.room,db_final_project.room_assignment TO nurse_role;



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
ALTER ROLE nurse_role ADD MEMBER Henry;