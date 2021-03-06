USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_AssignProcIDtoLineItem]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_AssignProcIDtoLineItem]
	-- Add the parameters for the stored procedure here
	@AccountDSI varchar(5)
	,@BudgetActivity int
	,@BSA smallint
	,@LineItem varchar(10)
	,@CostType varchar(1)
	,@ProcID int
	,@StartSourceFiscalYear int
	,@EndSourceFiscalYear int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		if @AccountDSI is null
		raiserror('The value for @AccountDSI shold not be null.',15,1)
	
		if @BudgetActivity is null
		raiserror('The value for @BudgetActivity shold not be null.',15,1)
	
		if @BSA is null
		raiserror('The value for @BSA shold not be null.',15,1)
	

	if @LineItem is null
		raiserror('The value for @LineItem shold not be null.',15,1)

		
	if @LineItem is null
		raiserror('The value for @CostTyep shold not be null.',15,1)
	
	if @ProcID is null
		raiserror('The value for @ProcID shold not be null.',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)


	if not exists (select ProcID from Project.ProcID 
			where ProcID=@ProcID
			)
		raiserror('The ProcID does not yet exist',15,1)

	
	

	if not exists (select LineItem from Project.LineItem 
			where AccountDSI=@AccountDSI and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem 
			)
		raiserror('The LineItem does not yet exist',15,1)


	if  exists (select ProcID from Project.LineItemCostTypeToProcIDHistory
			where ProcID=@ProcID and 
				AccountDSI=@AccountDSI and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem  and
				CostType=@CostType
			)
		raiserror('The ProcID and LineItem combination already exists',15,1)

	    -- Insert statements for procedure here
	insert into Project.LineItemCostTypeToProcIDHistory
	(AccountDSI
	,BudgetActivity
	,BSA
	,LineItem
	,ProcID
	,CostType
	,StartSourceFiscalYear
	,EndSourceFiscalYear
	,CSISmodifiedBy
	,csismodifieddate)
	VALUES (@AccountDSI
	,@BudgetActivity
	,@BSA
	,@LineItem
	,@CostType
	,@ProcID
	,@StartSourceFiscalYear
	,@EndSourceFiscalYear
	,system_user
	,getdate())




END













GO
