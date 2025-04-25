# 📊 Phase 1: Data Cleaning - Amazon Fine Food Reviews (SQL)

This phase focuses on **cleaning and preparing the Amazon Fine Food Reviews dataset** using SQL. The goal is to demonstrate skills in cleaning messy real-world datasets, preparing them for further analysis or machine learning tasks.

---

## 📌 Dataset Overview

- **Source:** [Amazon Fine Food Reviews Dataset](https://www.kaggle.com/datasets/snap/amazon-fine-food-reviews)
- **Size:** 568,454 reviews
- **Columns:**
  - `Id`, `ProductId`, `UserId`, `ProfileName`, `HelpfulnessNumerator`, `HelpfulnessDenominator`, `Score`, `Time`, `Summary`, `Text`

---

## 🧹 Cleaning Steps Performed

> The cleaning was done using Microsoft SQL Server (T-SQL).

### 1. Converted Unix Timestamps to Readable Dates
Added a new `Date` column by converting the `Time` column from Unix timestamp to a readable date format. Only the date was retained since the time component was zero for all entries. The original `Time` column was dropped after the conversion.

### 2. Remove Null or empty values
Checked the dataset for null values and empty columns, but none were found, ensuring data completeness and consistency.

### 3. Trim leading and trailing whitespace
Trimmed leading and trailing whitespaces from all text-based columns using `LTRIM()` and `RTRIM()` functions. All rows were affected, confirming the presence of extra spaces in the original data.

### 4. Removed Duplicate Reviews
Identified 1,463 duplicate entries where `UserId`, `ProductId`, `ProfileName`, `Score`, `Summary`, and `Text` were identical. Removed 908 duplicates, retaining only one unique record per group.

### 5. Detection of non-ASCII/encoding issues
Checked for non-ASCII characters and found none (0 rows). Upon deeper inspection, we discovered HTML tags in the `Text` column.
- A total of 142,354 rows contained HTML tags.
- Since HTML tags do not contribute to sentiment understanding and only add noise, we removed them from all affected rows.

### 7. Identify potentially spammy or suspicious review patterns
- We analyzed users who wrote more than 100 reviews from the same UserId and found 9,208 such rows. However, since these reviews were spread across different dates and ProductIds, they do not indicate suspicious behavior.
- A deeper check revealed 231,968 rows where the same user copy-pasted identical reviews. From these, we retained only one unique entry per duplicate and removed 173,955 rows.
- We also examined cases where users had identical helpfulness metrics. A total of 42,418 rows were reviewed and found to be normal based on Date and ProductId. It's common for some reviews to have no helpfulness votes.
- We checked for very short reviews (length < 10 characters) and found no such rows.
- We identified 2,586 instances where the same user reviewed the same product multiple times. Many were valid, such as repeat purchases with updated feedback, but 1,385 rows were found to be copied and pasted and were removed.

### 8. Validate score ranges
We checked for unusual scores (i.e., scores less than 1 or greater than 5) and found no anomalies. All score values are within the valid range of 1 to 5.
