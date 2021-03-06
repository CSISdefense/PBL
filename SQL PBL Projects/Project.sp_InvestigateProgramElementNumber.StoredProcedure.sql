USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_InvestigateProgramElementNumber]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE  PROCEDURE [Project].[sp_InvestigateProgramElementNumber]
	-- Add the parameters for the stored procedure here
	@ProgramElementNumber int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	if @ProgramElementNumber is null
		begin 
		--raiserror('The value for @ProjectName should not be null.',15,1)
	SELECT [ProgramElementNumber]
      ,[ProgramElementTitle]
      ,[classified]
      ,[DefenseServiceIdentifier]
	  from project.ProgramElementNumber
  
  end
  else
  begin
  	SELECT [ProgramElementNumber]
      ,[ProgramElementTitle]
      ,[classified]
      ,[DefenseServiceIdentifier]
	  from project.ProgramElementNumber
  where ProgramElementNumber=@ProgramElementNumber

 SELECT p.[ProjectID]
      ,[ProjectName]
      ,[ProjectAbbreviation]
      ,[IsJointDevelopmentCaseStudy]
  FROM [DIIG].[Project].[ProjectID] p
  inner join Project.RDTEidToProjectIDmanyToMany  r2p
  on r2p.ProjectID=p.ProjectID
  inner join Project.ProgramElementBudgetActivityToRDTEidHistory pe2r
  on pe2r.RDTEid=r2p.RDTEid
  inner join Project.ProgramElement pe
  on pe.ProgramElement=pe2r.ProgramElement
  where pe.ProgramElementNumber=@ProgramElementNumber

SELECT  SourceFiscalYear
	,r1.[ProgramElement]
      ,r1.[ProgramElementTitle]
	  ,AccountDisplay
	  ,BAdisplay
      --,[BudgetActivity]
      --,[BudgetActivityTitle]
      --,AccountDSI
	  ,nullif(LineNumber,0) as LineNumber
      ,r1.[Classified]
      ,[FiscalYear]
      ,PBtotal
      ,PBtype
      ,EnactedTotal
      ,EnactedType
      ,SpecialType
      ,ActualTotal
      ,[TreasuryAgencyCode]
  FROM [DIIG].[budget].DefenseR1consolidated r1
  inner join project.ProgramElement pe
  on r1.ProgramElement=pe.ProgramElement
  where pe.ProgramElementNumber=@ProgramElementNumber
  order by r1.SourceFiscalYear,r1.ProgramElement,r1.FiscalYear
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
