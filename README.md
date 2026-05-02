# 🧠 SQL Database Projects Portfolio

![SQL](https://img.shields.io/badge/SQL-Database-blue?style=for-the-badge&logo=mysql&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-Relational_DB-orange?style=for-the-badge&logo=mysql&logoColor=white)
![Database Design](https://img.shields.io/badge/Database%20Design-ERD%20%7C%20Normalization-purple?style=for-the-badge)
![Analytics](https://img.shields.io/badge/Analytics-Queries%20%7C%20Reports-green?style=for-the-badge)
![Portfolio](https://img.shields.io/badge/Portfolio-Interview%20Ready-red?style=for-the-badge)

---

## 📌 About This Repository

This repository contains a collection of **real-world SQL database projects** designed to demonstrate strong skills in:

- Database design
- Table creation
- Primary and foreign key relationships
- SQL joins
- Aggregations
- Subqueries
- Business reporting queries
- Data analysis using SQL

Each project is built around a practical business scenario and includes structured tables, sample data, and useful SQL queries to solve real problems.



# 🚀 Featured SQL Projects

## 1. 🍔 Online Food Delivery Analytics System

![Food Delivery](https://img.shields.io/badge/Project-Food%20Delivery%20Analytics-ff6b35?style=for-the-badge)
![Revenue Analysis](https://img.shields.io/badge/Focus-Revenue%20%26%20Orders-green?style=for-the-badge)

### 📖 Project Overview

The **Online Food Delivery Analytics System** is designed to manage customers, restaurants, food orders, menu items, delivery partners, payments, and delivery status.

This project helps analyze how a food delivery business performs across restaurants, customers, food items, revenue, and delivery efficiency.

### 🧩 Key Features

- Customer and restaurant management
- Menu item tracking
- Food order management
- Delivery partner assignment
- Payment tracking
- Revenue analysis
- Popular food item analysis
- Delivery performance reporting

### 🗂️ Main Tables

- Customers
- Restaurants
- Menu_Items
- Orders
- Order_Items
- Delivery_Partners
- Payments

### 📊 Business Questions Answered

- Which restaurants generated the most revenue?
- Which customers placed the most orders?
- Which food items are most popular?
- How much total revenue was generated?
- Which delivery partners completed the most deliveries?
- Which orders are pending, delivered, or cancelled?

### 🧠 Skills Demonstrated

```sql
JOINS
GROUP BY
ORDER BY
SUM()
COUNT()
HAVING
SUBQUERIES
AGGREGATE FUNCTIONS
---



## 2. ⚡ Electric Vehicle Charging Station Management System

![EV Charging](https://img.shields.io/badge/Project-EV%20Charging%20System-00b894?style=for-the-badge)
![Energy Tracking](https://img.shields.io/badge/Focus-Energy%20%26%20Billing-blue?style=for-the-badge)

### 📖 Project Overview

The **Electric Vehicle Charging Station Management System** manages EV users, charging stations, charging slots, vehicles, charging sessions, electricity usage, and payment details.

This project is useful for understanding how EV charging companies monitor usage, revenue, station availability, and customer activity.

### 🧩 Key Features

- EV customer management
- Vehicle registration
- Charging station tracking
- Charging slot availability
- Charging session records
- Electricity consumption tracking
- Payment and billing analysis

### 🗂️ Main Tables

- EV_Users
- Vehicles
- Charging_Stations
- Charging_Slots
- Charging_Sessions
- Payments

### 📊 Business Questions Answered

- Which charging station generated the most revenue?
- Which users charged their vehicles most frequently?
- How much electricity was consumed overall?
- Which charging slots are most used?
- What is the average charging duration?
- Which stations have high demand?

### 🧠 Skills Demonstrated

```sql
FOREIGN KEYS
DATE FUNCTIONS
SUM()
AVG()
COUNT()
INNER JOIN
GROUP BY
BUSINESS REPORTING
```



## 3. 🛡️ Cybersecurity Incident Tracking System

![Cybersecurity](https://img.shields.io/badge/Project-Cybersecurity%20Incident%20Tracking-red?style=for-the-badge)
![Security Analytics](https://img.shields.io/badge/Focus-Threat%20Monitoring-black?style=for-the-badge)

### 📖 Project Overview

The **Cybersecurity Incident Tracking System** is designed to record and monitor security incidents, affected systems, severity levels, assigned analysts, investigation status, and resolution actions.

This project simulates how companies track cyber threats such as malware attacks, phishing attempts, unauthorized access, and data breaches.

### 🧩 Key Features

- Incident logging
- Threat category tracking
- Severity classification
- Analyst assignment
- Affected system monitoring
- Investigation status tracking
- Resolution and response reporting

### 🗂️ Main Tables

- Security_Incidents
- Threat_Types
- Affected_Systems
- Security_Analysts
- Incident_Assignments
- Resolution_Reports

### 📊 Business Questions Answered

- How many incidents occurred by threat type?
- Which incidents are high severity?
- Which analysts handled the most incidents?
- Which systems are most frequently affected?
- How many incidents are unresolved?
- What is the average resolution time?

### 🧠 Skills Demonstrated

```sql
CASE STATEMENTS
FILTERING
JOINS
COUNT()
GROUP BY
STATUS-BASED REPORTING
INCIDENT ANALYSIS
```



## 4. 🏥 Hospital Emergency Room Management System

![Hospital](https://img.shields.io/badge/Project-Hospital%20Emergency%20Room-0984e3?style=for-the-badge)
![Healthcare](https://img.shields.io/badge/Focus-Patients%20%26%20Emergency%20Care-green?style=for-the-badge)

### 📖 Project Overview

The **Hospital Emergency Room Management System** manages emergency patients, doctors, nurses, rooms, treatment details, admission status, and billing records.

This project represents a real-world healthcare database where emergency cases must be tracked quickly and accurately.

### 🧩 Key Features

- Emergency patient registration
- Doctor and nurse assignment
- Room allocation
- Treatment tracking
- Patient priority management
- Billing management
- Emergency case reporting

### 🗂️ Main Tables

- Patients
- Doctors
- Nurses
- Emergency_Cases
- Rooms
- Treatments
- Bills

### 📊 Business Questions Answered

- How many emergency cases were handled?
- Which doctors treated the most patients?
- Which patients are admitted or discharged?
- What are the most common emergency types?
- How much billing revenue was generated?
- Which rooms are currently occupied?

### 🧠 Skills Demonstrated

```sql
RELATIONAL DESIGN
MULTI-TABLE JOINS
WHERE CONDITIONS
AGGREGATIONS
PATIENT REPORTING
HEALTHCARE ANALYTICS
```



## 5. 🤖 Warehouse Robot Inventory Management System

![Warehouse Robot](https://img.shields.io/badge/Project-Warehouse%20Robot%20Inventory-6c5ce7?style=for-the-badge)
![Automation](https://img.shields.io/badge/Focus-Automation%20%26%20Inventory-orange?style=for-the-badge)

### 📖 Project Overview

The **Warehouse Robot Inventory Management System** manages warehouse robots, inventory items, storage zones, robot tasks, stock movement, and task completion status.

This project shows how SQL can be used in automation-based inventory systems where robots help move, pick, and organize stock.

### 🧩 Key Features

- Robot management
- Inventory item tracking
- Warehouse zone management
- Robot task assignment
- Stock movement tracking
- Task completion monitoring
- Inventory availability reporting

### 🗂️ Main Tables

- Robots
- Inventory_Items
- Warehouse_Zones
- Robot_Tasks
- Stock_Movements
- Task_Status

### 📊 Business Questions Answered

- Which robots completed the most tasks?
- Which warehouse zones have the highest stock movement?
- Which items are low in stock?
- Which robot tasks are pending?
- How many items were moved between zones?
- Which robots are idle, active, or under maintenance?

### 🧠 Skills Demonstrated

```sql
INVENTORY QUERIES
JOIN OPERATIONS
TASK STATUS TRACKING
COUNT()
SUM()
GROUP BY
WAREHOUSE ANALYTICS
```



# 🛠️ Technologies Used

![SQL](https://img.shields.io/badge/SQL-Structured%20Query%20Language-blue?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-Database-orange?style=for-the-badge&logo=mysql&logoColor=white)
![DBMS](https://img.shields.io/badge/DBMS-Relational%20Database-purple?style=for-the-badge)
![VS Code](https://img.shields.io/badge/VS%20Code-Code%20Editor-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)

---

# 📂 Repository Structure

```text
SQL-Projects/
│
├── Online Food Delivery Analytics System/
│   └── solution.sql
│
├── Electric Vehicle Charging Station Management System/
│   └── solution.sql
│
├── Cybersecurity Incident Tracking System/
│   └── solution.sql
│
├── Hospital Emergency Room Management System/
│   └── solution.sql
│
├── Warehouse Robot Inventory Management System/
│   └── solution.sql
│
└── README.md
```

---

# 📈 SQL Concepts Covered

| Concept | Used In Projects |
|---|---|
| Database Design | All projects |
| Primary Keys | All projects |
| Foreign Keys | All projects |
| Joins | All projects |
| Aggregations | All projects |
| Grouping Data | All projects |
| Filtering Records | All projects |
| Business Reports | All projects |
| Analytical Queries | All projects |
| Real-world Scenarios | All projects |

---

# 💡 Why These Projects Are Valuable

These projects are not just basic SQL practice. They are designed around real business systems such as food delivery, EV charging, cybersecurity, healthcare, and warehouse automation.

They show the ability to:

- Convert real-world problems into database tables
- Design normalized relational schemas
- Write useful analytical SQL queries
- Generate business insights from structured data
- Build interview-ready database projects

---

# 🎯 Best For

This repository is useful for:

- SQL portfolio building
- College projects
- DBMS practicals
- Interview preparation
- Resume strengthening
- Database design practice



# 📌 Highlighted Skills

```text
SQL Database Design
Relational Database Management
Data Modeling
Joins and Aggregations
Business Query Writing
Analytical Reporting
Real-world Problem Solving
```



# 👨‍💻 Author

**Atharva Kedar**

![GitHub](https://img.shields.io/badge/GitHub-AtharvaKedar123-black?style=for-the-badge&logo=github)
![SQL Portfolio](https://img.shields.io/badge/SQL-Portfolio%20Projects-blue?style=for-the-badge)



# ⭐ Final Note

This repository represents a collection of practical SQL projects built to strengthen database design, analytical thinking, and query-writing skills.

If you find these projects useful, feel free to star the repository.
