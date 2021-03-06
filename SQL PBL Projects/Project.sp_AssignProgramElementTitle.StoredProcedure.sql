USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_AssignProgramElementTitle]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_AssignProgramElementTitle]
	-- Add the parameters for the stored procedure here
	@ProgramElementNumber varchar(10)
	,@ProgramElementTitle varchar(80)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @ProgramElementNumber is null
		raiserror('The value for @ProgramElementNumber shold not be null.',15,1)
	
	if @ProgramElementTitle is null
		raiserror('The value for @@ProgramElementTitle shold not be null.',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)


	declare @ProgramElementInteger int

	set @ProgramElementInteger=  case
		when try_parse(left(@ProgramElementNumber,len(@ProgramElementNumber)-1) as int) is not null
		then right(@ProgramElementNumber,1)
		when try_parse(left(@ProgramElementNumber,len(@ProgramElementNumber)-2) as int) is not null
		then right(@ProgramElementNumber,2)
		when try_parse(left(@ProgramElementNumber,len(@ProgramElementNumber)-3) as int) is not null
		then right(@ProgramElementNumber,3)
		end


	if not exists (select ProgramElementNumber from Project.ProgramElementNumber 
			where ProgramElementNumber=@ProgramElementNumber
			)
		raiserror('The ProgramElementNumber does not yet exist',15,1)

	
	    -- Insert statements for procedure here
	update Project.ProgramElementNumber
	set ProgramElementTitle=@ProgramElementTitle
	where ProgramElementNumber=@ProgramElementNumber
	

END








GO
