USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_ExtendProcIDsourceEndYear]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_ExtendProcIDsourceEndYear]
	-- Add the parameters for the stored procedure here
	@TreasuryAgencyCode smallint
	,@Account smallint
	,@BudgetActivity smallint
	,@BSA smallint
	,@LineItem varchar(10)
	,@ProcID int
	,@NewEndSourceFiscalYear int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		--if @TreasuryAgencyCode is null
		--raiserror('The value for @TreasuryAgencyCode shold not be null.',15,1)
	
		--if @Account is null
		--raiserror('The value for @Account shold not be null.',15,1)
	
		--if @BudgetActivity is null
		--raiserror('The value for @BudgetActivity shold not be null.',15,1)
	
		--if @BSA is null
		--raiserror('The value for @BSA shold not be null.',15,1)
	

	if @LineItem is null
		raiserror('The value for @LineItem shold not be null.',15,1)
	
	if @ProcID is null
		raiserror('The value for @ProjectID shold not be null. To erase a parentid, use contractor.sp_EraseParentID',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)


	if not exists (select ProcID from Project.ProcID
			where ProcID=ProcID
			)
		raiserror('The ProcID does not exist',15,1)

	
	

	if not exists (select LineItem from Project.LineItemToProcIDhistory 
			where (TreasuryAgencyCode=@TreasuryAgencyCode or @TreasuryAgencyCode is null) and
				(MainAccountCode=@Account or @Account is null) and
				(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
				(BSA=@BSA or @BSA is null) and
				LineItem=@LineItem and
				Procid=@ProcID
			)
		raiserror('The LineItemToProcID entry does not yet exist',15,1)


	if  exists (select LineItem from Project.LineItemToProcIDhistory
			where (TreasuryAgencyCode=@TreasuryAgencyCode or @TreasuryAgencyCode is null) and
				(MainAccountCode=@Account or @Account is null) and
				(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
				(BSA=@BSA or @BSA is null) and
				LineItem=@LineItem and
				Procid=@ProcID and 
				EndSourceFiscalYear >= @NewEndSourceFiscalYear
			)
		raiserror('The EndSourceFiscalYear already matches or exceeds the passed year',15,1)

	    Update Project.LineItemToProcIDhistory 
		set EndSourceFiscalYear = @NewEndSourceFiscalYear
		, CSISmodifiedDate=getdate()
		, CSISmodifiedBy=SYSTEM_USER		 
			where (TreasuryAgencyCode=@TreasuryAgencyCode or @TreasuryAgencyCode is null) and
				(MainAccountCode=@Account or @Account is null) and
				(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
				(BSA=@BSA or @BSA is null) and
				LineItem=@LineItem and
				Procid=@ProcID

	



END












GO
