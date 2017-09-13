USE [DIIG]
GO

/****** Object:  StoredProcedure [Contract].[SP_PBLcompetitionContractSizeHistorySubCustomer]    Script Date: 9/13/2017 1:51:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








ALTER PROCEDURE [Contract].[SP_PBLcompetitionContractSizeHistorySubCustomer]

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
			,s.IsPerformanceBasedLogistics
			
			,sum(S.SumOfobligatedAmount) as SumOfobligatedAmount
			,sum(S.SumOfnumberOfActions) as SumOfnumberOfActions
		FROM Contract.CompetitionContractSizeHistoryBucketSubCustomerClassification as S
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
			,s.IsPerformanceBasedLogistics
			
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
			,s.IsPerformanceBasedLogistics
			
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
			,s.IsPerformanceBasedLogistics
		--End of your query
		END

























GO


