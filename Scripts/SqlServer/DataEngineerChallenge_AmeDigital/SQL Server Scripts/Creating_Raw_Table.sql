USE [AmeDigital_Project]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS [RawData].[Respondent]

CREATE TABLE [RawData].[Respondent](
	[Respondent] [varchar](max) NULL,
	[OpenSource] [varchar](max) NULL,
	[Hobby] [varchar](max) NULL,
	[Salary] [varchar](max) NULL,
	[SalaryType] [varchar](max) NULL,
	[ConvertedSalary] [varchar](max) NULL,
	[CurrencySymbol] [varchar](max) NULL,
	[OperatingSystem] [varchar](max) NULL,
	[Country] [varchar](max) NULL,
	[CompanySize] [varchar](max) NULL,
	[CommunicationTools] [varchar](max) NULL,
	[LanguageWorkedWith] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


