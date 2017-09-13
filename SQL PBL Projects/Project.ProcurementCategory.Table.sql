USE [DIIG]
GO
/****** Object:  Table [Project].[ProcurementCategory]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[ProcurementCategory](
	[ProcurementCategory] [varchar](31) NOT NULL,
 CONSTRAINT [pk_budget_ProcurementCategory] PRIMARY KEY CLUSTERED 
(
	[ProcurementCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
