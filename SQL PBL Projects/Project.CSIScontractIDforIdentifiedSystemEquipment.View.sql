USE [DIIG]
GO
/****** Object:  View [Project].[CSIScontractIDforIdentifiedSystemEquipment]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [Project].[CSIScontractIDforIdentifiedSystemEquipment]
AS

SELECT 
 proj.ProjectID
 ,proj.ProjectName
 ,proj.ProjectAbbreviation
 --The max is there because we're already grouping by systemequipmentcode, so all it does is ignore out nulls
 ,max(iif(c.modnumber is null or c.modnumber='0',proj.ProjectID,NULL)) as UnmodifiedSystemEquipmentCode
,ctid.CSIScontractID
, cid.LastUltimateCompletionDate
, cid.MinofsignedDate
--, C.IDVPIID
--, C.PIID
--, C.modnumber
--, min(c.fiscal_year) as MinOfFiscal_Year
--, max(c.fiscal_year) as MaxOfFiscal_Year
--, Sum(C.obligatedAmount) AS SumOfobligatedAmount
--, Sum(C.numberOfActions) AS SumOfnumberOfActions
--, Max(C.obligatedAmount) AS MaxOfobligatedAmount
--, Sum(C.baseandexercisedoptionsvalue) AS SumOfbaseandexercisedoptionsvalue
--, Sum(C.baseandalloptionsvalue) AS SumOfbaseandalloptionsvalue

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

--left outer join Project.systemequipmentcode as DirectSEC
--on c.systemequipmentcode=DirectSEC.systemequipmentcode
----Getting the systemequipment code from the csistransactionid
--left outer join contract.CSIStransactionID as cTID
--on c.CSIStransactionID=ctid.CSIStransactionID
--left outer join contract.ContractLabelID as TransactionLabel
--on ctid.ContractLabelID=TransactionLabel.ContractLabelID
--left outer join Project.systemequipmentcode as TransactionSEC
--on TransactionLabel.systemequipmentcode=TransactionSEC.systemequipmentcode
----Getting the systemequipment code from the csiscontractid
--left outer join contract.CSIScontractID as cid
--on ctid.csiscontractid=cid.csiscontractid
--left outer join contract.ContractLabelID as ContractLabel
--on cid.ContractLabelID=ContractLabel.ContractLabelID
--left outer join FPDSTypeTable.systemequipmentcode as ContractSEC
--on ContractLabel.systemequipmentcode=ContractSEC.systemequipmentcode
--where  coalesce( --coalesce uses the first non null column
--	TransactionSEC.IsIdentifiedSystemEquipment
--	 ,ContractSEC.IsIdentifiedSystemEquipment
--	 ,DirectSEC.IsIdentifiedSystemEquipment)=1

GROUP BY 
 --coalesce( --coalesce uses the first non null column
	--TransactionSEC.systemequipmentcode
	-- ,ContractSEC.systemequipmentcode
	-- ,DirectSEC.systemequipmentcode)
ctid.CSIScontractID
, cid.LastUltimateCompletionDate
, cid.MinofsignedDate
, proj.ProjectID
 ,proj.ProjectName
 ,proj.ProjectAbbreviation













GO
