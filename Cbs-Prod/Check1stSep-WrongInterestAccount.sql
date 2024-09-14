-- fixed account
Select AccountNumber,BranchCode,BeginOfTenor,EndOfTenor,CloseDate,DepositStatus,CatalogCode
From o9deposit.dbo.DepositAccount
Where Cast(BeginOfTenor As Date) = '2024-09-01'
And DepositStatus = 'N'
And CloseDate IS NULL

Select * From o9deposit.dbo.IFCBalanceDetail
Where AccountNumber IN (
Select AccountNumber
From o9deposit.dbo.DepositAccount
Where Cast(BeginOfTenor As Date) = '2024-09-01'
And DepositStatus = 'N'
And CloseDate IS NULL
) And Cast(FromDate As Date) >= '2024-09-01'
And Action = 'C'
Order By AccountNumber,FromDate

-- call/premium call
With S1INT AS (Select AccountNumber,IfcCode,IfcValue,Balance,Amount,Cast(FromDate As Date) WorkingDate
From o9deposit.dbo.IFCBalanceDetail
Where Action = 'C'
And SUBSTRING(AccountNumber,1,2) IN ('33','34')
And Cast(FromDate As Date) = '2024-09-01'),
S2INT AS (Select AccountNumber,IfcCode,IfcValue,Balance,Amount,Cast(FromDate As Date) WorkingDate
From o9deposit.dbo.IFCBalanceDetail
Where Action = 'C'
And SUBSTRING(AccountNumber,1,2) IN ('33','34')
And Cast(FromDate As Date) = '2024-09-02')
Select S2.AccountNumber,
Case When SUBSTRING(S2.AccountNumber,1,2) IN ('33') Then 'Call Deposit'
When SUBSTRING(S2.AccountNumber,1,2) IN ('34') Then 'Premium Call Deposit' End As AccountClass
,S2.IfcCode,S2.Balance,S2.WorkingDate,S2.IfcValue,S2.Amount,S1.IfcCode,S1.Balance,S1.WorkingDate,S1.IfcValue,S1.Amount,(S2.Amount-S1.Amount) Adjustment
From S2INT S2 JOIN S1INT S1
ON S2.AccountNumber = S1.AccountNumber
AND S2.IfcCode = S2.IfcCode
Order By S2.IfcCode Desc

-- shwe cash call

With S1INT AS (Select AccountNumber,IfcCode,IfcValue,Balance,Amount,FromDate,Action From o9deposit.dbo.IFCBalanceDetail
Where Cast(FromDate As date) = '2024-09-01'
And SUBSTRING(AccountNumber,1,2) IN ('35')
And Balance < 1000000000),
S2INT AS (Select AccountNumber,IfcCode,IfcValue,Balance,Amount,FromDate From o9deposit.dbo.IFCBalanceDetail
Where Cast(FromDate As date) = '2024-09-02'
And SUBSTRING(AccountNumber,1,2) IN ('35')
And Balance < 1000000000)
Select S1.*,S2.*,(S2.Amount-S1.Amount) Adjustment
From
S1INT S1 JOIN  S2INT S2
ON S1.AccountNumber = S2.AccountNumber
AND S1.IfcCode = S2.IfcCode
Where S1.Balance <> S2.Balance
