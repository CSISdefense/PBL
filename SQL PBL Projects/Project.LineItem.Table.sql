USE [DIIG]
GO
/****** Object:  Table [Project].[LineItem]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[LineItem](
	[AccountDSI] [varchar](5) NOT NULL,
	[BudgetActivity] [smallint] NOT NULL,
	[BSA] [smallint] NOT NULL,
	[LineItem] [varchar](10) NOT NULL,
	[LineItemTitle] [varchar](45) NULL,
	[DefenseOrganization] [varchar](5) NULL,
	[ProcurementCategory] [varchar](31) NULL,
 CONSTRAINT [pk_LineItem] PRIMARY KEY CLUSTERED 
(
	[AccountDSI] ASC,
	[BudgetActivity] ASC,
	[BSA] ASC,
	[LineItem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[LineItem]  WITH CHECK ADD FOREIGN KEY([DefenseOrganization])
REFERENCES [agency].[DefenseOrganization] ([DefenseOrganization])
GO
ALTER TABLE [Project].[LineItem]  WITH CHECK ADD FOREIGN KEY([ProcurementCategory])
REFERENCES [Project].[ProcurementCategory] ([ProcurementCategory])
GO
ALTER TABLE [Project].[LineItem]  WITH CHECK ADD  CONSTRAINT [fk_LineItem_AccountDSI] FOREIGN KEY([AccountDSI])
REFERENCES [budget].[AccountDSI] ([AccountDSI])
GO
ALTER TABLE [Project].[LineItem] CHECK CONSTRAINT [fk_LineItem_AccountDSI]
GO
ALTER TABLE [Project].[LineItem]  WITH CHECK ADD  CONSTRAINT [fk_LineItem_BSA] FOREIGN KEY([AccountDSI], [BudgetActivity], [BSA])
REFERENCES [budget].[BSA] ([AccountDSI], [BudgetActivity], [BSA])
GO
ALTER TABLE [Project].[LineItem] CHECK CONSTRAINT [fk_LineItem_BSA]
GO
ALTER TABLE [Project].[LineItem]  WITH CHECK ADD  CONSTRAINT [fk_LineItem_BudgetActivity] FOREIGN KEY([AccountDSI], [BudgetActivity])
REFERENCES [budget].[BudgetActivity] ([AccountDSI], [BudgetActivity])
GO
ALTER TABLE [Project].[LineItem] CHECK CONSTRAINT [fk_LineItem_BudgetActivity]
GO
