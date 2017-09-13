USE [DIIG]
GO

/****** Object:  StoredProcedure [Contract].[SP_PBLscoreSubCustomer]    Script Date: 9/13/2017 1:50:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







ALTER PROCEDURE [Contract].[SP_PBLscoreSubCustomer]

@Customer VARCHAR(255)
AS

	IF (@Customer is not null) --Begin sub path where all product and services but only one Customer will be returned
	BEGIN
		--Copy the start of your query here
		SELECT S.fiscal_year
			,S.Query_Run_Date
			,S.Customer
			,S.SubCustomer
			,S.ProductOrServiceArea
			,S.CompetitionClassification
			,s.ClassifyNumberOfOffers
			,s.VehicleClassification
			,s.VendorSize
			,s.SizeOfSumOfObligatedAmount
			,UnmodifiedUltimateDuration
					,s.Label
			,s.IDVlabel
			,s.ContractLabel
			,s.TransactionLabel
			,s.IsOfficialPBL
			
			,[PBLscore] as PSCscore

      ,iif([CompetitionClassification] in 
		('No Competition (Only One Source Exception)',
		'No Competition (Only One Source Exception; Overrode blank Fair Opportunity)')
		,1,0) as MaxOfIsOnlyOneSource
		  ,iif([CompetitionClassification] in 
		('SINGLE AWARD IDC',
		'SINGLE AWARD INDEFINITE DELIVERY CONTRACT')
		,1,0) as MaxOfIsSingleAward
      ,case [UnmodifiedUltimateDuration]
	  		when '>2-4 Years'
			then 1
			when '>4 years'
			then 2
			else 0
		end as LengthScore
		,case
	  		when IsFixedPrice=1 and IsFixedPrice=1
			then 2
			when IsFixedPrice=1
			then 1
			else 0
		end as PricingScore






			,sum(S.SumOfobligatedAmount) as SumOfobligatedAmount
			,sum(S.SumOfnumberOfActions) as SumOfnumberOfActions
		FROM contract.CompetitionContractSizeHistoryBucketSubCustomerClassification as S
		--Here's the where clause for @ServicesOnly is null and Customer is not null
		WHERE S.Customer=@Customer  and IsPerformanceBasedLogistics=1
		--Copy the end of your query here
		GROUP BY S.fiscal_year
			,S.Query_Run_Date
			,S.Customer
			,S.SubCustomer
			,S.ProductOrServiceArea
			,S.CompetitionClassification
			,s.ClassifyNumberOfOffers
			,s.VehicleClassification
			,s.VendorSize
			,s.SizeOfSumOfObligatedAmount
			,UnmodifiedUltimateDuration
					,s.Label
			,s.IDVlabel
			,s.ContractLabel
			,s.TransactionLabel
			,s.IsOfficialPBL
			,PBLscore
      ,iif([CompetitionClassification] in 
		('No Competition (Only One Source Exception)',
		'No Competition (Only One Source Exception; Overrode blank Fair Opportunity)')
		,1,0)
		  ,iif([CompetitionClassification] in 
		('SINGLE AWARD IDC',
		'SINGLE AWARD INDEFINITE DELIVERY CONTRACT')
		,1,0)
      ,case [UnmodifiedUltimateDuration]
	  		when '>2-4 Years'
			then 1
			when '>4 years'
			then 2
			else 0
		end 
		,case
	  		when IsFixedPrice=1 and IsFixedPrice=1
			then 2
			when IsFixedPrice=1
			then 1
			else 0
		end 
		--End of your query
		END
	ELSE --Begin sub path where all products and services amd all Customers will be returned
		BEGIN
		--Copy the start of your query here
		SELECT S.fiscal_year
			,S.Query_Run_Date
			,S.SubCustomer
			,S.ProductOrServiceArea
			,S.CompetitionClassification
			,s.ClassifyNumberOfOffers
			,s.VehicleClassification
			,s.VendorSize
			,s.SizeOfSumOfObligatedAmount
			,UnmodifiedUltimateDuration
					,s.Label
			,s.IDVlabel
			,s.ContractLabel
			,s.TransactionLabel
			,s.IsOfficialPBL
			
				,[PBLscore] as PSCscore

      ,iif([CompetitionClassification] in 
		('No Competition (Only One Source Exception)',
		'No Competition (Only One Source Exception; Overrode blank Fair Opportunity)')
		,1,0) as MaxOfIsOnlyOneSource
		  ,iif([CompetitionClassification] in 
		('SINGLE AWARD IDC',
		'SINGLE AWARD INDEFINITE DELIVERY CONTRACT')
		,1,0) as MaxOfIsSingleAward
      ,case [UnmodifiedUltimateDuration]
	  		when '>2-4 Years'
			then 1
			when '>4 years'
			then 2
			else 0
		end as LengthScore
		,case
	  		when IsFixedPrice=1 and IsFixedPrice=1
			then 2
			when IsFixedPrice=1
			then 1
			else 0
		end as PricingScore


			,sum(S.SumOfobligatedAmount) as SumOfobligatedAmount
			,sum(S.SumOfnumberOfActions) as SumOfnumberOfActions
		FROM contract.CompetitionContractSizeHistoryBucketSubCustomerClassification as S
		--There is no Where clause, because everything is being returned
		where IsPerformanceBasedLogistics=1
		--Copy the end of your query here
		GROUP BY S.fiscal_year
			,S.Query_Run_Date
			,S.SubCustomer
			,S.ProductOrServiceArea
			,S.CompetitionClassification
			,s.ClassifyNumberOfOffers
			,s.VehicleClassification
			,s.VendorSize
			,s.SizeOfSumOfObligatedAmount
			,UnmodifiedUltimateDuration
					,s.Label
			,s.IDVlabel
			,s.ContractLabel
			,s.TransactionLabel
			,s.IsOfficialPBL
				,[PBLscore] 

      ,iif([CompetitionClassification] in 
		('No Competition (Only One Source Exception)',
		'No Competition (Only One Source Exception; Overrode blank Fair Opportunity)')
		,1,0)
		  ,iif([CompetitionClassification] in 
		('SINGLE AWARD IDC',
		'SINGLE AWARD INDEFINITE DELIVERY CONTRACT')
		,1,0)
      ,case [UnmodifiedUltimateDuration]
	  		when '>2-4 Years'
			then 1
			when '>4 years'
			then 2
			else 0
		end 
		,case
	  		when IsFixedPrice=1 and IsFixedPrice=1
			then 2
			when IsFixedPrice=1
			then 1
			else 0
		end 

		--End of your query
		END
























GO


