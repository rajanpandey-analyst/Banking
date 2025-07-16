
# _________________________________ PROJECT- BANK LOAN ANALYSIS________________________________

CREATE DATABASE da_project_1;
USE da_project_1;

# ________ DATA  _____________

SELECT * FROM finance_data1;
SELECT * FROM finance_data2;

# ______ DESCRIBING DATA _____________

DESCRIBE finance_data1;
DESCRIBE finance_data2;

ALTER TABLE finance_data1 
MODIFY issue_d DATE;

ALTER TABLE finance_data2
MODIFY last_pymnt_d DATE,
MODIFY last_credit_pull_d DATE;

# ____________________________________________________________________________________________

# Total Customers:

SELECT COUNT(*) FROM finance_data1; # '39717' 
SELECT COUNT(*) FROM finance_data2; # '39717'

# Total Loan Amount:

SELECT 
	CONCAT(ROUND((SUM(loan_amnt)/1000000)),'M') 
    AS "Total Loan Amount"
FROM finance_data1;  
# '446M'

# Total Payment Amount:

SELECT 
	CONCAT(ROUND((SUM(total_pymnt)/1000000)),'M')
    AS "Total Payment Amount"
FROM finance_data2;
# '483M'

# ____________________________________________________________________________________________

#	KPI - 1 (YEAR WISE LOAN AMOUNT STATS)

SELECT 
    YEAR(issue_d) AS Year,
    CONCAT(ROUND((SUM(loan_amnt) / 1000000),2),'M') AS 'Total Loan Amt',
    ROUND(AVG(loan_amnt)) AS 'Average Loan Amt',
    MIN(loan_amnt) AS 'Minimun Loan Amt',
    MAX(loan_amnt) AS 'Maximun Loan Amt'
FROM
    finance_data1
GROUP BY Year
ORDER BY Year;

# ___________________________________________________________________________________________

#	KPI - 2 (GRADE AND SUB GRADE WISE REVOL_BAL)

SELECT 
    grade, sub_grade, SUM(revol_bal) AS "Total Revol Bal"
FROM
    finance_data1 f1
        INNER JOIN
    finance_data2 f2 USING (id)
GROUP BY grade, sub_grade
ORDER BY grade;

# ___________________________________________________________________________________________

#	KPI - 3 (Total Payment for Verified Status Vs Total Payment for Non Verified Status)

SELECT 
    verification_status,
    ROUND(SUM(total_pymnt), 2) AS 'Total Payment'
FROM
    finance_data1 AS f1
        INNER JOIN
    finance_data2 AS f2 USING (id)
WHERE
    verification_status IN ('Verified' , 'Not Verified')
GROUP BY verification_status;

# ___________________________________________________________________________________________

#	KPI - 4 (State wise and last_credit_pull_d wise loan status)

SELECT 
    addr_state AS 'States',
    last_credit_pull_d,
    loan_status
FROM
    finance_data1 AS f1
        INNER JOIN
    finance_data2 AS f2 USING (id)
ORDER BY States;

# ___________________________________________________________________________________________

#	KPI - 5 (Home ownership Vs last payment date stats)

SELECT 
    home_ownership AS Home_Ownership,
    last_pymnt_d,
    ROUND(SUM(last_pymnt_amnt), 2) AS Last_Payment_Amt
FROM
    finance_data1 AS f1
        INNER JOIN
    finance_data2 AS f2 USING (id)
GROUP BY Home_Ownership , last_pymnt_d
ORDER BY Home_Ownership;

# ___________________________________________________________________________________________

#	KPI - 6 (Top 5 Loan Stat based on Purpose)

SELECT
	purpose, SUM(loan_amnt) AS Total_Loan_Amt
FROM finance_data1
GROUP BY purpose
ORDER BY Total_Loan_Amt DESC
LIMIT 5 ;

# _____________________________________________________________________________________________
