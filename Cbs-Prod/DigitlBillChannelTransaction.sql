-- Digital Bill Channel Transaction
-- Prod Cbs
-- v1.0

With TxnInfo As
(Select t2.AccountNumber,t2.Amount,t1.CreatedOnUtc,t1.TransactionDate,TransactionCode,
Case When t1.Channel = 'D' Then 'Digital' 
When t1.Channel = 'B' Then 'Bill Payment' End As Channel
From o9admin.dbo.TransactionJournalDoneHistory t1 Join
o9deposit.dbo.DepositStatement t2
On t1.TransactionNumber = t2.TransactionNumber
Where Cast(t1.CreatedOnUtc As date) <= '2024-08-31'
And Channel IN ('D','B')
And HasPosting = '1'
And IsReverse = '0'
And Status = 'C'
And UserCreated In ('bill01','digital01')
And t2.StatementStatus = 'N'),
AccInfo As(
Select CustomerCode,BranchCode,AccountNumber,CatalogCode,
Case When DepositType = 'S' Then 'Saving'
When DepositType = 'T' Then 'Fixed'
When DepositType = 'C' Then 'Current'
End As DepositType From o9deposit.dbo.DepositAccount
)
Select
T2.CustomerCode,T2.BranchCode,T2.CatalogCode,T2.DepositType,T1.AccountNumber,T1.TransactionCode,T3.Description [TransactionDesc],Cast(CreatedOnUtc As date) TransactionDate,Amount,T1.Channel From TxnInfo T1 
JOIN AccInfo T2
ON T1.AccountNumber = T2.AccountNumber
JOIN neptune.dbo.WF_DEF T3
ON T1.TransactionCode = T3.Code
Order By TransactionDate