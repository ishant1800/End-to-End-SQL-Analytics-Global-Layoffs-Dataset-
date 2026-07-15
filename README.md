This project demonstrates an end-to-end data engineering and analysis workflow using MySQL Community Server. The repository details the process of taking a raw, unformatted dataset regarding global company layoffs, executing strict data-cleaning protocols, and performing Exploratory Data Analysis (EDA) to isolate macroeconomic trends.

Key Steps Completed:

Data Cleaning & Stage Creation: Created staging tables to preserve raw data integrity, identified and removed duplicate records using window functions, and dropped irrelevant columns.

Standardization & Parsing: Used SQL string functions like TRIM to fix spacing, resolved inconsistencies in industry naming conventions, and standardized date formats for time-series analysis.

Null Value Handling: Populated missing data fields by joining tables against matching entity records and cleared unusable blank rows.

Exploratory Data Analysis (EDA): Wrote advanced SQL queries to isolate which industries, locations, and funding stages suffered the highest layoffs, tracking patterns over time.
