-- 
Declare @FromDate Date = '2024-08-01'
Declare @ToDate Date = '2024-08-31'
--Select 
--T1.TransactionDate,T1.TransactionNumber,T1.TransactionCode,T2.AccountNumber,T3.AccountName [AccountHolder],T2.Amount,T2.CurrencyCode,
--Case When T2.StatementCode = 'WDR' Then 'Dr'
--When T2.StatementCode = 'DEP' Then 'Cr' End As DorC
--From
--o9admin.dbo.TransactionJournalDoneHistory T1
--Join o9deposit.dbo.DepositStatement T2
--On T1.TransactionNumber = T2.TransactionNumber
--Join o9deposit.dbo.DepositAccount T3
--On T2.AccountNumber = T3.AccountNumber
--Where Cast(T1.TransactionDate As Date) >= @FromDate
--And Cast(T1.TransactionDate As Date) <= @ToDate
--And Channel = 'O'
--And Status = 'C'
Select Cast(T1.TransactionDate As Date),Count(*) From 
(Select 
TransactionDate,
TransactionNumber,
TransactionCode,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.debit_account_number') DebitAccountNumber,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.credit_account_number') CreditAccountNumber,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.customer_name') CustomerName,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.currency_code') CurrencyCode,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.amount') Amount,
Description
From
o9admin.dbo.TransactionJournalDoneHistory
Where Cast(TransactionDate As Date) >= @FromDate
And Cast(TransactionDate As Date) <= @ToDate
And Channel = 'O'
And Status = 'C'
And HasPosting = '1'
And IsReverse = '0'
) T1
GROUP BY Cast(T1.TransactionDate As Date)
ORDER BY Cast(T1.TransactionDate As Date)


Declare @From Date = '2024-09-01'
Declare @To Date = '2024-09-07'

Select Cast(T1.TransactionDate As Date),Count(*) From 
(Select 
TransactionDate,
TransactionNumber,
TransactionCode,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.debit_account_number') DebitAccountNumber,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.credit_account_number') CreditAccountNumber,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.customer_name') CustomerName,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.currency_code') CurrencyCode,
JSON_VALUE(TransactionBody,'$.input.fields.transaction_data.amount') Amount,
Description
From
o9admin.dbo.TransactionJournalDoneHistory
Where Cast(TransactionDate As Date) >= @From
And Cast(TransactionDate As Date) <= @To
And Channel = 'O'
And Status = 'C'
And HasPosting = '1'
And IsReverse = '0'
) T1
GROUP BY Cast(T1.TransactionDate As Date)