USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_CreateProjectIDfromProgramElementNumber]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_CreateProjectIDfromProgramElementNumber]
	-- Add the parameters for the stored procedure here
	@ProgramElementNumber int
	,@ProjectAbbreviation varchar(4)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@return_value int


	if @ProgramElementNumber is null
		raiserror('The value for @ProgramElementNumber shold not be null.',15,1)
	--if @parentid is null
	--	raiserror('The value for @parentid shold not be null. To erase a parentid, use contractor.sp_EraseParentID',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)
    -- Insert statements for procedure here


declare @ProgramElementTitle varchar(80)
set @ProgramElementTitle = (SELECT ProgramElementTitle
	from project.ProgramElementNumber
	where ProgramElementNumber=@ProgramElementNumber)

	select *
	from project.ProgramElementNumber




	if @ProgramElementTitle is null
	begin
		
EXEC	@return_value = [Project].[sp_InvestigateProgramElementNumber]
		@ProgramElementNumber = @ProgramElementNumber

SELECT	'Return Value' = @return_value

		raiserror('ProgramElementTitle is missing, investigate and assign it',15,1)
	end
else
	begin
select @ProgramElementTitle

INSERT INTO Project.ProjectID
           (ProjectName
		   ,ProjectAbbreviation
		   )
		   Values (@ProgramElementTitle
		   ,@ProjectAbbreviation)
	

declare @ProjectID int

set @projectID =(select projectid
	from project.projectid
	where ProjectName=@ProgramElementTitle
	group by projectid
	having projectid=max(projectid) -- ONly the newly created one in case duplicate names
	)



EXEC	@return_value = Project.sp_AssignProjectIDtoProgramElementNumber
		@ProgramElementNumber ,
		@ProjectID 
	
END


end










GO
