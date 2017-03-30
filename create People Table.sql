
/****** 
This script creates a table called people in a database called certificates. 
You must first create a blank database called certificates if this doesn't exist.
******/


USE [certificates]
GO

/****** Object:  Table [dbo].[people]    Script Date: 03/30/2017 10:22:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[people](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[set_name] [nvarchar](255) NOT NULL,
	[name] [nvarchar](600) NOT NULL,
	[email] [nvarchar](600) NOT NULL,
	[folder] [nvarchar](200) NOT NULL,
	[date_added] [datetime] NOT NULL,
	[status] [int] NOT NULL,
	[date_sent] [datetime] NULL,
	[date_generated] [datetime] NULL
) ON [PRIMARY]

GO