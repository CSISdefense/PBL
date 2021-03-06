USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[sp_CreateContractLabelIDfromProjectAbbreviation]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














-- =============================================
-- Author:		Greg Sanders
-- Create date: 2013-03-13
-- Description:	Assign a parent ID to a dunsnumber for a range of years
-- =============================================
CREATE PROCEDURE [Project].[sp_CreateContractLabelIDfromProjectAbbreviation]
	-- Add the parameters for the stored procedure here
	@ProjectAbbreviation varchar(4)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE	@return_value int

	if @ProjectAbbreviation is null
		raiserror('The value for @ProjectAbbreviation shold not be null.',15,1)
	



declare @ProjectID int
set @ProjectID = (select ProjectID from Project.ProjectID
			where ProjectAbbreviation=@ProjectAbbreviation
			)



declare @LabelText varchar(50)
set @LabelText = (select left(ProjectName,50) from Project.ProjectID
			where ProjectAbbreviation=@ProjectAbbreviation
			)




if  exists (select ContractLabelID
	,ContractLabelText
	,PrimaryProjectID
from contract.ContractLabelID
	where PrimaryProjectID=@ProjectId
			)
			begin
			select ContractLabelID
	,ContractLabelText
	,PrimaryProjectID
from contract.ContractLabelID
	where PrimaryProjectID=@ProjectID

		raiserror('The @ProjectAbbreviation is already associated with a ContractLabelID',15,1)


		end
	else
	begin
EXEC	@return_value = [Contract].[SP_CreateContractLabelID]
		@contractlabeltext = @LabelText,
		@PrimaryProjectID = @ProjectID,
		@TFBSOoriginated = NULL,
		@TFBSOmentioned = NULL,
		@IsPerformanceBasedLogistics = NULL

SELECT	'Return Value' = @return_value


end
end












GO
