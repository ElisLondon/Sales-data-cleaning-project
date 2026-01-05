# E-Commerce Sales Data Cleaning Project
## Cleaning sales data for future analysis

### Goal:
This project focuses on transforming a **messy sales dataset** containing issues such as missing values, inconsistent date formats, duplicate records, and incorrect data types. The goal was to build a **reproducible SQL cleaning pipeline** that standardises the dataset, ensures accuracy, and prepares it for downstream analysis.

### Entity Relationship Diagram:

<img width="940" height="435" alt="image" src="https://github.com/user-attachments/assets/346b3786-1ec9-4108-ae18-1b3c4d30b56f" />



### Cleaning Steps:
All cleaning steps were implemented in a reusable SQL pipeline, allowing the process to be applied to future datasets with minimal modification.
1) Identified and removed duplicate transactions
2) Standardised inconsistent data entries and date formats
3) Converted incorrect data types to appropriate formats
4) Handled missing values and nulls using domain logic
5) Validated totals and cross checked against expected ranges

<img width="250" height="677" alt="image" src="https://github.com/user-attachments/assets/7ca380e8-9345-47b9-b0ae-c286427c8de7" />


### Data Summary:
| Metric | Before Cleaning | After Cleaning |
|--------|------------------|----------------|
| Total Rows | 21,864 | 21,795 |
| Duplicate Rows | 54 | 0 |
| Missing Values | 13% | 7% |
| Product Label Variants | 61 inconsistencies | Fully standardised |
| Date Formats | 4 formats | 1 format |
| Data Type Issues | Several incorrect types | All corrected |


### Results:
- Reduced 69 duplicate rows
- Standardised 61 inconsistent product labels
- Fixed 4 different date formats
- Improved data completeness from 87% to 93%
- Produced a clean dataset ready for KPI analysis

### Summary:
This project demonstrates my ability to work with imperfect real world data, design cleaning logic, and building reusable cleaning processes that support accurate analysis. It highlights my SQL skils, attention to detail, and an understanding of data quality best practices that I can bring to more complex datasets.

### Planned next steps:
- Perform EDA on the cleaned dataset to explore trends
- Create a report of the analysis and infer recommendations that could be made to specific company teams to help increase revenue
- Build a Tableau dashboard to highlight the key findings for stakeholders
- Parametise the SQL pipeline for different datasets
- Add logging and error handling for improved robustness


