USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_AssignProjectIDtoLineItem]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_AssignProjectIDtoLineItem]
	-- Add the parameters for the stored procedure here
	@TreasuryAgencyCode smallint
	,@Account smallint
	,@BudgetActivity smallint
	,@BSA smallint
	,@LineItem varchar(10)
	,@ProjectID int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		if @TreasuryAgencyCode is null
		raiserror('The value for @TreasuryAgencyCode shold not be null.',15,1)
	
		if @Account is null
		raiserror('The value for @Account shold not be null.',15,1)
	
		if @BudgetActivity is null
		raiserror('The value for @BudgetActivity shold not be null.',15,1)
	
		if @BSA is null
		raiserror('The value for @BSA shold not be null.',15,1)
	

	if @LineItem is null
		raiserror('The value for @LineItem shold not be null.',15,1)
	
	if @ProjectID is null
		raiserror('The value for @ProjectID shold not be null. To erase a parentid, use contractor.sp_EraseParentID',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)


	if not exists (select ProjectID from Project.ProjectID 
			where ProjectID=@ProjectID
			)
		raiserror('The ProjectID does not yet exist',15,1)

	
	

	if not exists (select LineItem from Project.LineItem 
			where TreasuryAgencyCode=@TreasuryAgencyCode and
				Account=@Account and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem 
			)
		raiserror('The LineItem does not yet exist',15,1)


	if  exists (select ProjectID from Project.LineItemToProjectIDmanyToMany
			where ProjectID=@ProjectID and 
				TreasuryAgencyCode=@TreasuryAgencyCode and
				Account=@Account and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem 
			)
		raiserror('The ProjectID and LineItem combination already exists',15,1)

	    -- Insert statements for procedure here
	insert into Project.LineItemToProjectIDmanyToMany
	(TreasuryAgencyCode
	,Account
	,BudgetActivity
	,BSA
	,LineItem
	,ProjectID
	,CSISmodifiedBy
	,csismodifieddate)
	VALUES (@TreasuryAgencyCode
	,@Account
	,@BudgetActivity
	,@BSA
	,@LineItem
	,@ProjectID
	,system_user
	,getdate())




END











GO
