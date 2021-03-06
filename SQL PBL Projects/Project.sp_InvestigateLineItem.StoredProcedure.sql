USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_InvestigateLineItem]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE  PROCEDURE [Project].[sp_InvestigateLineItem]
	-- Add the parameters for the stored procedure here

	@TreasuryAgencyCode smallint
	,@Account smallint
	,@BudgetActivity smallint
	,@BSA smallint
	,@LineItem varchar(10)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	if @LineItem is null
		begin 
		--raiserror('The value for @ProjectName should not be null.',15,1)
	SELECT  [TreasuryAgencyCode]
      ,[Account]
      ,[BudgetActivity]
      ,[BSA]
      ,[LineItem]
      ,[LineItemTitle]
	  from project.LineItem
  
  end
  else
  begin
  	SELECT [TreasuryAgencyCode]
      ,[Account]
      ,[BudgetActivity]
      ,[BSA]
      ,[LineItem]
      ,[LineItemTitle]
	  from project.LineItem
  where TreasuryAgencyCode=@TreasuryAgencyCode and
				Account=@Account and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem 

 SELECT p.[ProjectID]
      ,[ProjectName]
      ,[ProjectAbbreviation]
      ,[IsJointDevelopmentCaseStudy]
  FROM [DIIG].[Project].[ProjectID] p
  inner join Project.LineItemToProjectIDmanyToMany  pen
  on p.ProjectID=pen.ProjectID
  where TreasuryAgencyCode=@TreasuryAgencyCode and
				Account=@Account and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem 

SELECT [ID]
	,[TreasuryAgencyCode]
      ,[Account]
      ,[BudgetActivity]
      ,[BudgetActivityTitle]
      ,[BSA]
      ,[BSAtitle]
      ,[LineItem]
      ,[LineItemTitle]
      ,[CostType]
      ,[CostTypeTitle]
      ,[Category]
      ,[Classified]
      ,[FiscalYear]
      ,[PB]
      ,[App]
      ,[Actual]
      ,[CR]
      ,[CR_OCO]
      ,[OCO_PB]
      ,[OCO_App]
      ,[OCO_Sup]
      ,[Quant_PB]
      ,[Quant_App]
      ,[Quant_Actual]
      ,[Quant_CR]
      ,[Quant_CR_OCO]
      ,[Quant_OCO_PB]
      ,[Quant_OCO_App]
      ,[Quant_OCO_Sup]
  FROM [DIIG].[budget].[DefenseP1] p1
  where TreasuryAgencyCode=@TreasuryAgencyCode and
				Account=@Account and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem 

	end
		--Verify that the parameter is already in the relevant type table.
	--if(select p.systemequipmentcodeText
	--	from Project.systemequipmentcode as p
	--	where p.systemequipmentcodeText=@ProjectName) is null 
	--begin
	--	--If there's a similar value to the missing one, suggest that instead.
	--	if (select top 1 p.systemequipmentcodeText
	--			from Project.systemequipmentcode as p
	--			where p.systemequipmentcodeText like '%'+@ProjectName+'%') is not null 
	--	begin
	--		select  p.systemequipmentcodeText
	--			from Project.systemequipmentcode as p
	--			where p.systemequipmentcodeText like '%'+@ProjectName+'%'
	--		select 'The value for @ProjectName is not found in FPDSTypeTable.systemequipmentcode. Did you mean one of the above?' as ErrorDescription
	--		return -1
	--	end
	--	--If there's no similar value, return an error, they'll have to check the table themselves.
	--	else
	--	begin
	--			select s.systemequipmentcodeText
	--			, s.systemequipmentcode
	--from Project.systemequipmentcode as s
	--order by s.systemequipmentcodeText
	----where [systemequipmentcodeText] =@ProjectName

	--		select 'The value for @ProjectName is not found in FPDSTypeTable.systemequipmentcode. Above is a complete listing' as ErrorDescription
			
	--		--raiserror('The value for @ProjectName is not found in FPDSTypeTable.systemequipmentcode.',15,1)
	--	end
	--end
	----End input protection

	--else
	--begin


	--select *
	--from Project.systemequipmentcode as s
	--where [systemequipmentcodeText] =@ProjectName

	----SELECT [systemequipmentcodeText]
 ----     ,[Customer]
 ----     ,[ServicesCategory]
 ----     ,[SumOfobligatedAmount]
 ----     ,[SumOfnumberOfActions]
 ----     ,[SumOfbaseandexercisedoptionsvalue]
 ----     ,[SumOfbaseandalloptionsvalue]
 ---- FROM [DIIG].[SystemEquipment].[SystemEquipmentHistoryBucketCustomer]
	----where [systemequipmentcodeText] =@ProjectName

 
 --end


END




















GO
