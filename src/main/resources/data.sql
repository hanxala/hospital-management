-- Insert Doctors
INSERT INTO doctors (name, specialization, department, consultation_fee, phone, email, available_days) VALUES
('Dr. Rajesh Sharma', 'Cardiologist', 'Cardiology', 800.00, '+91 9876543210', 'dr.rajesh@hospital.com', 'Mon, Wed, Fri'),
('Dr. Priya Menon', 'General Physician', 'Internal Medicine', 500.00, '+91 9876543211', 'dr.priya@hospital.com', 'Mon to Sat'),
('Dr. Vikram Joshi', 'Orthopedic Surgeon', 'Orthopedics', 900.00, '+91 9876543212', 'dr.vikram@hospital.com', 'Tue, Thu, Sat'),
('Dr. Ananya Roy', 'Pediatrician', 'Pediatrics', 600.00, '+91 9876543213', 'dr.ananya@hospital.com', 'Mon to Fri'),
('Dr. Farhan Siddiqui', 'Neurologist', 'Neurology', 1000.00, '+91 9876543214', 'dr.farhan@hospital.com', 'Mon, Wed, Sat');

-- Insert Lab Test Catalog
INSERT INTO lab_catalog (test_code, test_name, category, standard_fee, description) VALUES
('LAB-CBC', 'Complete Blood Count (CBC)', 'Hematology', 350.00, 'Evaluates overall health and detects broad range of disorders'),
('LAB-LIPID', 'Lipid Profile', 'Biochemistry', 650.00, 'Measures cholesterol and triglycerides'),
('LAB-XRAY-CH', 'Chest X-Ray PA View', 'Radiology', 450.00, 'Digital Radiography of chest cavity and lungs'),
('LAB-FBS', 'Fasting Blood Sugar (FBS)', 'Biochemistry', 150.00, 'Screening for prediabetes and diabetes'),
('LAB-LFT', 'Liver Function Test (LFT)', 'Biochemistry', 750.00, 'Tests proteins, liver enzymes, and bilirubin'),
('LAB-URI', 'Urine Routine & Microscopy', 'Pathology', 200.00, 'Physical, chemical, and microscopic urine analysis'),
('LAB-MRI-BR', 'Brain MRI with Contrast', 'Radiology', 4500.00, 'High-resolution magnetic resonance imaging of brain');

-- Insert Sample Patients
INSERT INTO patients (patient_uhid, first_name, last_name, age, gender, phone, email, blood_group, address, emergency_contact, status, medical_history) VALUES
('UHID-1001', 'Amit', 'Verma', 42, 'Male', '+91 9123456789', 'amit.verma@example.com', 'B+', 'Flat 302, Green Park, Mumbai', 'Pooja Verma (+91 9123456780)', 'ACTIVE', 'Hypertension since 2021'),
('UHID-1002', 'Sunita', 'Patil', 35, 'Female', '+91 9822334455', 'sunita.patil@example.com', 'O+', 'Plot 45, Shivaji Nagar, Pune', 'Ramesh Patil (+91 9822334450)', 'ACTIVE', 'None reported'),
('UHID-1003', 'Karan', 'Mehta', 28, 'Male', '+91 9711223344', 'karan.m@example.com', 'A+', 'Tower B, Galaxy Apts, Bangalore', 'Sonia Mehta (+91 9711223340)', 'ACTIVE', 'Mild Asthma'),
('UHID-1004', 'Deepa', 'Nair', 61, 'Female', '+91 9447788990', 'deepa.nair@example.com', 'AB+', 'House 12, MG Road, Kochi', 'Unni Nair (+91 9447788991)', 'ACTIVE', 'Type 2 Diabetes, Osteoarthritis');

-- Insert Sample Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, symptoms, diagnosis, prescription, consultation_fee, status, notes) VALUES
(1, 1, CURRENT_TIMESTAMP, 'Chest tightness, occasional breathlessness on exertion', 'Mild Angina Pectoris / Essential Hypertension', 'Tab Amlodipine 5mg OD, Tab Aspirin 75mg OD after lunch', 800.00, 'BILLED', 'Advised Lipid Profile and ECG'),
(2, 2, CURRENT_TIMESTAMP, 'High grade fever with chills, body ache for 3 days', 'Acute Viral Infection / Pyrexia of unknown origin', 'Tab Paracetamol 650mg TDS, Tab Cetirizine 10mg HS, ORS fluids', 500.00, 'BILLED', 'Recommended CBC and Urine routine examination'),
(3, 3, CURRENT_TIMESTAMP, 'Acute pain and swelling in right ankle after sports injury', 'Grade 2 Ankle Ligament Sprain', 'Crepe bandage support, Tab Aceclofenac-Paracetamol BD for 5 days, Cold compress', 900.00, 'COMPLETED', 'Advised X-Ray Right Ankle AP/Lateral');

-- Insert Sample Lab Orders
INSERT INTO lab_orders (patient_id, test_id, doctor_id, order_date, lab_fee, status, result_summary, reported_date) VALUES
(1, 2, 1, CURRENT_TIMESTAMP, 650.00, 'COMPLETED', 'Total Cholesterol: 215 mg/dL (Borderline High), Triglycerides: 180 mg/dL, HDL: 42 mg/dL', CURRENT_TIMESTAMP),
(1, 1, 1, CURRENT_TIMESTAMP, 350.00, 'COMPLETED', 'Hb: 14.2 g/dL, WBC: 7,500 /cumm, Platelets: 2.3 Lakhs', CURRENT_TIMESTAMP),
(2, 1, 2, CURRENT_TIMESTAMP, 350.00, 'COMPLETED', 'Hb: 12.0 g/dL, WBC: 11,200 /cumm (Mild Leukocytosis), Platelets: 1.8 Lakhs', CURRENT_TIMESTAMP),
(3, 3, 3, CURRENT_TIMESTAMP, 450.00, 'PENDING', 'Pending Technician Review', NULL);

-- Insert Sample Bill for Patient 1
INSERT INTO bills (bill_number, patient_id, consultation_charges, lab_charges, room_charges, pharmacy_charges, other_charges, subtotal, discount_percentage, discount_amount, tax_percentage, tax_amount, total_amount, paid_amount, balance_amount, payment_status, payment_mode, billing_date, remarks) VALUES
('BILL-2026-0001', 1, 800.00, 1000.00, 500.00, 320.00, 100.00, 2720.00, 5.00, 136.00, 5.00, 129.20, 2713.20, 2713.20, 0.00, 'PAID', 'UPI', CURRENT_TIMESTAMP, 'Full settlement received via GooglePay');

-- Insert Bill Items for Sample Bill 1
INSERT INTO bill_items (bill_id, item_type, item_description, unit_price, quantity, total_price) VALUES
(1, 'CONSULTATION', 'Doctor Consultation - Dr. Rajesh Sharma (Cardiology)', 800.00, 1, 800.00),
(1, 'LAB_TEST', 'Lipid Profile (Biochemistry)', 650.00, 1, 650.00),
(1, 'LAB_TEST', 'Complete Blood Count (CBC)', 350.00, 1, 350.00),
(1, 'ROOM', 'Day Care Observation Bed Charges', 500.00, 1, 500.00),
(1, 'PHARMACY', 'Prescription Medicines (Amlodipine + Aspirin)', 320.00, 1, 320.00),
(1, 'SERVICE', 'Hospital Registration & Nursing Charges', 100.00, 1, 100.00);

-- Insert Sample Bill for Patient 2
INSERT INTO bills (bill_number, patient_id, consultation_charges, lab_charges, room_charges, pharmacy_charges, other_charges, subtotal, discount_percentage, discount_amount, tax_percentage, tax_amount, total_amount, paid_amount, balance_amount, payment_status, payment_mode, billing_date, remarks) VALUES
('BILL-2026-0002', 2, 500.00, 350.00, 0.00, 180.00, 50.00, 1080.00, 0.00, 0.00, 5.00, 54.00, 1134.00, 500.00, 634.00, 'PARTIAL', 'CASH', CURRENT_TIMESTAMP, 'Partial advance cash payment made');

INSERT INTO bill_items (bill_id, item_type, item_description, unit_price, quantity, total_price) VALUES
(2, 'CONSULTATION', 'Doctor Consultation - Dr. Priya Menon (Internal Medicine)', 500.00, 1, 500.00),
(2, 'LAB_TEST', 'Complete Blood Count (CBC)', 350.00, 1, 350.00),
(2, 'PHARMACY', 'Emergency Fever Medication Pack', 180.00, 1, 180.00),
(2, 'SERVICE', 'OPD Administrative Service Fee', 50.00, 1, 50.00);

-- Insert Initial Audit Logs
INSERT INTO audit_logs (action, entity_name, entity_id, details, performed_by, timestamp) VALUES
('BILL_GENERATED', 'BILL', 'BILL-2026-0001', 'Generated bill for patient Amit Verma with Total: Rs. 2713.20', 'Billing Desk', CURRENT_TIMESTAMP),
('PAYMENT_PROCESSED', 'BILL', 'BILL-2026-0001', 'Settled full payment of Rs. 2713.20 via UPI', 'Cashier-1', CURRENT_TIMESTAMP),
('BILL_GENERATED', 'BILL', 'BILL-2026-0002', 'Generated bill for patient Sunita Patil with Total: Rs. 1134.00', 'Billing Desk', CURRENT_TIMESTAMP);

-- Insert Initial Performance Logs
INSERT INTO performance_logs (class_name, method_name, execution_time_ms, threshold_exceeded, timestamp) VALUES
('BillingServiceImpl', 'generateBill', 14, FALSE, CURRENT_TIMESTAMP),
('PatientServiceImpl', 'registerPatient', 8, FALSE, CURRENT_TIMESTAMP),
('DoctorConsultationServiceImpl', 'recordConsultation', 9, FALSE, CURRENT_TIMESTAMP);
