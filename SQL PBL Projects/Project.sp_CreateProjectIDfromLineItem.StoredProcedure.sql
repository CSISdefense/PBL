USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_CreateProjectIDfromLineItem]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_CreateProjectIDfromLineItem]
	-- Add the parameters for the stored procedure here
	@TreasuryAgencyCode smallint
	,@Account smallint
	,@BudgetActivity smallint
	,@BSA smallint
	,@LineItem varchar(10)
	,@ProjectAbbreviation varchar(4)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@return_value int

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
	

	if @LineItem is null
		raiserror('The value for @LineItem shold not be null.',15,1)
	

	if @ProjectAbbreviation is null
		raiserror('The value for @ProjectAbbreviation shold not be null.',15,1)
	--if @parentid is null
	--	raiserror('The value for @parentid shold not be null. To erase a parentid, use contractor.sp_EraseParentID',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)
    -- Insert statements for procedure here


declare @LineItemTitle varchar(80)
set @LineItemTitle = (select LineItemTitle from Project.LineItem
			where TreasuryAgencyCode=@TreasuryAgencyCode and
				Account=@Account and
				BudgetActivity=@BudgetActivity and
				BSA=@BSA and
				LineItem=@LineItem )


	if @LineItemTitle is null
	begin
		
EXEC	@return_value = [Project].[sp_InvestigateLineItem]
	@TreasuryAgencyCode =@TreasuryAgencyCode 
	,@Account =@Account 
	,@BudgetActivity =@BudgetActivity 
	,@BSA =@BSA
		,@LineItem = @LineItem

SELECT	'Return Value' = @return_value

		raiserror('LineItemTitle is missing, investigate and assign it',15,1)
	end
else
	begin
select @LineItemTitle

INSERT INTO Project.ProjectID
           (ProjectName
		   ,ProjectAbbreviation
		   )
		   Values (@LineItemTitle
		   ,@ProjectAbbreviation)
	

declare @ProjectID int

set @projectID =(select projectid
	from project.projectid
	where ProjectName=@LineItemTitle
	group by projectid
	having projectid=max(projectid) -- ONly the newly created one in case duplicate names
	)



EXEC	@return_value = [Project].[sp_AssignProjectIDtoLineItem]
		@TreasuryAgencyCode = @TreasuryAgencyCode,
		@Account = @Account ,
		@BudgetActivity = @BudgetActivity ,
		@BSA = @BSA,
		@LineItem = @LineItem,
		@ProjectID = @ProjectID

END


end











GO
