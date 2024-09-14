-- Core Transaction
With TxnInfo As(Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDoneHistory
Where Cast(CreatedOnUtc As date) = Cast(GetDate()-1 As date)
And Channel = 'C'
Union All
Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDone
Where Cast(CreatedOnUtc As date) = Cast(GetDate() as date)
And Channel = 'C'),
CshInfo As (
Select AccountNumber,TransactionNumber,Amount,StatementCode,CurrencyCode From o9deposit.dbo.DepositStatement
)
Select 
T1.TransactionNumber,
T1.TransactionDate,
T1.TransactionCode,
T3.Name,
T1.UserCreated,
T1.UserApprove,
T1.UserReject,
T2.AccountNumber,
T4.AccountName,
T2.Amount,
Case When T2.Amount Is Not Null Then 'Csh Transaction' Else 'Non-Csh Transaction' End As TransactionType,
T2.CurrencyCode,
Case When T2.StatementCode = 'DEP' THEN 'Cr'
When T2.StatementCode = 'WDR' THEN 'Dr'
END AS DrCr_Ind,
T1.Description,
T1.HasPosting,
T1.IsReverse,
T1.Status,
T5.Caption [TransactionStatus],
T1.CreatedOnUtc,
T1.UpdatedOnUtc
From TxnInfo T1 LEFT JOIN CshInfo T2
On T1.TransactionNumber = T2.TransactionNumber
Join neptune.dbo.WF_DEF T3
On T1.TransactionCode = T3.Code
Left Join o9deposit.dbo.DepositAccount T4
On T4.AccountNumber = T2.AccountNumber
Join o9admin.dbo.CodeList T5
On T1.Status = T5.CodeId
Where T5.CodeName = 'TXSTS'
Order By T1.CreatedOnUtc

-- CardZone Transaction
With TxnInfo As(Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDoneHistory
Where Cast(CreatedOnUtc As date) = Cast(GetDate()-1 As date)
And Channel = 'Z'
Union All
Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDone
Where Cast(CreatedOnUtc As date) = Cast(GetDate() as date)
And Channel = 'Z'),
CshInfo As (
Select AccountNumber,TransactionNumber,Amount,StatementCode,CurrencyCode From o9deposit.dbo.DepositStatement
)
Select 
T1.TransactionNumber,
T1.TransactionDate,
T1.TransactionCode,
T3.Name,
T1.UserCreated,
T1.UserApprove,
T1.UserReject,
T2.AccountNumber,
T4.AccountName,
T2.Amount,
Case When T2.Amount Is Not Null Then 'Csh Transaction' Else 'Non-Csh Transaction' End As TransactionType,
T2.CurrencyCode,
Case When T2.StatementCode = 'DEP' THEN 'Cr'
When T2.StatementCode = 'WDR' THEN 'Dr'
END AS DrCr_Ind,
T1.Description,
T1.HasPosting,
T1.IsReverse,
T1.Status,
T5.Caption As [TransactionStatus],
T1.CreatedOnUtc,
T1.UpdatedOnUtc
From TxnInfo T1 LEFT JOIN CshInfo T2
On T1.TransactionNumber = T2.TransactionNumber
Join neptune.dbo.WF_DEF T3
On T1.TransactionCode = T3.Code
Left Join o9deposit.dbo.DepositAccount T4
On T4.AccountNumber = T2.AccountNumber
Join o9admin.dbo.CodeList T5
On T1.Status = T5.CodeId
Where T5.CodeName = 'TXSTS'
Order By T1.CreatedOnUtc


-- Mo Transaction
With TxnInfo As(Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDoneHistory
Where Cast(CreatedOnUtc As date) = Cast(GetDate()-1 As date)
And Channel = 'O'
Union All
Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDone
Where Cast(CreatedOnUtc As date) = Cast(GetDate() as date)
And Channel = 'O'),
CshInfo As (
Select AccountNumber,TransactionNumber,Amount,StatementCode,CurrencyCode From o9deposit.dbo.DepositStatement
)
Select 
T1.TransactionNumber,
T1.TransactionDate,
T1.TransactionCode,
T3.Name,
T1.UserCreated,
T1.UserApprove,
T1.UserReject,
T2.AccountNumber,
T4.AccountName,
T2.Amount,
Case When T2.Amount Is Not Null Then 'Csh Transaction' Else 'Non-Csh Transaction' End As TransactionType,
T2.CurrencyCode,
Case When T2.StatementCode = 'DEP' THEN 'Cr'
When T2.StatementCode = 'WDR' THEN 'Dr'
END AS DrCr_Ind,
T1.Description,
T1.HasPosting,
T1.IsReverse,
T1.Status,
T5.Caption [TransactionStatus],
T1.CreatedOnUtc,
T1.UpdatedOnUtc
From TxnInfo T1 LEFT JOIN CshInfo T2
On T1.TransactionNumber = T2.TransactionNumber
Join neptune.dbo.WF_DEF T3
On T1.TransactionCode = T3.Code
Left Join o9deposit.dbo.DepositAccount T4
On T4.AccountNumber = T2.AccountNumber
Join o9admin.dbo.CodeList T5
On T1.Status = T5.CodeId
Where T5.CodeName = 'TXSTS'
Order By T1.CreatedOnUtc

-- Digital Payment Transaction
With TxnInfo As(Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDoneHistory
Where Cast(CreatedOnUtc As date) = Cast(GetDate()-1 As date)
And Channel In ('D','B')
Union All
Select
TransactionNumber,TransactionCode,TransactionDate,UserCreated,UserApprove,UserReject,Status,IsReverse,HasPosting,Description,CreatedOnUtc,UpdatedOnUtc,ApproveDate From o9admin.dbo.TransactionJournalDone
Where Cast(CreatedOnUtc As date) = Cast(GetDate() as date)
And Channel In ('D','B')),
CshInfo As (
Select AccountNumber,TransactionNumber,Amount,StatementCode,CurrencyCode From o9deposit.dbo.DepositStatement
)
Select 
T1.TransactionNumber,
T1.TransactionDate,
T1.TransactionCode,
T3.Name,
T1.UserCreated,
T1.UserApprove,
T1.UserReject,
T2.AccountNumber,
T4.AccountName,
T2.Amount,
Case When T2.Amount Is Not Null Then 'Csh Transaction' Else 'Non-Csh Transaction' End As TransactionType,
T2.CurrencyCode,
Case When T2.StatementCode = 'DEP' THEN 'Cr'
When T2.StatementCode = 'WDR' THEN 'Dr'
END AS DrCr_Ind,
T1.Description,
T1.HasPosting,
T1.IsReverse,
T1.Status,
T5.Caption [TransactionStatus],
T1.CreatedOnUtc,
T1.UpdatedOnUtc
From TxnInfo T1 LEFT JOIN CshInfo T2
On T1.TransactionNumber = T2.TransactionNumber
Join neptune.dbo.WF_DEF T3
On T1.TransactionCode = T3.Code
Left Join o9deposit.dbo.DepositAccount T4
On T4.AccountNumber = T2.AccountNumber
Join o9admin.dbo.CodeList T5
On T1.Status = T5.CodeId
Where T5.CodeName = 'TXSTS'
Order By T1.CreatedOnUtc


Select * From o9admin.dbo.CodeList
Where CodeName = 'TXSTS'