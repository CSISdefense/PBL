USE [DIIG]
GO
/****** Object:  View [Project].[ContractModProjectPartial]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE VIEW [Project].[ContractModProjectPartial]
AS

SELECT 
Proj.ProjectID
	,					  proj.ProjectAbbreviation
	,					   Proj.ProjectName
, C.IDVPIID
, C.PIID
, C.modnumber
, min(c.fiscal_year) as MinOfFiscal_Year
, max(c.fiscal_year) as MaxOfFiscal_Year
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


GROUP BY 
 Proj.ProjectID
	,					  proj.ProjectAbbreviation
	,					   Proj.ProjectName
, C.IDVPIID
, C.PIID
, C.modnumber











GO
