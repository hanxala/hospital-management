# Hospital Billing and Patient Management System

A comprehensive, enterprise-grade **Spring Boot** web application with **JSP interface**, **Spring JDBC**, and **Spring AOP (Aspect-Oriented Programming)** designed to run smoothly in **Eclipse IDE** and standalone environments.

---

## 🌟 Key Features

1. **Patient Registration & Electronic Health Records (EHR)**:
   - Auto-generated Unique Health ID (e.g. `UHID-1001`).
   - Demographics (Name, Age, Gender, Contact, Blood Group, Address, Emergency Contact).
   - Past medical history, allergies, and chronic illness records.
   - Comprehensive 360-degree Patient Profile with chronological consultations, lab tests, and billing history.

2. **Doctor Consultation Management**:
   - Outpatient consultation booking with specialist doctors (Cardiologist, Physician, Orthopedics, Pediatrics, Neurology).
   - Clinical symptom recording, doctor diagnosis, and digital prescriptions.
   - Automatic retrieval of doctor's standard consultation fees.

3. **Laboratory Investigations & Charges**:
   - Diagnostic investigation ordering linked to patient profiles.
   - Master catalog of standard diagnostic tests (CBC, Lipid Profile, Chest X-Ray, Blood Sugar, LFT, MRI Brain).
   - Specimen status tracking (`PENDING` -> `COMPLETED`) with clinical result summary reporting.

4. **Integrated Itemized Billing & Invoicing Desk**:
   - **One-Click Draft Bill Generator**: Aggregates all unbilled doctor consultations, pending lab test orders, room/bed charges, and service fees for any patient.
   - **Real-Time Financial Calculations**: Subtotal, percentage discounts, healthcare taxes (GST), and net balances.
   - **Multi-Mode Payment Settlements**: Cash, UPI / QR, Credit/Debit Card, Net Banking, and Insurance TPA.
   - **Official Printable Tax Invoice**: Hospital header, GSTIN, itemized tariff table, payment status watermarks (`PAID`, `PARTIAL`, `UNPAID`), and print button (`window.print()`).

5. **Spring AOP (Aspect-Oriented Programming)**:
   - **Billing Audit Aspect (`BillingAuditAspect.java`)**:
     - Uses `@AfterReturning` advice intercepting billing transactions (`generateBill`, `processPayment`).
     - Logs operation name, patient ID, bill amount, timestamp, and audit details to SLF4J logger and database table `audit_logs` using Spring JDBC.
   - **Service Performance Monitor Aspect (`ServicePerformanceAspect.java`)**:
     - Uses `@Around` advice with `ProceedingJoinPoint` wrapping service methods in `com.hospital.service.*`.
     - Measures method execution duration in milliseconds.
     - Automatically flags slow queries/methods exceeding the performance threshold (configurable in `application.properties`) into `performance_logs`.
   - **Dedicated Live AOP Console (`/aop-monitor`)**: Live audit stream and service latency monitor.

6. **Spring JDBC Persistence (`JdbcTemplate`)**:
   - Native SQL performance with clean Data Access Object (DAO) pattern.
   - Auto-generated primary key extraction via `GeneratedKeyHolder`.
   - In-memory embedded H2 database (`jdbc:h2:mem:hospitaldb`) with pre-seeded sample patients, doctors, tests, and bills.
   - Built-in H2 Web Console at `/h2-console`.

---

## 🚀 Running in Eclipse IDE (Step-by-Step)

The project includes pre-configured Eclipse project descriptor files (`.project`, `.classpath`, and `.settings/`) compatible with Eclipse 2023 / 2024.

### Option 1: Import as Existing Maven Project (Recommended)
1. Launch **Eclipse IDE**.
2. Select your workspace: `D:\MCA\java-practical`.
3. Click **File** &rarr; **Import...**
4. Expand **Maven** &rarr; select **Existing Maven Projects** &rarr; click **Next**.
5. Click **Browse...** and select the folder:
   ```
   D:\MCA\java-practical\java-mini
   ```
6. Check the checkbox for `pom.xml` &rarr; click **Finish**.
7. Eclipse m2e will automatically download dependencies and build the workspace.

### Option 2: Import as Existing Project
1. In Eclipse, click **File** &rarr; **Import...**
2. Expand **General** &rarr; select **Existing Projects into Workspace** &rarr; click **Next**.
3. Choose **Select root directory** &rarr; Browse to `D:\MCA\java-practical\java-mini`.
4. Click **Finish**.

### Running the Application in Eclipse:
1. In Eclipse **Project Explorer**, navigate to:
   ```
   src/main/java/com/hospital/HospitalBillingApplication.java
   ```
2. **Right-click** on `HospitalBillingApplication.java` &rarr; **Run As** &rarr; **Java Application** (or **Spring Boot App** if Spring Tools 4 is installed).
3. The embedded Tomcat server will start on port `8080`.
4. Open your web browser and visit:
   ```
   http://localhost:8080/
   ```

---

## 💻 Running from Command Line

You can also run the application using the included `run.bat` script or Maven:

```bat
cd D:\MCA\java-practical\java-mini
run.bat
```

Or via Maven directly:
```bash
mvn spring-boot:run
```

---

## 🌐 Application URL Endpoints

| Page / Feature | URL | Description |
| :--- | :--- | :--- |
| **Executive Dashboard** | `http://localhost:8080/` or `/dashboard` | KPI cards, revenue metrics, recent invoices, and live AOP audit feed |
| **Patient Directory** | `http://localhost:8080/patients` | Search, filter, and list all patient records |
| **Register Patient** | `http://localhost:8080/patients/register` | New patient registration form with auto UHID generation |
| **Patient 360 Profile** | `http://localhost:8080/patients/view/{id}` | Full patient history, consultations, lab investigations, bills |
| **Doctor Consultations** | `http://localhost:8080/consultations` | Consultation registry and fee breakdown |
| **Record Consultation** | `http://localhost:8080/consultations/new` | Record doctor notes, diagnosis, and prescription |
| **Laboratory Desk** | `http://localhost:8080/lab` | Diagnostic orders, test status, and lab catalog |
| **Order Lab Test** | `http://localhost:8080/lab/order` | Place orders for blood tests, X-rays, MRI, etc. |
| **Billing & Invoices** | `http://localhost:8080/billing` | All generated bills and financial receivables |
| **Generate New Bill** | `http://localhost:8080/billing/new` | Itemized bill generator aggregating unbilled consults & lab tests |
| **Printable Tax Invoice** | `http://localhost:8080/billing/invoice/{billNo}` | Official tax receipt with print styling and payment settlement |
| **AOP Monitor Console** | `http://localhost:8080/aop-monitor` | Live billing audit logs & execution time performance monitor |
| **H2 Database Console** | `http://localhost:8080/h2-console` | In-browser SQL console (`JDBC URL: jdbc:h2:mem:hospitaldb`, `User: sa`, `Password: `) |

---

## 🏗️ Project Architecture & Directory Structure

```
d:\MCA\java-practical\java-mini\
├── .settings/                         # Eclipse project preferences
├── .classpath                         # Eclipse classpath descriptor
├── .project                           # Eclipse project descriptor
├── pom.xml                            # Maven dependencies & plugins
├── run.bat                            # Instant startup batch script
├── src/
│   ├── main/
│   │   ├── java/com/hospital/
│   │   │   ├── HospitalBillingApplication.java   # Spring Boot Main Entry
│   │   │   ├── aop/
│   │   │   │   ├── BillingAuditAspect.java       # AOP Aspect for billing audit
│   │   │   │   └── ServicePerformanceAspect.java # AOP Aspect for execution time
│   │   │   ├── controller/
│   │   │   │   ├── DashboardController.java
│   │   │   │   ├── PatientController.java
│   │   │   │   ├── DoctorConsultationController.java
│   │   │   │   ├── LaboratoryController.java
│   │   │   │   ├── BillingController.java
│   │   │   │   └── AopMonitoringController.java
│   │   │   ├── dao/
│   │   │   │   ├── PatientDao.java & PatientDaoImpl.java
│   │   │   │   ├── DoctorDao.java & DoctorDaoImpl.java
│   │   │   │   ├── ConsultationDao.java & ConsultationDaoImpl.java
│   │   │   │   ├── LabDao.java & LabDaoImpl.java
│   │   │   │   ├── BillingDao.java & BillingDaoImpl.java
│   │   │   │   ├── AuditLogDao.java & AuditLogDaoImpl.java
│   │   │   │   └── PerformanceLogDao.java & PerformanceLogDaoImpl.java
│   │   │   ├── model/
│   │   │   │   ├── Patient.java
│   │   │   │   ├── Doctor.java
│   │   │   │   ├── Consultation.java
│   │   │   │   ├── LabTestCatalog.java
│   │   │   │   ├── LabOrder.java
│   │   │   │   ├── Bill.java
│   │   │   │   ├── BillItem.java
│   │   │   │   ├── AuditLog.java
│   │   │   │   ├── PerformanceLog.java
│   │   │   │   └── DashboardStats.java
│   │   │   └── service/
│   │   │       ├── PatientService.java & PatientServiceImpl.java
│   │   │       ├── ConsultationService.java & ConsultationServiceImpl.java
│   │   │       ├── LaboratoryService.java & LaboratoryServiceImpl.java
│   │   │       ├── BillingService.java & BillingServiceImpl.java
│   │   │       └── MonitoringService.java & MonitoringServiceImpl.java
│   │   ├── resources/
│   │   │   ├── application.properties  # Ports, JSP paths, H2 config & AOP threshold
│   │   │   ├── schema.sql              # DDL table creation scripts
│   │   │   └── data.sql                # Seed clinical, diagnostic, & billing data
│   │   └── webapp/WEB-INF/jsp/
│   │       ├── common/
│   │       │   ├── header.jsp          # Bootstrap 5 & CSS
│   │       │   ├── navbar.jsp          # Navigation Bar
│   │       │   └── footer.jsp          # System status footer
│   │       ├── dashboard.jsp           # Main dashboard
│   │       ├── patient-list.jsp        # Patient table & search
│   │       ├── patient-form.jsp        # Patient registration / edit
│   │       ├── patient-view.jsp        # 360-degree patient profile
│   │       ├── consultation-list.jsp   # Doctor consultations table
│   │       ├── consultation-form.jsp   # Consultation entry form
│   │       ├── lab-list.jsp            # Lab orders & test catalog
│   │       ├── lab-form.jsp            # Lab investigation ordering
│   │       ├── billing-list.jsp        # Invoice summary table
│   │       ├── billing-select-patient.jsp # Patient picker for billing
│   │       ├── billing-form.jsp        # Real-time draft invoice builder
│   │       ├── billing-invoice.jsp     # Printable Tax Receipt & payment modal
│   │       └── aop-monitor.jsp         # AOP live audit trail & latency metrics
│   └── test/java/com/hospital/
│       └── HospitalBillingApplicationTests.java # Context, DAO, and AOP verification
```

---

## 🛡️ Spring AOP Implementation Details

### 1. Billing Audit Aspect (`BillingAuditAspect.java`)
```java
@Pointcut("execution(* com.hospital.service.BillingService.generateBill(..))")
public void billGenerationPointcut() {}

@AfterReturning(pointcut = "billGenerationPointcut()", returning = "result")
public void auditBillGeneration(JoinPoint joinPoint, Object result) {
    if (result instanceof Bill bill) {
        // Logs billing activity and inserts record into database table audit_logs via Spring JDBC
    }
}
```

### 2. Service Performance Aspect (`ServicePerformanceAspect.java`)
```java
@Around("execution(* com.hospital.service..*(..)) && !execution(* com.hospital.service.MonitoringService..*(..))")
public Object monitorExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
    long startTime = System.currentTimeMillis();
    Object result = joinPoint.proceed();
    long duration = System.currentTimeMillis() - startTime;
    // Persists execution latency into performance_logs table
    return result;
}
```

---

## 🗄️ Database Schema & Sample Data

The application automatically initializes the H2 in-memory database on startup via:
- `schema.sql`: creates `patients`, `doctors`, `consultations`, `lab_catalog`, `lab_orders`, `bills`, `bill_items`, `audit_logs`, and `performance_logs`.
- `data.sql`: pre-loads 5 specialist doctors, 7 standard diagnostic tests, 4 realistic patients, initial consultations, lab tests, and sample invoices with payments.
