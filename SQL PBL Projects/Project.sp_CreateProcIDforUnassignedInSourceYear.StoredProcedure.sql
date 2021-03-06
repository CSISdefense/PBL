USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_CreateProcIDforUnassignedInSourceYear]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_CreateProcIDforUnassignedInSourceYear]
	-- Add the parameters for the stored procedure here
	--@AccountDSI smallint
	--,@Account smallint
	--,@BudgetActivity smallint
	--,@BSA smallint
	--,@LineItem varchar(10)
	--,@TopLineItemTitle varchar(31)
	--,@Category varchar(31)
	@SourceFiscalYear int
	--,@EndSourceFiscalYear int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--	if @AccountDSI is null
	--	raiserror('The value for @AccountDSI shold not be null.',15,1)
	
	--	if @Account is null
	--	raiserror('The value for @Account shold not be null.',15,1)
	
	--	if @BudgetActivity is null
	--	raiserror('The value for @BudgetActivity shold not be null.',15,1)
	
	--	if @BSA is null
	--	raiserror('The value for @BSA shold not be null.',15,1)
	

	--if @LineItem is null
	--	raiserror('The value for @LineItem shold not be null.',15,1)
	
	----if @ProcID is null
	----	raiserror('The value for @ProjectID shold not be null. To erase a parentid, use contractor.sp_EraseParentID',15,1)
	----if @startyear is null
	----	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	----if @endyear is null
	----	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	----if @endyear<@startyear
	----	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)
	

	--if not exists (select LineItem from Project.LineItem 
	--		where (AccountDSI=@AccountDSI or @AccountDSI is null) and
	--			(MainAccountCode=@Account or @Account is null) and
	--			(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
	--			(BSA=@BSA or @BSA is null) and
	--			LineItem=@LineItem 
	--		)
	--	raiserror('The LineItem entry does not exist',15,1)


	--if  exists (select ProcID,StartSourceFiscalYear, EndSourceFiscalYear from Project.LineItemToProcIDhistory
	--		where (AccountDSI=@AccountDSI or @AccountDSI is null) and
	--			(MainAccountCode=@Account or @Account is null) and
	--			(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
	--			(BSA=@BSA or @BSA is null) and
	--			LineItem=@LineItem and
	--			((EndSourceFiscalYear >= @StartSourceFiscalYear and  StartSourceFiscalYear <= @EndSourceFiscalYear ) 
	--		))
	--begin
	--	(select ProcID,StartSourceFiscalYear, EndSourceFiscalYear from Project.LineItemToProcIDhistory
	--		where (AccountDSI=@AccountDSI or @AccountDSI is null) and
	--			(MainAccountCode=@Account or @Account is null) and
	--			(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
	--			(BSA=@BSA or @BSA is null) and
	--			LineItem=@LineItem and
	--			((EndSourceFiscalYear >= @StartSourceFiscalYear and  StartSourceFiscalYear <= @EndSourceFiscalYear ) 
	--		)
	--)
	--	raiserror('The Date Range overlaps with an existing entry',15,1)
	--end
	-- --   Update Project.LineItemToProcIDhistory 
	--	--set EndSourceFiscalYear = @NewEndSourceFiscalYear
	--	--, CSISmodifiedDate=getdate()
	--	--, CSISmodifiedBy=SYSTEM_USER		 
	--	--	where (AccountDSI=@AccountDSI or @AccountDSI is null) and
	--	--		(MainAccountCode=@Account or @Account is null) and
	--	--		(BudgetActivity=@BudgetActivity or @BudgetActivity is null) and
	--	--		(BSA=@BSA or @BSA is null) and
	--	--		LineItem=@LineItem and
	--	--		Procid=@ProcID

	
		    -- Create the ProcID entries
	insert into Project.ProcID
	(TopAccountDSI
	,TopMainAccountCode
	,TopBudgetActivity
	,TopBSA
	,TopLineItem
	,TopLineItemTitle
	,CSISmodifiedBy
	,CSISmodifieddate)
	SELECT p1.[AccountDSI]
	,p1.[MainAccountCode]
	,p1.[BudgetActivity]
	      ,p1.[BSA]
		      ,p1.[LineItem]
	      ,[LineItemTitle]
		  	,system_user
	,getdate()
  FROM [DIIG].[budget].[DefenseP1sourceFiscalYear] p1
  where p1.ProcID is null and SourceFiscalYear=@SourceFiscalYear


  --CreateSingleYear LineItemToProcIDhistory entries using the just created ProcIDs
	insert into Project.LineItemCostTypeToProcIDHistory
	(AccountDSI
	,BudgetActivity
	,BSA
	,LineItem
	,CostType
	,ProcID
	,StartSourceFiscalYear
	,EndSourceFiscalYear	
	,CSISmodifiedBy
	,CSISmodifieddate)
	select p1.[AccountDSI]
	,p1.[MainAccountCode]
	,p1.[BudgetActivity]
	,p1.[BSA]
	,p1.[LineItem]
	,ProcID.ProcID
	,@SourceFiscalYear
	,@SourceFiscalYear
	,system_user
	,getdate()
  FROM [DIIG].[budget].[DefenseP1sourceFiscalYear] p1
    inner join Project.ProcID ProcID
  on ProcID.[TopAccountDSI]=p1.AccountDSI
  and ProcID.TopMainAccountCode=p1.MainAccountCode
  and ProcID.TopBudgetActivity=p1.BudgetActivity
  and ProcID.TopLineItem=p1.LineItem
  and ProcID.TopLineItemTitle=p1.LineItemTitle
  --and li2proc.StartSourceFiscalYear<=p1.SourceFiscalYear
  --and li2proc.EndSourceFiscalYear>=p1.SourceFiscalYear
    where p1.ProcID is null and SourceFiscalYear=@SourceFiscalYear

	

END














GO
