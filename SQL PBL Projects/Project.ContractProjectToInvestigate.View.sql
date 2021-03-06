USE [DIIG]
GO
/****** Object:  View [Project].[ContractProjectToInvestigate]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [Project].[ContractProjectToInvestigate]
AS
SELECT      
CTID.CSIScontractID
, idv.CSISidvpiidID
, idv.idvpiid
, cid.piid
, C.fiscal_year
--, max(C.Fiscal_Year) as MaxOfFiscalYear
, ISNULL(Agency.Customer, Agency.AgencyIDtext) AS Customer
, Agency.SubCustomer
, Agency.AgencyIDtext
, ISNULL(Funder.Customer, Funder.AgencyIDtext) AS Funder
, Funder.SubCustomer SubFunder
, Funder.AgencyIDtext as FundingAgencyIDtext

, ProductOrServiceArea
,isnull(cpc.PlatformPortfolio,PSC.PlatformPortfolio) as PlatformPortfolio
, cpc.ClaimantProgramCodeText
,Proj.ProjectID
						  ,proj.UnmodifiedProjectID
						  ,proj.AnyIdentifiedProject
, psc.ProductOrServiceCode
, psc.ProductOrServiceCodeText as PSCText
, PSC.RnD_BudgetActivity
 , descriptionofcontractrequirement as ContractRequirement
, C.obligatedamount
, C.numberofactions
, proj.SumofObligatedAmount as ContractSumofObligatedAmount

						 --CountryCode.Country3LetterCodeText,
						 -- CountryCode.Region, 
						 -- pop_state_code as StateCode, 
						
						 --PSC.ProductOrServiceCodeText , 
						 --contractingofficeagencyid as ContractAgency, 
						 --C.contractingofficeid as ContractOffice, 
						 --CountryCode.ISOcountryCode as ISOCountryCode, 
						 --CountryCode.IsInternational as IsInternational,
						 --CountryCode.ISOGIS,						 
						  
						  -- CD.MinOfFiscal_Year


FROM Contract.FPDS AS C 
LEFT OUTER JOIN FPDSTypeTable.ProductOrServiceCode AS PSC 
ON C.productorservicecode = PSC.ProductOrServiceCode 
	LEFT OUTER JOIN FPDSTypeTable.AgencyID AS Agency 
	ON C.contractingofficeagencyid = Agency.AgencyID 
		LEFT OUTER JOIN FPDSTypeTable.AgencyID AS Funder
	ON C.fundingrequestingagencyid = Funder.AgencyID 
				 
		--LEFT OUTER JOIN FPDSTypeTable.Country3LetterCode AS CountryCode ON 
		--C.placeofperformancecountrycode = CountryCode.Country3LetterCode
						 
left outer join FPDSTypeTable.ClaimantProgramCode  as cpc 
on cpc.ClaimantProgramCode=c.claimantprogramcode

--Block of CSISIDjoins
              left join contract.csistransactionid as CTID
                     on ctid.CSIStransactionID=c.CSIStransactionID
              left join contract.CSISidvmodificationID as idvmod
                     on idvmod.CSISidvmodificationID=ctid.CSISidvmodificationID
              left join contract.CSISidvpiidID as idv
                     on idv.CSISidvpiidID=idvmod.CSISidvpiidID
              left join contract.CSIScontractID as cid
                     on cid.CSIScontractID=ctid.CSIScontractID					

----Block of Contract Connections
	left outer join Contract.ContractProject Proj
			ON Proj.CSIScontractID = CTID.CSIScontractID
	

--              left join Contract.ContractLabelID label
--                     on coalesce(ctid.ContractLabelID,cid.COntractlabelid,idv.ContractLabelID) = label.ContractLabelID
--              LEFT JOIN Project.SystemEquipmentCodetoProjectIDhistory as SYS
--                     ON SYS.systemequipmentcode=C.systemequipmentcode
--                     and SYS.StartFiscalYear <= c.fiscal_year
--                     and isnull(SYS.EndFiscalYear,9999) >= c.fiscal_year
--              left join project.projectID Proj
--                     on proj.projectid=isnull(sys.projectid,label.PrimaryProjectID)

			
--GROUP   BY C.fiscal_year
--, ISNULL(Agency.Customer
--, Agency.AgencyIDtext)
--, Agency.SubCustomer
--, Agency.AgencyIDtext
----,PSC.ServicesCategory
----,PSC.ProductsCategory
----, PSC.IsService
----, CountryCode.Country3LetterCodeText
----, CountryCode.Region
----, pop_state_code
--, descriptionofcontractrequirement
--, c.productorservicecode
--, PSC.ProductOrServiceCodeText 
--, contractingofficeagencyid
--, C.contractingofficeid
----, CountryCode.ISOcountryCode
----, CountryCode.IsInternational
----, CountryCode.ISOGIS
--, isnull(cpc.PlatformPortfolio,PSC.PlatformPortfolio)
--, Proj.ProjectID
--, Proj.ProjectAbbreviation
--, Proj.ProjectName
--, ProductOrServiceArea
--, PSC.RnD_BudgetActivity
--, CD.MinOfFiscal_Year




































GO
