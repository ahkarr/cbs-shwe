-- prod-neptune-PendingTxnDetails
-- core team check
-- v1.2

Declare @WorkingDate As Date = Cast(GetDate() As Date);

-- check pending transaction
Select 
'Pending-Txn' As PendingType,T1.TransactionNumber,T1.TransactionDate,T1.TransactionCode,Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9admin.dbo.TransactionJournalDone T1
Join o9admin.dbo.UserAccount T2
On T1.UserCreated = T2.UserCode
Where T1.Status = 'P'
And T1.HasPosting = '0'
And T1.Channel = 'C'
Order By MakerBranch

-- check customer profile
Select
'CustProfile-Txn' As PendingType,T1.CustomerCode,T1.BranchCode [CustomerBranch],Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9customer.dbo.SingleCustomer T1 Join o9admin.dbo.UserAccount T2
On T1.StaffCode = T2.UserCode
Where Cast(T1.CreatedOnUtc As Date) = @WorkingDate
And T1.CustomerStatus = 'P'
Order By CustomerBranch

-- check customer profile modify
Select 
'CustProfileModify-Txn' As PendingType,T1.CustomerCode,T1.BranchCode [CustomerBranch],Concat(T3.UserCode,'-',T3.UserName) MakerInfo,T3.BranchCode [MakerBranch]
From o9customer.dbo.CustomerApprove T1
Join o9admin.dbo.TransactionJournalDone T2 On T1.ReferenceId = T2.RefId
Join o9admin.dbo.UserAccount T3 On T2.UserCreated = T3.UserCode
Where T1.ApproveStatus = 'W'
And Cast(T2.TransactionDate As Date) = @WorkingDate

-- check customer linkage modify
Select 
'CustLinkageModify-Txn' As PendingType,T1.LinkageCode,T4.BranchCode [CustomerBranch],Concat(T3.UserCode,'-',T3.UserName) MakerInfo,T3.BranchCode [MakerBranch]
From o9customer.dbo.CustomerLinkageApprove T1
Join o9admin.dbo.TransactionJournalDone T2 On T1.ReferenceId = T2.RefId
Join o9admin.dbo.UserAccount T3 On T2.UserCreated = T3.UserCode
Join o9customer.dbo.SingleCustomer T4 On T1.LinkageCode = T4.CustomerCode
Where T1.ApproveStatus = 'W'
And Cast(T1.TransactionDate As Date) = @WorkingDate

-- check customer group modify
Select 
'CustGroupModify-Txn' As PendingType,T1.MasterAccountCode,T4.BranchCode [CustomerBranch],Concat(T3.UserCode,'-',T3.UserName) MakerInfo,T3.BranchCode [MakerBranch]
From o9customer.dbo.CustomerGroupApprove T1
Join o9admin.dbo.TransactionJournalDone T2 On T1.ReferenceId = T2.RefId
Join o9admin.dbo.UserAccount T3 On T2.UserCreated = T3.UserCode
Join o9customer.dbo.SingleCustomer T4 On T1.MasterAccountCode = T4.CustomerCode
Where T1.ApproveStatus = 'W'
And Cast(T1.TransactionDate As Date) = @WorkingDate

-- check deposit account
Select
'DptAcc-Txn' As PendingType,T1.AccountNumber,T1.CustomerCode,T1.BranchCode [CustomerBranch],Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9deposit.dbo.DepositAccount T1 Join o9admin.dbo.UserAccount T2
On T1.AccountManagerStaffCode = T2.UserCode
Where Cast(T1.CreatedOnUtc As Date) = @WorkingDate
And T1.DepositStatus = 'P'
Order By CustomerBranch;

-- check deposit account modify
Select
'DptAccModify-Txn' As PendingType,T1.AccountNumber,T1.CustomerCode,T1.BranchCode [CustomerBranch],Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9deposit.dbo.ApproveDepositAccount T1 
Join o9admin.dbo.TransactionJournalDone T3 
On T1.ReferenceNumber = T3.RefId
Join o9admin.dbo.UserAccount T2
On T3.UserCreated = T2.UserCode
Where Cast(T1.CreatedOnUtc As Date) = @WorkingDate
And T1.ApproveStatus = 'W'
Order By CustomerBranch;

-- overdraft account
Select ContractNumber,AccountNumber,BranchCode [CustomerBranch]
From o9deposit.dbo.OverdraftContract
Where ContractStatus In (4,5)
And Cast(CreatedOnUtc As date) = @WorkingDate;

-- check modify overdraft account
Select T1.AccountNumber,T1.ContractNumber,T1.BranchCode [CustomerBranch],Concat(T3.UserCode,'-',T3.UserName) [MakerName],T3.BranchCode [MakerBranch]
From o9deposit.dbo.ApproveOverdraftContract T1 Join
o9admin.dbo.TransactionJournalDone T2
On T1.TxReferenceId = T2.RefId
Join o9admin.dbo.UserAccount T3
On T2.UserCreated = T3.UserCode
Where T1.ApproveStatus = 'W'
And Cast(T1.CreatedOnUtc As date) = @WorkingDate;

-- check credit account
Select
'CrdAcc-Txn' As PendingType,T1.AccountNumber,T1.CustomerCode,T1.BranchCode [CustomerBranch],Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9credit.dbo.CreditAccount T1 Join o9admin.dbo.UserAccount T2
On T1.StaffCode = T2.UserCode
Where Cast(T1.CreatedOnUtc As Date) = @WorkingDate
And T1.CreditStatus = '5'
Order By CustomerBranch

-- check credit account modify
Select
'CrdAccModify-Txn' As PendingType,T1.AccountNumber,T1.CustomerCode,T1.BranchCode [CustomerBranch],Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9credit.dbo.CreditApproveAccount T1 
Join o9admin.dbo.TransactionJournalDone T3 
On T1.ReferenceNumber = T3.RefId
Join o9admin.dbo.UserAccount T2
On T3.UserCreated = T2.UserCode
Where Cast(T1.CreatedOnUtc As Date) = @WorkingDate
And T1.ApproveStatus = 'W'
Order By CustomerBranch

-- check product limit
Select 
'ProductLimit-Txn' As PendingType,T1.BranchCode [CustomerBranch],T1.ProductLimitCode,T1.ProductLimitName,T1.CustomerCode,Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9credit.dbo.CreditProductLimit T1 Join o9admin.dbo.UserAccount T2
On T1.UserCreated = T2.UserCode
Where T1.ProductStatus = 'P'
And Cast(T1.CreatedOnUtc As date) = @WorkingDate

-- check subproduct limit
Select 
'SubProductLimit-Txn' As PendingType,T1.BranchCode [CustomerBranch],T1.SubProductLimitCode,T1.SubProductLimitName,T1.CustomerCode,Concat(T2.UserCode,'-',T2.UserName) MakerInfo,T2.BranchCode [MakerBranch]
From o9credit.dbo.CreditSubProductLimit T1 Join o9admin.dbo.UserAccount T2
On T1.UserCreated = T2.UserCode
Where T1.SubProductStatus = 'P'
And Cast(T1.CreatedOnUtc As date) = @WorkingDate

-- check mortgage account
Select 
'MtgAcc-Txn' As PendingType,AccountNumber,A.BranchCode [CustomerBranch],CustomerCode,Concat(B.UserCode,'-',B.UserName) MakerInfo,B.BranchCode [MakerBranch]
From o9mortgage.dbo.MortgageAccount A Join o9admin.dbo.UserAccount B
On A.CreatedBy = B.UserCode
Where CollateralAccountStatus = 'A'
And Cast(A.CreatedOnUtc As date) = @WorkingDate

-- check customer image
Select 
'CustMedia-Txn' As PendingType,A.CustomerCode,B.BranchCode [CustomerBranch],MediaName,Other,Infor2,FileUploadId From 
o9customer.dbo.CustomerMediaStorage A JOIN o9customer.dbo.SingleCustomer B
On A.CustomerCode = B.CustomerCode
Where MediaStatus = 'N'
And Cast(A.CreatedOnUtc As date) = @WorkingDate