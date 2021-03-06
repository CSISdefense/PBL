USE [DIIG]
GO
/****** Object:  View [Project].[FundingMechanismProject]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [Project].[FundingMechanismProject]
AS

SELECT 
 coalesce(secc.systemequipmentcodeText --coalesce uses the first non null column
	,secclid1.systemequipmentcodeText
	 ,secclid2.systemequipmentcodeText) as systemequipmentcodeText

,R.contractfinancingtext
,F.typeofcontractpricingtext
, c.fiscal_year as Fiscal_Year
, Sum(C.obligatedAmount) AS SumOfobligatedAmount
, Sum(C.numberOfActions) AS SumOfnumberOfActions
, Max(C.obligatedAmount) AS MaxOfobligatedAmount
, Sum(C.baseandexercisedoptionsvalue) AS SumOfbaseandexercisedoptionsvalue
, Sum(C.baseandalloptionsvalue) AS SumOfbaseandalloptionsvalue

FROM Contract.FPDS as C
left outer join FPDSTypeTable.systemequipmentcode as secC
on secC.systemequipmentcode=c.systemequipmentcode
--Getting the systemequipment code from the csistransactionid
left outer join contract.CSIStransactionID as cTID
on c.CSIStransactionID=ctid.transactionnumber
left outer join contract.ContractLabelID as clid1
on ctid.ContractLabelID=clid1.ContractLabelID
left outer join FPDSTypeTable.systemequipmentcode as SECclid1
on secclid1.systemequipmentcode=clid1.systemequipmentcode
--Getting the systemequipment code from the csiscontractid
left outer join contract.CSIScontractID as cCID
on ccid.CSIScontractID=ctid.CSIScontractID
left outer join contract.ContractLabelID as clid
on ctid.ContractLabelID=clid1.ContractLabelID
left outer join contract.ContractLabelID as clid2
on ccid.ContractLabelID=clid1.ContractLabelID
left outer join FPDSTypeTable.systemequipmentcode as SECclid2
on secclid2.systemequipmentcode=clid2.systemequipmentcode
LEFT OUTER JOIN FPDSTypeTable.contractfinancing AS R 
ON R.contractfinancing= C.Contractfinancing
LEFT OUTER JOIN FPDSTypeTable.typeofcontractpricing AS F 
ON C.TypeofContractPricing = F.TypeofContractPricing


GROUP BY 
 coalesce(secc.systemequipmentcodeText --coalesce uses the first non null column
	,secclid1.systemequipmentcodeText
	 ,secclid2.systemequipmentcodeText)
,R.contractfinancingtext
,F.typeofcontractpricingtext
,c.fiscal_year










GO
