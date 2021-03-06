USE [DIIG]
GO
/****** Object:  Table [Project].[ProgramElementNumber]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Project].[ProgramElementNumber](
	[ProgramElementNumber] [int] NOT NULL,
	[ProgramElementTitle] [varchar](80) NULL,
	[classified] [varchar](20) NULL,
	[DefenseServiceIdentifier] [varchar](3) NULL,
 CONSTRAINT [pk_ProgramElementNumber] PRIMARY KEY CLUSTERED 
(
	[ProgramElementNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Project].[ProgramElementNumber]  WITH CHECK ADD  CONSTRAINT [fk_ProgramElementNumber_DefenseServiceIdentifier] FOREIGN KEY([DefenseServiceIdentifier])
REFERENCES [agency].[DefenseServiceIdentifier] ([DefenseServiceIdentifier])
GO
ALTER TABLE [Project].[ProgramElementNumber] CHECK CONSTRAINT [fk_ProgramElementNumber_DefenseServiceIdentifier]
GO
