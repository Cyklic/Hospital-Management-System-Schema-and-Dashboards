------Average number of appointments per patient in the last 6 months
SELECT 
  COUNT(a.appointment_id) / COUNT(DISTINCT a.patient_id) AS avg_appointments
FROM 
  appointments a
WHERE 
  a.appointment_date >= DATEADD(MONTH, -18, GETDATE());


------Doctors with the highest patient load

SELECT 
  d.doctor_id, 
  CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
  COUNT(a.patient_id) AS patient_load
FROM 
  appointments a
  JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY 
  d.doctor_id, d.first_name, d.last_name
  Order by patient_load desc


------Departments handling the most patients

SELECT 
    dept.department_name, 
    COUNT(a.patient_id) AS total_patients
FROM 
    departments dept
JOIN 
    appointments a ON dept.department_id = a.department_id

	where a.status='Completed'
GROUP BY 
    dept.department_name
ORDER BY 
    total_patients DESC;



------Departments with the highest appointment cancellation rates
SELECT 
    dept.department_name, 
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancellations,
    (CAST(SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(a.appointment_id)) * 100 AS cancellation_rate
FROM 
    appointments a
JOIN 
    departments dept ON a.department_id = dept.department_id
GROUP BY 
    dept.department_name
ORDER BY 
    cancellation_rate DESC;


------Most requested time slots for appointments across all departments

	SELECT 
    
    dept.department_name,
    CONCAT(DATEPART(HOUR, a.appointment_time), ':', RIGHT('00' + CAST(DATEPART(MINUTE, a.appointment_time) AS VARCHAR), 2)) AS time_slot, 
    COUNT(a.appointment_id) AS total_appointments
FROM  
    appointments a
JOIN 
    departments dept ON a.department_id = dept.department_id
GROUP BY 
     dept.department_name, CONCAT(DATEPART(HOUR, a.appointment_time), ':', RIGHT('00' + CAST(DATEPART(MINUTE, a.appointment_time) AS VARCHAR), 2))
ORDER BY 
    total_appointments DESC;



---- Departments with highest appointment cancellation, completion, and scheduled rates (last  months)
SELECT 
    dept.department_name,
    SUM(CASE WHEN a.status = 'Cancelled' THEN 1 ELSE 0 END) AS cancellations,
    SUM(CASE WHEN a.status = 'Completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN a.status = 'Scheduled' THEN 1 ELSE 0 END) AS scheduled
FROM 
    appointments a
JOIN 
    departments dept ON a.department_id = dept.department_id
WHERE 
    a.appointment_date >= DATEADD(MONTH, -15, GETDATE())
GROUP BY 
    dept.department_name;


-----Total revenue generated from different departments over the years

SELECT 
  d.department_name, 
  SUM(b.total_amount) AS total_revenue
FROM 
  billings b
  JOIN appointments a  ON a.patient_id = b.patient_id
  join departments d on a.department_id= d.department_id
  where a.status='Completed'

GROUP BY 
  d.department_name
  Order By total_revenue desc


  -----Top 5 most prescribed medicines 
  SELECT TOP 5
  m.medicine_name, 
  COUNT(p.prescription_id) AS prescription_count
FROM 
  prescription p
  JOIN medicine m ON p.medicine_id = m.medicine_id

GROUP BY 
  m.medicine_name
ORDER BY 
  prescription_count DESC 

 -----Most frequently used payment methods
 SELECT 
    b.payment_method, 
    COUNT(b.billing_id) AS usage_count
FROM 
    billings b
	where  b.payment_method is not null
GROUP BY 
    b.payment_method
ORDER BY 
    usage_count DESC;

----What is the gender distribution of patients in each department?
SELECT 
    d.department_name,
    p.gender,
    COUNT(p.patient_id) AS patient_count
FROM 
    patients p
JOIN 
    appointments a ON p.patient_id = a.patient_id
JOIN 
    departments d ON a.department_id = d.department_id
	
GROUP BY 
    d.department_name, p.gender
Order by d.department_name


-----Which gender contributed the most to total revenue?

SELECT 
    p.gender,
    SUM(b.total_amount) AS total_revenue
FROM 
   
	billings b 
JOIN 
    patients p ON p.patient_id = b.patient_id

GROUP BY 
    p.gender
ORDER BY 
    total_revenue DESC;



------Which months have the highest appointment rates?

	SELECT 
    DATENAME(MONTH, a.appointment_date) AS appointment_month,
    COUNT(a.appointment_id) AS total_appointments
FROM 
    appointments a
GROUP BY 
    DATENAME(MONTH, a.appointment_date), MONTH(a.appointment_date)
ORDER BY 
    total_appointments DESC;


----Percentage of rooms (ICU, General, Private) occupied

SELECT 
    r.room_type,
    SUM(CASE WHEN r.availability_status = 'Occupied' THEN 1 ELSE 0 END) AS occupied_rooms,
    COUNT(r.room_id) AS total_rooms,
    (CAST(SUM(CASE WHEN r.availability_status = 'Occupied' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(r.room_id)) * 100 AS occupancy_percentage
FROM 
    rooms r

GROUP BY 
    r.room_type;


-----Doctors who prescribe the highest number of medicines
SELECT 
    CONCAT(d.first_name, ' ' , d.last_name) AS doctor_name, 
    COUNT(p.prescription_id) AS total_prescriptions
FROM 
    doctors d
JOIN 
medical_records m on m.doctor_id= d.doctor_id
JOIN
    prescription p ON m.record_id= p.record_id
GROUP BY 
     d.first_name, d.last_name
ORDER BY 
    total_prescriptions DESC;


----How many rooms are occupied vs. available
SELECT 
    r.room_type,
    SUM(CASE WHEN r.availability_status= 'Occupied' THEN 1 ELSE 0 END) AS occupied_rooms,
    SUM(CASE WHEN r.availability_status = 'Available' THEN 1 ELSE 0 END) AS available_rooms
FROM 
    rooms r
GROUP BY 
    r.room_type;

----Which is the most expensive medicine
SELECT 
    m.medicine_name,
    SUM(price) AS Price
FROM 
    medicine m
GROUP BY 
    m.medicine_name
Order By SUM(price) DESC

