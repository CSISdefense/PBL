USE [DIIG]
GO
/****** Object:  Table [Project].[ProcIDtoProjectIDmanyToMany]    Script Date: 3/13/2017 2:37:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Project].[ProcIDtoProjectIDmanyToMany](
	[ProcID] [int] NOT NULL,
	[ProjectID] [int] NOT NULL,
	[CSISmodifiedDate] [datetime2](7) NOT NULL,
	[CSISmodifiedby] [nvarchar](128) NOT NULL,
 CONSTRAINT [pk_ProcID_ProjectID] PRIMARY KEY CLUSTERED 
(
	[ProcID] ASC,
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [Project].[ProcIDtoProjectIDmanyToMany] ADD  CONSTRAINT [df_LineItem_CSISmodifiedDate]  DEFAULT (getdate()) FOR [CSISmodifiedDate]
GO
ALTER TABLE [Project].[ProcIDtoProjectIDmanyToMany] ADD  CONSTRAINT [df_LineItem_CSISmodifiedBy]  DEFAULT (suser_sname()) FOR [CSISmodifiedby]
GO
ALTER TABLE [Project].[ProcIDtoProjectIDmanyToMany]  WITH CHECK ADD  CONSTRAINT [FK__LineItemT__ProcI__76D75FA7] FOREIGN KEY([ProcID])
REFERENCES [Project].[ProcID] ([ProcID])
GO
ALTER TABLE [Project].[ProcIDtoProjectIDmanyToMany] CHECK CONSTRAINT [FK__LineItemT__ProcI__76D75FA7]
GO
ALTER TABLE [Project].[ProcIDtoProjectIDmanyToMany]  WITH CHECK ADD  CONSTRAINT [fk_LineItemToProjectIDmanyToMany_ProjectID] FOREIGN KEY([ProjectID])
REFERENCES [Project].[ProjectID] ([ProjectID])
GO
ALTER TABLE [Project].[ProcIDtoProjectIDmanyToMany] CHECK CONSTRAINT [fk_LineItemToProjectIDmanyToMany_ProjectID]
GO
