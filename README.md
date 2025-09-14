# PAN-Card-Validation

## Overview
This project focuses on cleaning, validating, and categorizing a dataset of Indian Permanent Account Numbers (PANs). The goal is to ensure each PAN adheres to the official format and classify it as either valid or invalid. The dataset is provided as an Excel file (PAN Number Validation Dataset.xlsx).

### Objective
- Clean the raw PAN dataset by handling missing values, duplicates, whitespace, and letter case.

- Validate each PAN number against strict format and sequencing rules.

- Categorize PANs into Valid or Invalid based on the validation.

- Generate a summary report detailing total records processed and counts of valid, invalid, and missing/incomplete PANs.

### Purpose
In regulatory and financial contexts, maintaining high data quality for PAN numbers is critical for accurate verification, fraud prevention, and auditing. This project addresses data inconsistencies, missing values, and format violations to deliver a clean, validated dataset that organizations can trust.

### Validation Requirements
For detailed validation rules and criteria applied to PAN numbers, please refer to the attached PDF document. It outlines the official format specifications, adjacency and sequence restrictions, and categorization guidelines used throughout this project.

### Project Significance
- Through this work, stakeholders gain a reliable, standardized PAN dataset, enabling:

- Enhanced data governance and compliance.

- Streamlined verification workflows.

- Accurate reporting and audit readiness.

This project demonstrates advanced data validation techniques coupled with SQL-based automation for robust data quality management in a professional environment.

## SQL Features and Custom Functions

### Custom Functions in SQL for Validation

This project demonstrates creating user-defined functions (UDFs) in SQL to:

- Validate PAN pattern rules.

- Check for adjacency and sequences in alphabets and digits.

- Handle string manipulations like trimming spaces and uppercasing.

- Using SQL functions allows encapsulating complex validation logic that can be reused across queries.

- Functions improve readability and maintainability, key qualities emphasized in professional environments.

### Reporting with SQL

- SQL queries aggregate and categorize data efficiently.

- We generated summary statistics using SQL COUNT(), GROUP BY, and conditional filtering.

- Reporting demonstrates proficiency in combining data validation and data summarization—valuable skills for data-driven roles.
