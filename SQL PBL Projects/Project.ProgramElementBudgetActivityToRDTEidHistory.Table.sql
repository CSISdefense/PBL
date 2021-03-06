USE [DIIG]
GO
/****** Object:  Table [Project].[ProgramElementBudgetActivityToRDTEidHistory]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory](
	[ProgramElement] [varchar](10) NOT NULL,
	[AccountDSI] [varchar](5) NOT NULL,
	[BudgetActivity] [smallint] NOT NULL,
	[RDTEid] [int] NOT NULL,
	[StartSourceFiscalYear] [int] NOT NULL,
	[EndSourceFiscalYear] [int] NOT NULL,
	[CSISmodifiedBy] [varchar](150) NOT NULL,
	[CSISmodifiedDate] [datetime2](7) NOT NULL,
 CONSTRAINT [pk_ProgramElementHistory] PRIMARY KEY CLUSTERED 
(
	[ProgramElement] ASC,
	[AccountDSI] ASC,
	[BudgetActivity] ASC,
	[StartSourceFiscalYear] ASC,
	[EndSourceFiscalYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory] ADD  DEFAULT (suser_sname()) FOR [CSISmodifiedBy]
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory] ADD  DEFAULT (getdate()) FOR [CSISmodifiedDate]
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory]  WITH CHECK ADD  CONSTRAINT [fk_ProgramElementBudgetActivityToRDTEidHistory_BudgetActivity] FOREIGN KEY([AccountDSI], [BudgetActivity])
REFERENCES [budget].[BudgetActivity] ([AccountDSI], [BudgetActivity])
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory] CHECK CONSTRAINT [fk_ProgramElementBudgetActivityToRDTEidHistory_BudgetActivity]
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory]  WITH CHECK ADD  CONSTRAINT [fk_ProgramElementToRDTEidHistory] FOREIGN KEY([ProgramElement])
REFERENCES [Project].[ProgramElement] ([ProgramElement])
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory] CHECK CONSTRAINT [fk_ProgramElementToRDTEidHistory]
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory]  WITH CHECK ADD  CONSTRAINT [fk_ProgramElementToRDTEidHistory_RDTEid] FOREIGN KEY([RDTEid])
REFERENCES [Project].[RDTEid] ([RDTEid])
GO
ALTER TABLE [Project].[ProgramElementBudgetActivityToRDTEidHistory] CHECK CONSTRAINT [fk_ProgramElementToRDTEidHistory_RDTEid]
GO
