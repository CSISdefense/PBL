USE [DIIG]
GO

/****** Object:  View [Contract].[CompetitionContractSizeHistoryBucketSubCustomerClassification]    Script Date: 9/13/2017 2:01:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











ALTER VIEW [Contract].[CompetitionContractSizeHistoryBucketSubCustomerClassification]
AS
SELECT       C.fiscal_year
      ,C.Query_Run_Date
      ,C.Customer
	,C.ProductOrServiceArea
	,C.Simple
      ,C.IsService
	  ,C.PBLscore
      ,C.SubCustomer
      ,C.Region
      ,C.Country3LetterCodeText
     /* ,C.extentcompeted5Category
      ,C.reasonnotcompeted4category
      ,c.csiscontractid
      ,C.ExtentIsSomeCompetition
      ,C.extentcompetedtext*/
	  ,C.reasonnotcompetedText	
	,(SELECT CompetitionClassification from FPDSTypeTable.ClassifyCompetition(
		c.numberofoffersreceived --@NumberOfOffers as decimal(19,4)
	,c.UseFairOpportunity --@UseFairOpportunity as bit
	,c.ExtentIsFullAndOpen--@ExtentIsFullAndOpen as bit
	,c.ExtentIsSomeCompetition--@extentissomecompetition as bit
	,c.ExtentIsfollowontocompetedaction 
    ,c.ExtentIsOnlyOneSource 
    ,c.ReasonNotIsfollowontocompetedaction 
	,c.is6_302_1exception--@is6_302_1exception as bit
	,c.FairIsSomeCompetition--@fairissomecompetition as bit
	,c.FairIsfollowontocompetedaction--@FairIsfollowontocompetedaction as bit
	,c.FairIsonlyonesource--@FairIsonlyonesource as bit
		)) as CompetitionClassification
	,(SELECT CompetitionLegacyClassification from FPDSTypeTable.ClassifylegacyCompetition(
		c.numberofoffersreceived --@NumberOfOffers as decimal(19,4)
	,c.ExtentIsFullAndOpen--@ExtentIsFullAndOpen as bit
	,c.ExtentIsSomeCompetition--@extentissomecompetition as bit
	,c.ExtentIsfollowontocompetedaction--@ExtentIsfollowontocompetedaction as bit
	,c.is6_302_1exception--@is6_302_1exception as bit
		)) as CompetitionLegacyClassification
	,(SELECT ClassifyNumberOfOffers from Fpdstypetable.ClassifyNumberOfOffers(
		c.numberofoffersreceived
		,c.UseFairOpportunity	--,@UseFairOpportunity as bit
		,c.ExtentIsSomeCompetition	--,@extentissomecompetition as bit
		,c.FairIsSomeCompetition	--,@fairissomecompetition as bit
		)) as ClassifyNumberOfOffers
		, c.SizeOfSumOfObligatedAmount
		, c.SizeOfSumOfbaseandexercisedoptionsvalue
		, c.SizeOfSumOfbaseandalloptionsvalue
		,c.IsFixedPrice
			,c.IsIncentive
		,iif(addmodified=1 and ismodified=1,'Modified ','')+
		case
			when addmultipleorsingawardidc=1 
			then case 
				when multipleorsingleawardidc is null
				then 'Unlabeled '+AwardOrIDVcontractactiontype
				else multipleorsingleawardidc+' '+AwardOrIDVcontractactiontype
				--Blank multipleorsingleawardIDC
			end
			else AwardOrIDVcontractactiontype 
	end		as VehicleClassification
	,C.VendorSize
	,case 
		when c.UnmodifiedUltimateDuration is null or c.UnmodifiedUltimateDuration <0
		then NULL
		when c.UnmodifiedUltimateDuration <= 61 
		then '<=2 Months'
		when c.UnmodifiedUltimateDuration <= 214 
		then '>2-7 Months'
		when c.UnmodifiedUltimateDuration <= 366
		then '>7-12 Months'
		when c.UnmodifiedUltimateDuration <= 731
		then '>1-2 Years'
		when c.UnmodifiedUltimateDuration <= 1461
		then '>2-4 Years'
		else '>4 years'
		end as UnmodifiedUltimateDuration
      ,C.sumofobligatedAmount 
      ,C.sumofnumberOfActions 
	  , c.IDVlabel
	, c.ContractLabel
	, c.TransactionLabel
	, c.Label
	, c.IsOfficialPBL
		, c.IsPerformanceBasedLogistics
	, c.CSIScontractID
  FROM (
  SELECT        C.fiscal_year
			,GETDATE() AS Query_Run_Date
			,ISNULL(Agency.Customer, Agency.AgencyIDtext) AS Customer
			,PSC.ProductOrServiceArea
			,PSC.Simple
			,PSC.IsService
			,PSC.PBLscore
			,Agency.SubCustomer
			,CountryCode.Region
			,CountryCode.Country3LetterCodeText
			,notcompeted.isfollowontocompetedaction as ReasonNotisfollowontocompetedaction
			,notcompeted.is6_302_1exception
			,NotCompeted.reasonnotcompetedText
			,competed.IsFullAndOpen as ExtentIsFullAndOpen
			,competed.IsSomeCompetition as ExtentIsSomeCompetition
			,competed.IsFollowOnToCompetedAction as ExtentIsFollowOnToCompetedAction
			,competed.IsOnlyOneSource as ExtentIsOnlyOneSource
			,Fairopp.isfollowontocompetedaction as FairIsfollowontocompetedaction
			,Fairopp.isonlyonesource as FairIsonlyonesource
			,Fairopp.IsSomeCompetition as FairIsSomeCompetition
			,setaside.typeofsetaside2category
            ,c.numberofoffersreceived	
			,pricing.IsFixedPrice
			,pricing.IsIncentive
			,pricing.IsAwardFee
			,CASE 
				--Award or IDV Type show only (‘Definitive Contract’, ‘IDC’, ‘Purchase Order’)
				WHEN ctype.ForAwardUseExtentCompeted=1
				then 0 --Use extent competed
				--Award or IDV Type show only (‘Delivery Order’, ‘BPA Call’)
				--IDV Part 8 or Part 13 show only (‘Part 13’)
				--When  **Part 8 or Part 13  is not available!**
				--then 0 --Use extent competed

				--Award or IDV Type show only (‘Delivery Order’)
				--IDV Multiple or Single Award IDV show only (‘S’)
				when ctype.isdeliveryorder=1
					and isnull(IDVmulti.ismultipleaward, Cmulti.ismultipleaward) =0
				then 0
				
				

				--Fair Opportunity / Limited Sources show only (‘Fair Opportunity Given’)
				--Award or IDV Type show only (‘Delivery Order’)
				--IDV Type show only (‘FSS’, ‘GWAC’, ‘IDC’)
				--	IDV Multiple or Single Award IDV show only (‘M’)
				when idvtype.ForIDVUseFairOpportunity=1 and 
					ctype.isdeliveryorder=1 and 
					isnull(IDVmulti.ismultipleaward, Cmulti.ismultipleaward) =1
				then 1 --Use fair opportunity

				--	Number of Offers Received show only (‘1’)
				-- Award or IDV Type show only (‘BPA Call’, ‘BPA’)
				-- Part 8 or Part 13 show only (‘Part 8’)
				--When  **Part 8 or Part 13  is not available!**
				--then 0 --Use extent competed

				when fairopp.statutoryexceptiontofairopportunitytext is not null
				then 1
				else 0
			end as UseFairOpportunity
			,isnull(idvtype.contractactiontypetext,ctype.contractactiontypetext) as AwardOrIDVcontractactiontype
			,isnull(IDVmulti.multipleorsingleawardidctext, Cmulti.multipleorsingleawardidctext) 
				as multipleorsingleawardidc 
			,isnull(IDVtype.addmultipleorsingawardidc,ctype.addmultipleorsingawardidc) as addmultipleorsingawardidc
			,isnull(IDVtype.addmodified,ctype.addmodified) as addmodified
			,isnull(idvmod.typeofidc,idv.typeofidc) as IDVtypeofIDC
			,Rmod.IsModified
			, CASE
		WHEN Parent.Top6=1 and Parent.JointVenture=1 and C.contractingofficerbusinesssizedetermination in ('s','y')
		THEN 'Large: Big 6 JV (Small Subsidiary)'
		WHEN Parent.Top6=1 and Parent.JointVenture=1
		THEN 'Large: Big 6 JV'
		WHEN Parent.Top6=1 and C.contractingofficerbusinesssizedetermination in ('s','y')
		THEN 'Large: Big 6 (Small Subsidiary)'
		WHEN Parent.Top6=1
		THEN 'Large: Big 6'
		WHEN Parent.LargeGreaterThan3B=1 and C.contractingofficerbusinesssizedetermination in ('s','y')
		THEN 'Large (Small Subsidiary)'
		WHEN Parent.LargeGreaterThan3B=1
		THEN 'Large'
		WHEN Parent.LargeGreaterThan1B=1  and C.contractingofficerbusinesssizedetermination in ('s','y')
		THEN 'Medium >1B (Small Subsidiary)'
		WHEN Parent.LargeGreaterThan1B=1
		THEN 'Medium >1B'
		WHEN C.contractingofficerbusinesssizedetermination='s' or C.contractingofficerbusinesssizedetermination='y'
		THEN 'Small'
		when Parent.UnknownCompany=1
		Then 'Unlabeled'
		ELSE 'Medium <1B'
	END AS VendorSize
		, chd.SizeOfSumOfObligatedAmount
		, chd.SizeOfSumOfbaseandexercisedoptionsvalue
		, chd.SizeOfSumOfbaseandalloptionsvalue
		, cd.MinOfEffectiveDate
		, cd.UnmodifiedUltimateCompletionDate
		, DATEDIFF(day, cd.MinOfEffectiveDate, cd.UnmodifiedUltimateCompletionDate) as UnmodifiedUltimateDuration
		,	C.obligatedamount AS SumOfobligatedAmount 
		,	C.numberofactions AS SumOfnumberOfActions
		--Contract Labels
, ilabel.ContractLabelText as IDVlabel
	, clabel.ContractLabelText as ContractLabel
	, tlabel.ContractLabelText as TransactionLabel
	, coalesce(tlabel.ContractLabelText,clabel.ContractLabelText , ilabel.ContractLabelText) as Label
	, coalesce(tlabel.IsOfficialPBL,clabel.IsOfficialPBL , ilabel.IsOfficialPBL) as IsOfficialPBL
	, coalesce(tlabel.IsPerformanceBasedLogistics,clabel.IsPerformanceBasedLogistics , ilabel.IsPerformanceBasedLogistics) as IsPerformanceBasedLogistics
	, ccid.CSIScontractID
	

	
FROM            Contract.FPDS AS C
	LEFT OUTER JOIN FPDSTypeTable.ProductOrServiceCode AS PSC 
		ON C.productorservicecode = PSC.ProductorServiceCode 
	LEFT OUTER JOIN FPDSTypeTable.AgencyID AS Agency 
		ON C.contractingofficeagencyid = Agency.AgencyID 
	LEFT OUTER JOIN FPDSTypeTable.TypeOfSetAside AS SetAside 
		ON C.typeofsetaside = SetAside.TypeOfSetAside 
	LEFT OUTER JOIN FPDSTypeTable.extentcompeted AS Competed 
		ON C.extentcompeted = Competed.extentcompeted 
	LEFT OUTER JOIN FPDSTypeTable.ReasonNotCompeted AS NotCompeted 
		ON C.reasonnotcompeted = NotCompeted.reasonnotcompeted 
	LEFT OUTER JOIN FPDSTypeTable.Country3lettercode as CountryCode 
		ON (C.placeofperformancecountrycode=CountryCode.Country3LetterCode)
	LEFT OUTER JOIN FPDSTypeTable.statutoryexceptiontofairopportunity as FairOpp 
		ON C.statutoryexceptiontofairopportunity=FAIROpp.statutoryexceptiontofairopportunity
	LEFT JOIN FPDSTypeTable.reasonformodification as Rmod
		ON C.reasonformodification=Rmod.reasonformodification
	left join FPDSTypeTable.typeofcontractpricing as pricing
		on c.typeofcontractpricing=pricing.TypeOfContractPricing

--Vendor Size
	LEFT JOIN Contractor.DunsnumberToParentContractorHistory AS PCH
		ON (C.Dunsnumber=PCH.Dunsnumber)
		AND (C.fiscal_year=PCH.FiscalYear)
	LEFT JOIN Contractor.ParentContractor As Parent
		ON (PCH.ParentID=Parent.ParentID)

--Block of CSISIDjoins
		left join contract.csistransactionid as CTID
			on c.CSIStransactionID=ctid.CSIStransactionID
		left join contract.CSISidvmodificationID as idvmod
			on ctid.CSISidvmodificationID=idvmod.CSISidvmodificationID
		left join contract.CSISidvpiidID as idv
			on idv.CSISidvpiidID=idvmod.CSISidvpiidID
		left join contract.ContractHistoryDiscretization as CHD
			on ctid.CSIScontractID=CHD.CSIScontractID
			and c.fiscal_year=chd.fiscal_year
		left join contract.ContractDiscretization as CD
			on ctid.CSIScontractID=CD.CSIScontractID
			

			--Block of vehicle lookups
		Left JOIN FPDSTypeTable.multipleorsingleawardidc as Cmulti
			on C.multipleorsingleawardidc=Cmulti.multipleorsingleawardidc
		Left JOIN FPDSTypeTable.multipleorsingleawardidc as IDVmulti
			on isnull(idvmod.multipleorsingleawardidc,idv.multipleorsingleawardidc)=IDVMulti.multipleorsingleawardidc
		Left JOIN FPDSTypeTable.ContractActionType as Ctype
			on C.ContractActionType=Ctype.unseperated
		Left JOIN FPDSTypeTable.ContractActionType as IDVtype
			on isnull(idvmod.ContractActionType,idv.ContractActionType)=IDVtype.unseperated
	
	
	
	left outer join contract.ContractLabelID as tlabel
		on ctid.ContractLabelID=tlabel.ContractLabelID
	left outer join contract.CSIScontractID as cCID
		on ctid.CSIScontractID=ccid.CSIScontractID
	left outer join contract.ContractLabelID as clabel
		on ccid.ContractLabelID=clabel.ContractLabelID
	left outer join contract.CSISidvpiidID as ciid
		on ccid.CSISidvpiidID=ciid.CSISidvpiidID
	left outer join contract.ContractLabelID as ilabel
		on ciid.ContractLabelID=ilabel.ContractLabelID
		
				
--GROUP BY 
--	C.fiscal_year
--	,PSC.ServicesCategory
--	,PSC.IsService
--	, ISNULL(Agency.Customer, Agency.AgencyIDtext)
--	, Agency.SubCustomer
--	,c.numberofoffersreceived
--	,CASE 
--				--Award or IDV Type show only (‘Definitive Contract’, ‘IDC’, ‘Purchase Order’)
--				WHEN ctype.ForAwardUseExtentCompeted=1
--				then 0 --Use extent competed
--				--Award or IDV Type show only (‘Delivery Order’, ‘BPA Call’)
--				--IDV Part 8 or Part 13 show only (‘Part 13’)
--				--When  **Part 8 or Part 13  is not available!**
--				--then 0 --Use extent competed

--				--Award or IDV Type show only (‘Delivery Order’)
--				--IDV Multiple or Single Award IDV show only (‘S’)
--				when ctype.isdeliveryorder=1
--					and isnull(IDVmulti.ismultipleaward, Cmulti.ismultipleaward) =0
--				then 0
				
				

--				--Fair Opportunity / Limited Sources show only (‘Fair Opportunity Given’)
--				--Award or IDV Type show only (‘Delivery Order’)
--				--IDV Type show only (‘FSS’, ‘GWAC’, ‘IDC’)
--				--	IDV Multiple or Single Award IDV show only (‘M’)
--				when idvtype.ForIDVUseFairOpportunity=1 and 
--					ctype.isdeliveryorder=1 and 
--					isnull(IDVmulti.ismultipleaward, Cmulti.ismultipleaward) =1
--				then 1 --Use fair opportunity

--				--	Number of Offers Received show only (‘1’)
--				-- Award or IDV Type show only (‘BPA Call’, ‘BPA’)
--				-- Part 8 or Part 13 show only (‘Part 8’)
--				--When  **Part 8 or Part 13  is not available!**
--				--then 0 --Use extent competed

--				when fairopp.statutoryexceptiontofairopportunitytext is not null
--				then 1
--				else 0
--			end 
--	,competed.IsFullAndOpen
--	,competed.IsSomeCompetition
--	,competed.IsFollowOnToCompetedAction
--	,competed.IsOnlyOneSource
--	,Fairopp.isfollowontocompetedaction 
--	,Fairopp.isonlyonesource 
--	,Fairopp.IsSomeCompetition
--	,notcompeted.isfollowontocompetedaction
--	,notcompeted.is6_302_1exception
--	,setaside.typeofsetaside2category
--	,CountryCode.Country3LetterCodeText
--	,CountryCode.Region
--	,ISNULL(setaside.typeofsetaside2category, 'Unlabeled')
--	, chd.SizeOfSumOfObligatedAmount
--	, chd.SizeOfSumOfbaseandexercisedoptionsvalue
--	, chd.SizeOfSumOfbaseandalloptionsvalue
) c
 
 












 


































GO


