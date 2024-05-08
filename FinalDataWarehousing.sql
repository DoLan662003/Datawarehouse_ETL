ALTER AUTHORIZATION ON DATABASE :: FinalDataWarehouse TO SA
use master
go 
if exists (select * from sysdatabases where name = 'FinalDataWarehouse')
	drop database FinalDataWarehouse
go

Create database FinalDataWarehouse
go

use FinalDataWarehouse
go

---- Quy trình sản xuất
-- Tiền kì
CREATE TABLE Idea_Dim
(
  IdeaID INT NOT NULL,
  Title VARCHAR(100) NOT NULL,
  PRIMARY KEY (IdeaID)
);

CREATE TABLE Location_Dim
(
  LocationID INT NOT NULL,
  LocationName VARCHAR(100) NOT NULL,
  PRIMARY KEY (LocationID)
);

CREATE TABLE Time_Dim
(
  TimeID INT NOT NULL,
  Year DATE NOT NULL,
  Day DATE NOT NULL,
  Month DATE NOT NULL,
  PRIMARY KEY (TimeID)
);

CREATE TABLE Status_Dim
(
  StatusID INT NOT NULL,
  StatusName VARCHAR(100) NOT NULL,
  PRIMARY KEY (StatusID)
);

CREATE TABLE Budget_Category_Dim
(
  CategoryID INT NOT NULL,
  CategoryName VARCHAR(100) NOT NULL,
  PRIMARY KEY (CategoryID)
);

CREATE TABLE Budget_Proposal_fact
(
  BudgetAmount FLOAT NOT NULL,
  Date_Submitted DATE NOT NULL,
  IdeaID INT NOT NULL,
  TimeID INT NOT NULL,
  LocationID INT NOT NULL,
  CategoryID INT NOT NULL,
  StatusID INT NOT NULL,
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (CategoryID) REFERENCES Budget_Category_Dim(CategoryID),
  FOREIGN KEY (StatusID) REFERENCES Status_Dim(StatusID)
);


-- Ý tưởng
CREATE TABLE Creator_Dim
(
  CreatorID INT NOT NULL,
  CreatorName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  PRIMARY KEY (CreatorID)
);

CREATE TABLE Genre_Dim
(
  GenreID INT NOT NULL,
  GenreName VARCHAR(100) NOT NULL,
  PRIMARY KEY (GenreID)
);

CREATE TABLE Idea_fact
(
  Title VARCHAR(50) NOT NULL,
  Description VARCHAR(100) NOT NULL,
  Date_Created DATE NOT NULL,
  LocationID INT NOT NULL,
  StatusID INT NOT NULL,
  CreatorID INT NOT NULL,
  TimeID INT NOT NULL,
  GenreID INT NOT NULL,
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (StatusID) REFERENCES Status_Dim(StatusID),
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (GenreID) REFERENCES Genre_Dim(GenreID)
);

-- Sản xuất
CREATE TABLE Crew_Dim
(
  CrewID INT NOT NULL,
  CrewName VARCHAR(100) NOT NULL,
  Role VARCHAR(100) NOT NULL,
  PRIMARY KEY (CrewID)
);

CREATE TABLE Equiment_Dim
(
  EquimentID INT NOT NULL,
  EquimentName VARCHAR(100) NOT NULL,
  Type VARCHAR(100) NOT NULL,
  PRIMARY KEY (EquimentID)
);

CREATE TABLE Production_Order_Fact
(
  BudgetSpent FLOAT NOT NULL,
  StartTime DATE NOT NULL,
  EndTime DATE NOT NULL,
  LocationID INT NOT NULL,
  StatusID INT NOT NULL,
  CrewID INT NOT NULL,
  IdeaID INT NOT NULL,
  EquimentID INT NOT NULL,
  TimeID INT NOT NULL,
  PRIMARY KEY (LocationID, StatusID, CrewID, IdeaID, EquimentID, TimeID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (StatusID) REFERENCES Status_Dim(StatusID),
  FOREIGN KEY (CrewID) REFERENCES Crew_Dim(CrewID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (EquimentID) REFERENCES Equiment_Dim(EquimentID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID)
);

-- Hậu kì
CREATE TABLE Editing_Team_Dim
(
  TeamID INT NOT NULL,
  TeamName VARCHAR(100) NOT NULL,
  EditorName VARCHAR(100) NOT NULL,
  PRIMARY KEY (TeamID)
);

CREATE TABLE Sound_Design_Dim
(
  SoundID INT NOT NULL,
  SoundName VARCHAR(100) NOT NULL,
  EngineerName VARCHAR(100) NOT NULL,
  PRIMARY KEY (SoundID)
);

CREATE TABLE VFX_Dim
(
  VFXID INT NOT NULL,
  VFXName VARCHAR(100) NOT NULL,
  ArtistName VARCHAR(100) NOT NULL,
  PRIMARY KEY (VFXID)
);

CREATE TABLE Post_Production_Order_Fact
(
  StarTime DATE NOT NULL,
  EndTime DATE NOT NULL,
  BudgetSpent FLOAT NOT NULL,
  LocationID INT NOT NULL,
  IdeaID INT NOT NULL,
  TimeID INT NOT NULL,
  StatusID INT NOT NULL,
  TeamID INT NOT NULL,
  SoundID INT NOT NULL,
  VFXID INT NOT NULL,
  PRIMARY KEY (LocationID, IdeaID, TimeID, StatusID, TeamID, SoundID, VFXID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (StatusID) REFERENCES Status_Dim(StatusID),
  FOREIGN KEY (TeamID) REFERENCES Editing_Team_Dim(TeamID),
  FOREIGN KEY (SoundID) REFERENCES Sound_Design_Dim(SoundID),
  FOREIGN KEY (VFXID) REFERENCES VFX_Dim(VFXID)
);


-- Phát hành, Đánh giá
CREATE TABLE Marketing_Team_Dim
(
  TeamID INT NOT NULL,
  TeamName VARCHAR(100) NOT NULL,
  MarketingManager VARCHAR(100) NOT NULL,
  PRIMARY KEY (TeamID)
);

CREATE TABLE Distribution_Channel_Dim
(
  ChannelID INT NOT NULL,
  ChannelName VARCHAR(100) NOT NULL,
  PRIMARY KEY (ChannelID)
);

CREATE TABLE Audience_Dim
(
  AudienceID INT NOT NULL,
  AudienceName VARCHAR(100) NOT NULL,
  PRIMARY KEY (AudienceID)
);

CREATE TABLE Movie_Dim
(
  MovieID INT NOT NULL,
  Title VARCHAR(100) NOT NULL,
  ReleaseDate DATE NOT NULL,
  Director VARCHAR(100) NOT NULL,
  Genre INT NOT NULL,
  PRIMARY KEY (MovieID)
);

CREATE TABLE Reviewer_Dim
(
  ReviewerID INT NOT NULL,
  ReviewerName VARCHAR(100) NOT NULL,
  Occupation VARCHAR(100) NOT NULL,
  PRIMARY KEY (ReviewerID)
);

CREATE TABLE Rating_Dim
(
  RatingID INT NOT NULL,
  Rating VARCHAR NOT NULL,
  PRIMARY KEY (RatingID)
);


CREATE TABLE Distribution_Order_Fact
(
  ReleaseDate DATE NOT NULL,
  RevenueGenerated VARCHAR(100) NOT NULL,
  Số_lượng_mua_hàng INT NOT NULL,
  StatusID_ INT NOT NULL,
  TeamID INT NOT NULL,
  ChannelID INT NOT NULL,
  IdeaID INT NOT NULL,
  LocationID INT NOT NULL,
  TimeID INT NOT NULL,
  AudienceID INT NOT NULL,
  FOREIGN KEY (StatusID_) REFERENCES Status_Dim(StatusID),
  FOREIGN KEY (TeamID) REFERENCES Marketing_Team_Dim(TeamID),
  FOREIGN KEY (ChannelID) REFERENCES Distribution_Channel_Dim(ChannelID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (AudienceID) REFERENCES Audience_Dim(AudienceID)
);

CREATE TABLE Film_Review_Fact
(
  Rating INT NOT NULL,
  ReviewDate INT NOT NULL,
  MovieID INT NOT NULL,
  TimeID INT NOT NULL,
  RatingID INT NOT NULL,
  ReviewerID INT NOT NULL,
  FOREIGN KEY (MovieID) REFERENCES Movie_Dim(MovieID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (RatingID) REFERENCES Rating_Dim(RatingID),
  FOREIGN KEY (ReviewerID) REFERENCES Reviewer_Dim(ReviewerID)
);



---- Quy trình tài chính
--quản lí hóa đơn
CREATE TABLE Vendor_Dim
(
  VendorID INT NOT NULL,
  VendorName VARCHAR(100) NOT NULL,
  VendorType VARCHAR(100) NOT NULL,
  PRIMARY KEY (VendorID)
);

CREATE TABLE Account_Dim
(
  AccountID INT NOT NULL,
  AccountName VARCHAR(100) NOT NULL,
  AccountType VARCHAR(100) NOT NULL,
  PRIMARY KEY (AccountID)
);

CREATE TABLE Invoice_fact
(
  Amount INT NOT NULL,
  InvoiceDate DATE NOT NULL,
  VendorID INT NOT NULL,
  TimeID INT NOT NULL,
  AccountID INT NOT NULL,
  StatusID INT NOT NULL,
  FOREIGN KEY (VendorID) REFERENCES Vendor_Dim(VendorID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (AccountID) REFERENCES Account_Dim(AccountID),
  FOREIGN KEY (StatusID) REFERENCES Status_Dim(StatusID)
);
--quản lí ngân sách
CREATE TABLE Project_Dim
(
  ProjectID INT NOT NULL,
  ProjectName VARCHAR(100) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  Budget INT NOT NULL,
  PRIMARY KEY (ProjectID)
);

CREATE TABLE Financial_Transaction_fact
(
  Amount FLOAT NOT NULL,
  TransactionDate DATE NOT NULL,
  TimeID INT NOT NULL,
  ProjectID INT NOT NULL,
  AccountID INT NOT NULL,
  VendorID INT NOT NULL,
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (ProjectID) REFERENCES Project_Dim(ProjectID),
  FOREIGN KEY (AccountID) REFERENCES Account_Dim(AccountID),
  FOREIGN KEY (VendorID) REFERENCES Vendor_Dim(VendorID)
);
--quản lí nhà đầu tư
CREATE TABLE Investor_Dim
(
  InvestorID INT NOT NULL,
  InvestorName VARCHAR(100) NOT NULL,
  InvestorType VARCHAR(100) NOT NULL,
  PRIMARY KEY (InvestorID)
);

CREATE TABLE Transaction_Type_Dim
(
  TransactionTypeID INT NOT NULL,
  TransactionTypeName VARCHAR(100) NOT NULL,
  PRIMARY KEY (TransactionTypeID)
);

CREATE TABLE Financial_Transaction_Investor_fact
(
  Amount FLOAT NOT NULL,
  TransactionDate DATE NOT NULL,
  TransactionType VARCHAR(100) NOT NULL,
  AccountID INT NOT NULL,
  InvestorID INT NOT NULL,
  TimeID INT NOT NULL,
  TransactionTypeID INT NOT NULL,
  FOREIGN KEY (AccountID) REFERENCES Account_Dim(AccountID),
  FOREIGN KEY (InvestorID) REFERENCES Investor_Dim(InvestorID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (TransactionTypeID) REFERENCES Transaction_Type_Dim(TransactionTypeID)
);
--quản lí thu chi và ngân quỹ
CREATE TABLE Fund_Dim
(
  FundID INT NOT NULL,
  FundName VARCHAR(100) NOT NULL,
  FundType VARCHAR(100) NOT NULL,
  PRIMARY KEY (FundID)
);

CREATE TABLE Financial_Transaction__fact
(
  TransactionDate DATE NOT NULL,
  Amount FLOAT NOT NULL,
  TransactionType VARCHAR(100) NOT NULL,
  CreatorID INT NOT NULL,
  FundID INT NOT NULL,
  TimeID INT NOT NULL,
  AccountID INT NOT NULL,
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (FundID) REFERENCES Fund_Dim(FundID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (AccountID) REFERENCES Account_Dim(AccountID)
);
--Báo cáo tài chính
CREATE TABLE Financial_Report_Dim
(
  ReportID INT NOT NULL,
  ReportDate DATE NOT NULL,
  Revenue FLOAT NOT NULL,
  Expense FLOAT NOT NULL,
  Profit FLOAT NOT NULL,
  PRIMARY KEY (ReportID)
);

CREATE TABLE Financial_Tran_fact
(
  TransactionDate DATE NOT NULL,
  Amount FLOAT NOT NULL,
  CreatorID INT NOT NULL,
  ReportID INT NOT NULL,
  TimeID INT NOT NULL,
  AccountID INT NOT NULL,
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (ReportID) REFERENCES Financial_Report_Dim(ReportID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (AccountID) REFERENCES Account_Dim(AccountID)
);
----Quy trình Kinh doanh
--Phân tích và nghiên cứu thị trường
CREATE TABLE Market_Segment_Dim
(
  MarketSegmentID INT NOT NULL,
  SegmentName VARCHAR(100) NOT NULL,
  SegmentDescription VARCHAR(100) NOT NULL,
  PRIMARY KEY (MarketSegmentID)
);

CREATE TABLE Research_Method_Dim
(
  ResearchMethodID INT NOT NULL,
  MethodName VARCHAR(100) NOT NULL,
  MethodDescription VARCHAR(100) NOT NULL,
  PRIMARY KEY (ResearchMethodID)
);

CREATE TABLE Market_Analysis_fact
(
  ResearchDate DATE NOT NULL,
  Findings VARCHAR(100) NOT NULL,
  IdeaID INT NOT NULL,
  ResearchMethodID INT NOT NULL,
  TimeID INT NOT NULL,
  MarketSegmentID INT NOT NULL,
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (ResearchMethodID) REFERENCES Research_Method_Dim(ResearchMethodID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (MarketSegmentID) REFERENCES Market_Segment_Dim(MarketSegmentID)
);
-- Phát triển ý tưởng và kịch bản
CREATE TABLE Script_Dim
(
  ScriptID INT NOT NULL,
  ScriptTitle VARCHAR(100) NOT NULL,
  ScriptType VARCHAR(100) NOT NULL,
  PRIMARY KEY (ScriptID)
);

CREATE TABLE ScriptWriter_Dim
(
  ScriptWriterID INT NOT NULL,
  WriterName VARCHAR(100) NOT NULL,
  PRIMARY KEY (ScriptWriterID)
);
CREATE TABLE Idea_Development_Script_fact
(
  DevelopmentStartDate DATE NOT NULL,
  DevelopmentEndDate DATE NOT NULL,
  ScriptStatus VARCHAR(100) NOT NULL,
  ScriptID INT NOT NULL,
  TimeID INT NOT NULL,
  CreatorID INT NOT NULL,
  IdeaID INT NOT NULL,
  ScriptWriterID INT NOT NULL,
  GenreID INT NOT NULL,
  FOREIGN KEY (ScriptID) REFERENCES Script_Dim(ScriptID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (ScriptWriterID) REFERENCES ScriptWriter_Dim(ScriptWriterID),
  FOREIGN KEY (GenreID) REFERENCES Genre_Dim(GenreID)
);

--Lập kế hoạch sản xuất
CREATE TABLE Production_Plan_Fact
(
  PlanID INT NOT NULL,
  ProductionEndDate VARCHAR(50) NOT NULL,
  Budget INT NOT NULL,
  ActualCost VARCHAR(50) NOT NULL,
  IdeaID INT NOT NULL,
  LocationID INT NOT NULL,
  CrewID INT NOT NULL,
  TimeID INT NOT NULL,
  PRIMARY KEY (PlanID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (CrewID) REFERENCES Crew_Dim(CrewID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID)
);

--Chiến lược phát hành quảng bá
CREATE TABLE DistributionChannel_Dim
(
  DistributionChannelID INT NOT NULL,
  ChannelName VARCHAR(50) NOT NULL,
  New_Column INT NOT NULL,
  PRIMARY KEY (DistributionChannelID)
);

CREATE TABLE Promotion_Dim
(
  PromotionID INT NOT NULL,
  PromotionType VARCHAR(50) NOT NULL,
  PromotionBudget VARCHAR(50) NOT NULL,
  PromotionStartDate INT NOT NULL,
  PromotionEndDate INT NOT NULL,
  PRIMARY KEY (PromotionID)
);

CREATE TABLE Distribution_Promotion_Fact
(
  ReleaseID INT NOT NULL,
  ReleaseDate VARCHAR(50) NOT NULL,
  BoxOfficeRevenue VARCHAR(50) NOT NULL,
  DistributionChannelID INT NOT NULL,
  MovieID INT NOT NULL,
  TimeID INT NOT NULL,
  PromotionID INT NOT NULL,
  FOREIGN KEY (DistributionChannelID) REFERENCES DistributionChannel_Dim(DistributionChannelID),
  FOREIGN KEY (MovieID) REFERENCES Movie_Dim(MovieID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (PromotionID) REFERENCES Promotion_Dim(PromotionID)
);

--Báo cáo kinh doanh
CREATE TABLE Business_Report_Fact
(
  ReportID INT NOT NULL,
  TransactionDate VARCHAR(50) NOT NULL,
  Revenue VARCHAR(50) NOT NULL,
  Expense_ VARCHAR(50) NOT NULL,
  Profit_ VARCHAR(50) NOT NULL,
  TimeID INT NOT NULL,
  IdeaID INT NOT NULL,
  CreatorID INT NOT NULL,
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID)
);

----Quy trình nhân sự
--Tuyển dụng và tuyển chọn
CREATE TABLE Candidate_Dim
(
  CandidateID INT NOT NULL,
  CandidateName VARCHAR(50) NOT NULL,
  Email_ VARCHAR(50) NOT NULL,
  Phone VARCHAR(50) NOT NULL,
  EducationLevel_ VARCHAR(50) NOT NULL,
  Experience VARCHAR(50) NOT NULL,
  PRIMARY KEY (CandidateID)
);

CREATE TABLE Position_Dim
(
  PositionID INT NOT NULL,
  PositionTitle VARCHAR(50) NOT NULL,
  Department_ VARCHAR(50) NOT NULL,
  JobDescription VARCHAR(50) NOT NULL,
  PRIMARY KEY (PositionID)
);

CREATE TABLE Recruiter_Dim
(
  RecruiterID INT NOT NULL,
  RecruiterName VARCHAR(50) NOT NULL,
  RecruiterDepartment VARCHAR(50) NOT NULL,
  PRIMARY KEY (RecruiterID)
);
CREATE TABLE Recruitment_Fact
(
  RecruitmentID INT NOT NULL,
  ApplicationDate VARCHAR(50) NOT NULL,
  InterviewDate VARCHAR(50) NOT NULL,
  OfferDate VARCHAR(50) NOT NULL,
  HireDate VARCHAR(50) NOT NULL,
  CandidateID INT NOT NULL,
  TimeID INT NOT NULL,
  PositionID INT NOT NULL,
  RecruiterID INT NOT NULL,
  FOREIGN KEY (CandidateID) REFERENCES Candidate_Dim(CandidateID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (PositionID) REFERENCES Position_Dim(PositionID),
  FOREIGN KEY (RecruiterID) REFERENCES Recruiter_Dim(RecruiterID)
);

-- Đào tạo và phát triển nhân sự
CREATE TABLE Department_Dim
(
  DepartmentID INT NOT NULL,
  DepartmentName VARCHAR(50) NOT NULL,
  PRIMARY KEY (DepartmentID)
);

CREATE TABLE Course_Category_Dim
(
  CategoryID INT NOT NULL,
  CategoryName VARCHAR(50) NOT NULL,
  PRIMARY KEY (CategoryID)
);

CREATE TABLE Trainer_Dim
(
  TrainerID INT NOT NULL,
  TrainerName VARCHAR(50) NOT NULL,
  PRIMARY KEY (TrainerID)
);

CREATE TABLE Employee_Dim
(
  EmployeeID INT NOT NULL,
  EmployeeName INT NOT NULL,
  New_Column INT NOT NULL,
  PositionID INT NOT NULL,
  DepartmentID INT NOT NULL,
  PRIMARY KEY (EmployeeID),
  FOREIGN KEY (PositionID) REFERENCES Position_Dim(PositionID),
  FOREIGN KEY (DepartmentID) REFERENCES Department_Dim(DepartmentID)
);

CREATE TABLE Course_Dim
(
  CourseID INT NOT NULL,
  CourseName VARCHAR(50) NOT NULL,
  CategoryID INT NOT NULL,
  TrainerID INT NOT NULL,
  PRIMARY KEY (CourseID),
  FOREIGN KEY (CategoryID) REFERENCES Course_Category_Dim(CategoryID),
  FOREIGN KEY (TrainerID) REFERENCES Trainer_Dim(TrainerID)
);

CREATE TABLE Training_Development_Fact
(
  TrainingID INT NOT NULL,
  TrainingDate VARCHAR(50) NOT NULL,
  Duration VARCHAR(50) NOT NULL,
  EmployeeID INT NOT NULL,
  CourseID INT NOT NULL,
  TrainerID INT NOT NULL,
  FOREIGN KEY (EmployeeID) REFERENCES Employee_Dim(EmployeeID),
  FOREIGN KEY (CourseID) REFERENCES Course_Dim(CourseID),
  FOREIGN KEY (TrainerID) REFERENCES Trainer_Dim(TrainerID)
);

-- Quản lí hiệu suất
CREATE TABLE Manager_Dim
(
  ManagerID INT NOT NULL,
  ManagerName VARCHAR(50) NOT NULL,
  PRIMARY KEY (ManagerID)
);

CREATE TABLE Performance_Evaluation_Fact
(
  EvaluationID INT NOT NULL,
  EvaluationDate VARCHAR(50) NOT NULL,
  Rating VARCHAR(50) NOT NULL,
  EmployeeID INT NOT NULL,
  ManagerID INT NOT NULL,
  TimeID INT NOT NULL,
  PRIMARY KEY (EvaluationID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee_Dim(EmployeeID),
  FOREIGN KEY (ManagerID) REFERENCES Manager_Dim(ManagerID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID)
);

--Chăm sóc nhân sự và phúc lợi
CREATE TABLE Benefit_Dim
(
  BenefitID INT NOT NULL,
  BenefitType VARCHAR(50) NOT NULL,
  BenefitCategory VARCHAR(50) NOT NULL,
  PRIMARY KEY (BenefitID)
);

CREATE TABLE HR_Benefit_Detail_Fact
(
  TransactionDate VARCHAR(50) NOT NULL,
  Amount VARCHAR(50) NOT NULL,
  EmployeeID INT NOT NULL,
  BenefitID INT NOT NULL,
  FOREIGN KEY (EmployeeID) REFERENCES Employee_Dim(EmployeeID),
  FOREIGN KEY (BenefitID) REFERENCES Benefit_Dim(BenefitID)
);

-- Báo cáo nhân sự

CREATE TABLE HR_Data_Fact
(
  Salary FLOAT NOT NULL,
  Attendance INT NOT NULL,
  PerformanceRating INT NOT NULL,
  TimeID INT NOT NULL,
  PositionID INT NOT NULL,
  EmployeeID INT NOT NULL,
  DepartmentID INT NOT NULL,
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (PositionID) REFERENCES Position_Dim(PositionID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee_Dim(EmployeeID),
  FOREIGN KEY (DepartmentID) REFERENCES Department_Dim(DepartmentID)
);

----Quy trình Marketing
--Nghiên cứu và phân tích thị trường
CREATE TABLE Demographic_Dim
(
  DemographicID INT NOT NULL,
  DemographicType VARCHAR(100) NOT NULL,
  DemographicValue INT NOT NULL,
  PRIMARY KEY (DemographicID)
);

CREATE TABLE Market_Research_Fact
(
  ResearchDate INT NOT NULL,
  TargetAudience VARCHAR(100) NOT NULL,
  MarketTrend VARCHAR(100) NOT NULL,
  CompetitionAnalysis VARCHAR(100) NOT NULL,
  TimeID INT NOT NULL,
  IdeaID INT NOT NULL,
  CreatorID INT NOT NULL,
  DemographicID INT NOT NULL,
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (DemographicID) REFERENCES Demographic_Dim(DemographicID)
);

--Quảng cáo và quảng bá
CREATE TABLE Media_Dim
(
  MediaID INT NOT NULL,
  MediaName VARCHAR(100) NOT NULL,
  PRIMARY KEY (MediaID)
);

CREATE TABLE Advertising_Campaign_Fact
(
  Cost FLOAT NOT NULL,
  RevenueGenerated FLOAT NOT NULL,
  IdeaID INT NOT NULL,
  CreatorID INT NOT NULL,
  TimeID INT NOT NULL,
  LocationID INT NOT NULL,
  MediaID INT NOT NULL,
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (MediaID) REFERENCES Media_Dim(MediaID)
);

-- Xác định chiến lược tiếp thị
CREATE TABLE Channel_Dim
(
  ChannelID INT NOT NULL,
  ChannelName VARCHAR(100) NOT NULL,
  PRIMARY KEY (ChannelID)
);

CREATE TABLE Marketing_Strategy_Fact
(
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  Budget FLOAT NOT NULL,
  StrategyName VARCHAR(100) NOT NULL,
  IdeaID INT NOT NULL,
  CreatorID INT NOT NULL,
  TimeID INT NOT NULL,
  ChannelID INT NOT NULL,
  AudienceID INT NOT NULL,
  FOREIGN KEY (IdeaID) REFERENCES Idea_Dim(IdeaID),
  FOREIGN KEY (CreatorID) REFERENCES Creator_Dim(CreatorID),
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (ChannelID) REFERENCES Channel_Dim(ChannelID),
  FOREIGN KEY (AudienceID) REFERENCES Audience_Dim(AudienceID)
);

--Quản lí truyền thông và xã hội
CREATE TABLE Campaign_Dim
(
  CampaignID INT NOT NULL,
  CampaignName VARCHAR(100) NOT NULL,
  CampaignType VARCHAR(100) NOT NULL,
  PRIMARY KEY (CampaignID)
);

CREATE TABLE Platform_Dim
(
  PlatformID INT NOT NULL,
  PlatformName VARCHAR(100) NOT NULL,
  PlatformType VARCHAR(100) NOT NULL,
  PRIMARY KEY (PlatformID)
);

CREATE TABLE Social_Media_Performance_Fact
(
  DatePosted DATE NOT NULL,
  Likes INT NOT NULL,
  Shares INT NOT NULL,
  Comments INT NOT NULL,
  Impressions INT NOT NULL,
  TimeID INT NOT NULL,
  PlatformID INT NOT NULL,
  CampaignID INT NOT NULL,
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (PlatformID) REFERENCES Platform_Dim(PlatformID),
  FOREIGN KEY (CampaignID) REFERENCES Campaign_Dim(CampaignID)
);

--Đánh giá và đo lường hiệu suất
CREATE TABLE Performance_Measurement_Fact
(
  Date DATE NOT NULL,
  Impressions INT NOT NULL,
  Clicks_ INT NOT NULL,
  Conversions_ INT NOT NULL,
  Revenue INT NOT NULL,
  TimeID INT NOT NULL,
  LocationID INT NOT NULL,
  AudienceID INT NOT NULL,
  CampaignID INT NOT NULL,
  ChannelID INT NOT NULL,
  FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID),
  FOREIGN KEY (LocationID) REFERENCES Location_Dim(LocationID),
  FOREIGN KEY (AudienceID) REFERENCES Audience_Dim(AudienceID),
  FOREIGN KEY (CampaignID) REFERENCES Campaign_Dim(CampaignID),
  FOREIGN KEY (ChannelID) REFERENCES Channel_Dim(ChannelID)
);


