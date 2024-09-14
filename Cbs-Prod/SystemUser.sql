-- prod-neptune-SysUserList
-- Core Team
-- v1.0

-- usrrole
WITH UserRole AS(
SELECT A.UserCode,STRING_AGG(RoleName,',') RoleNameList
FROM o9admin.dbo.RoleOfUser A,o9admin.dbo.UserRole B
WHERE A.RoleId = B.Id
GROUP BY A.UserCode),
-- usrinfo
UserInfo AS(
SELECT A.UserCode,A.LoginName,A.UserName,A.BranchCode,
CASE WHEN SUBSTRING(UserCode,1,3) IN ('ict') THEN 'Information Technology' 
WHEN SUBSTRING(UserCode,1,3) IN ('adm') THEN 'Administration' 
WHEN SUBSTRING(UserCode,1,3) IN ('agb') THEN 'Agent Banking' 
WHEN SUBSTRING(UserCode,1,3) IN ('brn') THEN 'Branch'
WHEN SUBSTRING(UserCode,1,3) IN ('ibd') THEN 'International Banking'
WHEN SUBSTRING(UserCode,1,3) IN ('dig') THEN 'Digital Banking' 
WHEN SUBSTRING(UserCode,1,3) IN ('aud') THEN 'Internal Audit' 
WHEN SUBSTRING(UserCode,1,2) IN ('ln') THEN 'Loan Operation' 
WHEN SUBSTRING(UserCode,1,2) IN ('hr') THEN 'Human Resource' 
WHEN SUBSTRING(UserCode,1,2) IN ('fn') THEN 'Finance & Accounting' 
WHEN SUBSTRING(UserCode,1,2) IN ('bo') THEN 'Banking Operation' 
WHEN SUBSTRING(UserCode,1,2) IN ('bb') THEN 'Business Banking'
WHEN SUBSTRING(UserCode,1,3) IN ('cct') THEN 'Consumer Banking' 
WHEN SUBSTRING(UserCode,1,2) IN ('tr') THEN 'Treasury' 
WHEN SUBSTRING(UserCode,1,2) IN ('tr') THEN 'Treasury' 
WHEN SUBSTRING(UserCode,1,3) IN ('ris') THEN 'Risk' 
WHEN SUBSTRING(UserCode,1,3) IN ('noc') THEN 'NOC'
WHEN SUBSTRING(UserCode,1,2) IN ('sm') THEN 'Strategic & Management' 
WHEN SUBSTRING(UserCode,1,3) IN ('los') THEN 'Los Channel' 
WHEN UserCode IN ('paygate01','cardzone01','cardzone02','momoney01','cbmnet01','bill01','mpusettle01','cheque01') THEN 'Channel Config'
ELSE 'Other'
END AS Department,
A.Email,
CASE WHEN JSON_VALUE(A.Position,'$.Cashier') = 1 THEN 'True' ELSE 'False' END AS IsCashier,
CASE WHEN JSON_VALUE(A.Position,'$.Officer') = 1 THEN 'True' ELSE 'False' END AS IsOfficer,
CASE WHEN JSON_VALUE(A.Position,'$.ChiefCashier') = 1 THEN 'True' ELSE 'False' END AS IsChiefCashier,
CASE WHEN JSON_VALUE(A.Position,'$.OperationStaff') = 1 THEN 'True' ELSE 'False' END AS IsOperationStaff,
CASE WHEN JSON_VALUE(A.Position,'$.Dealer') = 1 THEN 'True' ELSE 'False' END AS IsDealer,
CASE WHEN JSON_VALUE(A.Position,'$.InterBranchUser') = 1 THEN 'True' ELSE 'False' END AS IsInterBranchUser,
CASE WHEN JSON_VALUE(A.Position,'$.BranchManager') = 1 THEN 'True' ELSE 'False' END AS IsBranchManager,
CASE WHEN JSON_VALUE(A.Position,'$.HR') = 1 THEN 'True' ELSE 'False' END AS IsHR,
B.Caption [UserStatus]
FROM 
o9admin.dbo.UserAccount A,o9admin.dbo.CodeList B
WHERE A.UserAccountStatus = B.CodeId
AND B.CodeName = 'STATUS'
AND B.CodeGroup = 'ADM'),
-- usrlog
UserLog AS(
SELECT JSON_VALUE(TransactionBody,'$.input.fields.login_name') LoginName,CreatedOnUtc,UserCreated FROM o9admin.dbo.TransactionJournalDoneHistory
WHERE TransactionCode = 'ADM_INSERT_USER_ACCOUNT'
UNION ALL
SELECT JSON_VALUE(TransactionBody,'$.input.fields.login_name') LoginName,CreatedOnUtc,UserCreated FROM o9admin.dbo.TransactionJournalDone
WHERE TransactionCode = 'ADM_INSERT_USER_ACCOUNT'
)
SELECT 
T1.UserCode,T1.LoginName,T1.UserName,T1.BranchCode,T1.Department,T1.Email,T1.UserStatus,T1.IsBranchManager,T1.IsCashier,T1.IsChiefCashier,T1.IsDealer,T1.IsHR,T1.IsInterBranchUser,T1.IsOfficer,T1.IsOperationStaff,T2.RoleNameList,T3.UserCreated,T3.CreatedOnUtc
FROM UserInfo T1
LEFT JOIN UserRole T2
ON T1.UserCode = T2.UserCode
LEFT JOIN UserLog T3
ON T1.LoginName = T3.LoginName
--WHERE T1.Department = 'Other'
ORDER BY BranchCode





