USE [DIIG]
GO
/****** Object:  View [Project].[BucketProjectSubCustomer]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE VIEW [Project].[BucketProjectSubCustomer]
AS

SELECT 
Proj.ProjectID
	,					  proj.ProjectAbbreviation
	,					   Proj.ProjectName
, ISNULL(Agency.Customer
		, Agency.AgencyIDtext) AS Customer
	, Agency.SubCustomer
	, PSC.ServicesCategory
	,PSC.IsService
, c.fiscal_year 
, Sum(C.obligatedAmount) AS SumOfobligatedAmount
, Sum(C.numberOfActions) AS SumOfnumberOfActions
, Max(C.obligatedAmount) AS MaxOfobligatedAmount
, Sum(C.baseandexercisedoptionsvalue) AS SumOfbaseandexercisedoptionsvalue
, Sum(C.baseandalloptionsvalue) AS SumOfbaseandalloptionsvalue

FROM Contract.FPDS as C

--Block of CSISIDjoins
              left join contract.csistransactionid as CTID
                     on ctid.CSIStransactionID=c.CSIStransactionID
              left join contract.CSISidvmodificationID as idvmod
                     on idvmod.CSISidvmodificationID=ctid.CSISidvmodificationID
              left join contract.CSISidvpiidID as idv
                     on idv.CSISidvpiidID=idvmod.CSISidvpiidID
              left join contract.CSIScontractID as cid
                     on cid.CSIScontractID=ctid.CSIScontractID
--Block of Contract Label and ProjectID 
              left join Contract.ContractLabelID label
                     on coalesce(ctid.ContractLabelID,cid.COntractlabelid,idv.ContractLabelID) = label.ContractLabelID
              LEFT JOIN Project.SystemEquipmentCodetoProjectIDhistory as SYS
                     ON SYS.systemequipmentcode=C.systemequipmentcode
                     and SYS.StartFiscalYear <= c.fiscal_year
                     and isnull(SYS.EndFiscalYear,9999) >= c.fiscal_year
              left join project.projectID Proj
                     on proj.projectid=isnull(sys.projectid,label.PrimaryProjectID)
	LEFT OUTER JOIN Contract.ContractDiscretization AS CD
	ON CD.CSIScontractID = CTID.CSIScontractID



--Getting the agency codes from FPDSTypeTable
LEFT OUTER JOIN FPDSTypeTable.AgencyID AS Agency 
ON C.contractingofficeagencyid = Agency.AgencyID 
--Getting the PSC codes from FPDSTypeTable
LEFT OUTER JOIN FPDSTypeTable.ProductOrServiceCode AS PSC 
ON C.productorservicecode = PSC.ProductOrServiceCode 


GROUP BY --never use AS in GROUP BY 
 Proj.ProjectID
	,					  proj.ProjectAbbreviation
	,					   Proj.ProjectName
	, ISNULL(Agency.Customer
		, Agency.AgencyIDtext) 
	, Agency.SubCustomer
	, PSC.ServicesCategory
	,c.fiscal_year
	,PSC.IsService












GO
