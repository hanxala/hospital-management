-- Drop existing tables to ensure clean initialization
DROP TABLE IF EXISTS bill_items;
DROP TABLE IF EXISTS bills;
DROP TABLE IF EXISTS lab_orders;
DROP TABLE IF EXISTS lab_catalog;
DROP TABLE IF EXISTS consultations;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS performance_logs;

-- Patient Registration Table
CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_uhid VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    blood_group VARCHAR(10),
    address VARCHAR(255),
    emergency_contact VARCHAR(100),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    medical_history TEXT
);

-- Doctors Table
CREATE TABLE doctors (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    consultation_fee DECIMAL(10,2) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    available_days VARCHAR(100)
);

-- Doctor Consultation Records
CREATE TABLE consultations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    consultation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    symptoms TEXT,
    diagnosis TEXT,
    prescription TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'COMPLETED',
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Laboratory Test Catalog (Master)
CREATE TABLE lab_catalog (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_code VARCHAR(50) UNIQUE NOT NULL,
    test_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    standard_fee DECIMAL(10,2) NOT NULL,
    description VARCHAR(255)
);

-- Laboratory Orders and Charges
CREATE TABLE lab_orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    test_id BIGINT NOT NULL,
    doctor_id BIGINT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lab_fee DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDING',
    result_summary TEXT,
    reported_date TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES lab_catalog(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Billing and Invoicing
CREATE TABLE bills (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bill_number VARCHAR(50) UNIQUE NOT NULL,
    patient_id BIGINT NOT NULL,
    consultation_charges DECIMAL(10,2) DEFAULT 0.00,
    lab_charges DECIMAL(10,2) DEFAULT 0.00,
    room_charges DECIMAL(10,2) DEFAULT 0.00,
    pharmacy_charges DECIMAL(10,2) DEFAULT 0.00,
    other_charges DECIMAL(10,2) DEFAULT 0.00,
    subtotal DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    tax_percentage DECIMAL(5,2) DEFAULT 0.00,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    balance_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(30) DEFAULT 'UNPAID',
    payment_mode VARCHAR(50) DEFAULT 'CASH',
    billing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- Detailed Items on Each Bill
CREATE TABLE bill_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bill_id BIGINT NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    item_description VARCHAR(255) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 1,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES bills(id) ON DELETE CASCADE
);

-- AOP Audit Log Table (Tracks Billing Operations and Transactions)
CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(100) NOT NULL,
    entity_name VARCHAR(100) NOT NULL,
    entity_id VARCHAR(100),
    details TEXT NOT NULL,
    performed_by VARCHAR(100) DEFAULT 'STAFF',
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AOP Performance Log Table (Monitors Service Execution Times)
CREATE TABLE performance_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(150) NOT NULL,
    method_name VARCHAR(100) NOT NULL,
    execution_time_ms BIGINT NOT NULL,
    threshold_exceeded BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
