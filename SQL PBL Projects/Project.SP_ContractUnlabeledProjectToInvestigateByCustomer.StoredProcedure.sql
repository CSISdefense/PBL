USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[SP_ContractUnlabeledProjectToInvestigateByCustomer]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



















-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	List the top unlabeled DUNSnumbers
-- =============================================
CREATE PROCEDURE [Project].[SP_ContractUnlabeledProjectToInvestigateByCustomer]
	-- Add the parameters for the stored procedure here
	
	@Customer varchar(255)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	if (@Customer is null) 
	begin
		-- Insert statements for procedure here
		SELECT [CSIScontractID]
      ,[idvpiid]
      ,[piid]
      ,min(fiscal_year) as  MinFiscalYear
			,max(fiscal_year) as  MaxFiscalYear
			
      ,[Customer]
      ,[SubCustomer]
      ,[AgencyIDtext]
	  ,Funder
	  ,SubFunder
	  ,FundingAgencyIDtext
      ,[ProductOrServiceArea]
      ,[PlatformPortfolio]
      ,[ClaimantProgramCodeText]
      ,[ProductOrServiceCode]
      ,[PSCText]
      ,[RnD_BudgetActivity]
	  ,[ContractRequirement]
	  ,ContractSumofObligatedAmount
      ,sum([obligatedamount]) as [obligatedamount]
      ,sum([numberofactions]) AS [numberofactions]
      --,[ProjectID]
      --,[UnmodifiedProjectID]    
  FROM [DIIG].[Project].[ContractProjectToInvestigate]



where isnull([AnyIdentifiedProject] ,0) =0 and ContractSumofObligatedAmount>=500000000
GROUP BY [CSIScontractID]
      ,[idvpiid]
      ,[piid]
  ,[Customer]
      ,[SubCustomer]
      ,[AgencyIDtext]
	    ,Funder
	  ,SubFunder
	  ,FundingAgencyIDtext
      ,[ProductOrServiceArea]
      ,[PlatformPortfolio]
      ,[ClaimantProgramCodeText]
      ,[ProductOrServiceCode]
      ,[PSCText]
      ,[RnD_BudgetActivity]
	  ,[ContractRequirement]
	  ,ContractSumofObligatedAmount
	 
		Order by ContractSumofObligatedAmount desc,CSIScontractID
  END
  else
  begin
		SELECT  [CSIScontractID]
      ,[idvpiid]
      ,[piid]
      ,min(fiscal_year) as  MinFiscalYear
			,max(fiscal_year) as  MaxFiscalYear
			
      ,[Customer]
      ,[SubCustomer]
      ,[AgencyIDtext]
      ,[ProductOrServiceArea]
      ,[PlatformPortfolio]
      ,[ClaimantProgramCodeText]
      ,[ProductOrServiceCode]
      ,[PSCText]
      ,[RnD_BudgetActivity]
	  ,[ContractRequirement]
	  ,ContractSumofObligatedAmount
      ,sum([obligatedamount]) as [obligatedamount]
      ,sum([numberofactions]) AS [numberofactions]
      --,[ProjectID]
      --,[UnmodifiedProjectID]    
  FROM [DIIG].[Project].[ContractProjectToInvestigate]



where isnull([AnyIdentifiedProject] ,0) =0 and 
	ContractSumofObligatedAmount>=500000000 and
	Customer=@Customer
GROUP BY [CSIScontractID]
      ,[idvpiid]
      ,[piid]
  ,[Customer]
      ,[SubCustomer]
      ,[AgencyIDtext]
      ,[ProductOrServiceArea]
      ,[PlatformPortfolio]
      ,[ClaimantProgramCodeText]
      ,[ProductOrServiceCode]
      ,[PSCText]
      ,[RnD_BudgetActivity]
	  ,[ContractRequirement]
	  ,ContractSumofObligatedAmount
	 
		Order by ContractSumofObligatedAmount desc,CSIScontractID
		
	end


END




















GO
