USE [DIIG]
GO
/****** Object:  Table [Project].[ProcID]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[ProcID](
	[ProcID] [int] IDENTITY(1,1) NOT NULL,
	[Category] [varchar](31) NULL,
	[TopTreasuryAgencyCode] [smallint] NOT NULL,
	[TopMainAccountCode] [smallint] NOT NULL,
	[TopBudgetActivity] [smallint] NOT NULL,
	[TopBSA] [smallint] NOT NULL,
	[TopLineItem] [varchar](10) NOT NULL,
	[TopLineItemTitle] [varchar](45) NULL,
	[DefenseServiceIdentifier] [varchar](3) NULL,
	[Classified] [varchar](20) NULL,
	[CSISmodifiedBy] [varchar](128) NOT NULL,
	[CSISmodifiedDate] [datetime2](7) NOT NULL,
	[ProcurementCategory] [varchar](31) NULL,
	[IsHarrisonID] [bit] NOT NULL,
	[TopAccountDSI] [varchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProcID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[ProcID] ADD  DEFAULT (suser_sname()) FOR [CSISmodifiedBy]
GO
ALTER TABLE [Project].[ProcID] ADD  DEFAULT (getdate()) FOR [CSISmodifiedDate]
GO
ALTER TABLE [Project].[ProcID] ADD  DEFAULT ((0)) FOR [IsHarrisonID]
GO
ALTER TABLE [Project].[ProcID]  WITH CHECK ADD FOREIGN KEY([Category])
REFERENCES [Project].[ProcurementCategory] ([ProcurementCategory])
GO
ALTER TABLE [Project].[ProcID]  WITH CHECK ADD FOREIGN KEY([ProcurementCategory])
REFERENCES [Project].[ProcurementCategory] ([ProcurementCategory])
GO
ALTER TABLE [Project].[ProcID]  WITH CHECK ADD FOREIGN KEY([TopAccountDSI])
REFERENCES [budget].[AccountDSI] ([AccountDSI])
GO
