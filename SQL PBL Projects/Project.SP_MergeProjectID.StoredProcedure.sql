USE [DIIG]
GO
/****** Object:  StoredProcedure [Project].[SP_MergeProjectID]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Rhys McCormick>
-- Create date: <03/26/2013>
-- Description:	<Change the Name of a Parent Contractor	>
-- =============================================
CREATE PROCEDURE [Project].[SP_MergeProjectID]
	-- Add the parameters for the stored procedure here
		@mergedProjectID int
		,@DroppedProjectID int


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
if @DroppedProjectID is null
		raiserror('The value for @DroppedProjectID shold not be null. To create a ProjectID, use contractor.sp_CreateProjectID',15,1)
if @mergedProjectID is null
		raiserror('The value for @newProjectID shold not be null. To change a ProjectID, use contractor.sp_ChangeProjectID',15,1)
    
	-- Insert statements for procedure here
/*INSERT INTO Contractor.ParentContractor(ProjectID, Ticker, ShortName, BloombergID, DIIGIndex, LargeGreaterThan1B, LargeGreaterThan3B, PMC, HRFprivatemilitary, SIGIRprivemilitary, SIGIRDuns, Subsidiary, MergerYear, BgovID, HooverID, LexisNexisID, RevenueInMillions, RevenueYear, RevenueSourceLink, Replace, DropEntry, JointVenture, LastYear, FirstYear, SizeGuess, NumberOfYears, DACIM, UnknownCompany, FPDSannualRevenue, Top100Federal, AlwaysDisplay, Owners, MergerDate, MergerURL, OverrideBgovid, FirstURl, SpunOffFrom, Top6, StandardizedProjectID)
SELECT @newProjectID, Ticker, ShortName, BloombergID, DIIGIndex, LargeGreaterThan1B, LargeGreaterThan3B, PMC, HRFprivatemilitary, SIGIRprivemilitary, SIGIRDuns, Subsidiary, MergerYear, BgovID, HooverID, LexisNexisID, RevenueInMillions, RevenueYear, RevenueSourceLink, Replace, DropEntry, JointVenture, LastYear, FirstYear, SizeGuess, NumberOfYears, DACIM, UnknownCompany, FPDSannualRevenue, Top100Federal, AlwaysDisplay, Owners, MergerDate, MergerURL, OverrideBgovid, FirstURl, SpunOffFrom, Top6, StandardizedProjectID
FROM Contractor.ParentContractor WHERE ProjectID = @DroppedProjectID*/

UPDATE Project.SystemEquipmentCodetoProjectIDhistory 
SET ProjectID = @mergedProjectID
WHERE ProjectID = @DroppedProjectID


UPDATE Contract.ContractLabelID
SET PrimaryProjectID = @mergedProjectID
WHERE PrimaryProjectID = @DroppedProjectID


UPDATE Project.ProcIDtoProjectIDmanyToMany 
SET ProjectID = @mergedProjectID
WHERE ProjectID = @DroppedProjectID

UPDATE Project.RDTEidToProjectIDmanyToMany
SET ProjectID = @mergedProjectID
WHERE ProjectID = @DroppedProjectID


--Delete combined entry
DELETE FROM Project.ProjectID
WHERE ProjectID = @DroppedProjectID

END













GO
