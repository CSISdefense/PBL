USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_AssignCategoryToProcID]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_AssignCategoryToProcID]
	-- Add the parameters for the stored procedure here
	@ProcID varchar(10)
	,@ProcurementCategory varchar(31)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @ProcID is null
		raiserror('The value for @ProcID shold not be null.',15,1)
	
	if @ProcurementCategory is null
		raiserror('The value for @ProcurementCategory shold not be null.',15,1)
	--if @startyear is null
	--	raiserror('The value for @startyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear is null
	--	raiserror('The value for @endyear shold not be null. If assigning a single year, @startyear and @endyear should match.',15,1)
	--if @endyear<@startyear
	--	raiserror('The value for @endyear must be greater than or equal to @startyear',15,1)


	
	
	    -- Insert statements for procedure here
	update Project.ProcID
	set ProcurementCategory=@ProcurementCategory
	where ProcID=@ProcID
	

END










GO
