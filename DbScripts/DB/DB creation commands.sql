USE [master]
GO
/****** Object:  Database [Cosmatics Online Store]    Script Date: 3/13/2025 5:13:57 AM ******/
CREATE DATABASE [Cosmatics Online Store]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Cosmatics Online Store', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\DATA\Cosmatics Online Store.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Cosmatics Online Store_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLSERVER\MSSQL\DATA\Cosmatics Online Store_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Cosmatics Online Store] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Cosmatics Online Store].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Cosmatics Online Store] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET ARITHABORT OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Cosmatics Online Store] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Cosmatics Online Store] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Cosmatics Online Store] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Cosmatics Online Store] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET RECOVERY FULL 
GO
ALTER DATABASE [Cosmatics Online Store] SET  MULTI_USER 
GO
ALTER DATABASE [Cosmatics Online Store] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Cosmatics Online Store] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Cosmatics Online Store] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Cosmatics Online Store] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Cosmatics Online Store] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Cosmatics Online Store] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Cosmatics Online Store', N'ON'
GO
ALTER DATABASE [Cosmatics Online Store] SET QUERY_STORE = ON
GO
ALTER DATABASE [Cosmatics Online Store] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Cosmatics Online Store]
GO
/****** Object:  Table [dbo].[ORDERS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORDERS](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_order_customer_id] [int] NOT NULL,
	[subtotal] [float] NOT NULL,
	[tax] [float] NOT NULL,
	[shipping_cost] [float] NOT NULL,
	[status] [varchar](50) NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[SalesSummaryView]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SalesSummaryView] AS
SELECT 
    YEAR(O.created_at) AS SalesYear,
    MONTH(O.created_at) AS SalesMonth,
    COUNT(O.order_id) AS TotalOrders,
    SUM(O.subtotal + O.tax + O.shipping_cost) AS TotalRevenue
FROM ORDERS O
WHERE O.is_active = 1
GROUP BY YEAR(O.created_at), MONTH(O.created_at)
GO
/****** Object:  Table [dbo].[CATEGORIES_LOOKUP]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CATEGORIES_LOOKUP](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [varchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BRANDS_LOOKUP]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BRANDS_LOOKUP](
	[brand_id] [int] IDENTITY(1,1) NOT NULL,
	[brand_name] [varchar](200) NOT NULL,
	[origin_country] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[brand_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRODUCTS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCTS](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[serial_number] [varchar](225) NOT NULL,
	[name] [varchar](200) NOT NULL,
	[description] [varchar](500) NOT NULL,
	[base_price] [float] NOT NULL,
	[selling_price] [float] NOT NULL,
	[FK_brand_id] [int] NOT NULL,
	[FK_category_id] [int] NOT NULL,
	[weight] [float] NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
	[expiry_date] [date] NOT NULL,
	[discount_amount] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[serial_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[AvailableForSaleProducts]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--category, brand, price, and discount amount.
CREATE VIEW [dbo].[AvailableForSaleProducts] AS
SELECT 
P.product_id, P.name, CL.category_name, BL.brand_name, P.base_price, P.selling_price, P.discount_amount
FROM 
PRODUCTS P INNER JOIN CATEGORIES_LOOKUP CL ON P.FK_category_id=CL.category_id
LEFT JOIN BRANDS_LOOKUP BL ON P.FK_brand_id=BL.brand_id
WHERE
P.is_active=1
GO
/****** Object:  View [dbo].[ActiveItemsView]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ActiveItemsView] AS
SELECT 
P.product_id, P.name, CL.category_name, BL.brand_name, P.base_price, P.selling_price, P.discount_amount
FROM 
PRODUCTS P INNER JOIN CATEGORIES_LOOKUP CL ON P.FK_category_id=CL.category_id
LEFT JOIN BRANDS_LOOKUP BL ON P.FK_brand_id=BL.brand_id
WHERE
P.is_active=1
GO
/****** Object:  Table [dbo].[WISHLISTS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WISHLISTS](
	[wishlist_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_customer_id] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[wishlist_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WISHLIST_ITEMS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WISHLIST_ITEMS](
	[FK_wishlist_id] [int] NOT NULL,
	[FK_product_id] [int] NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
 CONSTRAINT [COMPOSIT_KEY_WISHLIST_ITEMS] PRIMARY KEY CLUSTERED 
(
	[FK_wishlist_id] ASC,
	[FK_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERSONS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERSONS](
	[person_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[email] [varchar](255) NULL,
	[phone_number] [varchar](10) NOT NULL,
	[password_hash] [varchar](255) NULL,
	[profile_img] [varchar](max) NULL,
	[person_type] [varchar](10) NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[creation_by] [varchar](max) NULL,
	[update_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_email] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_phone_number] UNIQUE NONCLUSTERED 
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CUSTOMERS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUSTOMERS](
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_customer_person_id] [int] NOT NULL,
	[rewards_points] [int] NOT NULL,
	[last_login] [datetime] NOT NULL,
	[status] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_customer_person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CustomerWishlistView]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CustomerWishlistView] AS
SELECT 
    C.customer_id AS CustomerID,
    P.first_name + ' ' + P.last_name AS CustomerName,
    PR.product_id AS ProductID,
    PR.name AS ProductName,
    CL.category_name AS Category,
    BL.brand_name AS Brand,
    PR.selling_price AS Price,
    PR.discount_amount AS Discount,
    WLI.is_active AS IsActiveWishlistItem,
    WLI.created_at AS WishlistAddedDate
FROM WISHLISTS W
JOIN CUSTOMERS C ON W.FK_customer_id = C.customer_id
JOIN PERSONS P ON C.FK_customer_person_id = P.person_id
JOIN WISHLIST_ITEMS WLI ON W.wishlist_id = WLI.FK_wishlist_id
JOIN PRODUCTS PR ON WLI.FK_product_id = PR.product_id
LEFT JOIN CATEGORIES_LOOKUP CL ON PR.FK_category_id = CL.category_id
LEFT JOIN BRANDS_LOOKUP BL ON PR.FK_brand_id = BL.brand_id;
GO
/****** Object:  Table [dbo].[ADDRESSES]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ADDRESSES](
	[address_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_address_customer_id] [int] NOT NULL,
	[address_line1] [varchar](max) NOT NULL,
	[address_line2] [varchar](max) NULL,
	[city] [varchar](100) NOT NULL,
	[postal_code] [varchar](max) NOT NULL,
	[country] [varchar](max) NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_address_customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ADMINS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ADMINS](
	[admin_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_admin_person_id] [int] NOT NULL,
	[last_login] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[admin_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_admin_person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CART_ITEMS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CART_ITEMS](
	[FK_cart_id] [int] NOT NULL,
	[FK_product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
 CONSTRAINT [COMPOSIT_KEY_CART_ITEMS] PRIMARY KEY CLUSTERED 
(
	[FK_cart_id] ASC,
	[FK_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INGREDIENTS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INGREDIENTS](
	[ingredient_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](200) NOT NULL,
	[description] [varchar](500) NOT NULL,
	[safety_info] [varchar](max) NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ingredient_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INVENTORY]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INVENTORY](
	[inventory_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_product_id] [int] NOT NULL,
	[quantity_available] [int] NOT NULL,
	[warehouse_location] [varchar](max) NOT NULL,
	[batch_number] [varchar](max) NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[inventory_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ORDER_ITEMS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ORDER_ITEMS](
	[FK_order_id] [int] NOT NULL,
	[FK_product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[unit_price] [float] NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
 CONSTRAINT [COMPOSIT_KEY_ORDER_ITEMS] PRIMARY KEY CLUSTERED 
(
	[FK_order_id] ASC,
	[FK_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PAYMENT_TRANSACTIONS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAYMENT_TRANSACTIONS](
	[transaction_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_transaction_order_id] [int] NOT NULL,
	[payment_method] [varchar](30) NOT NULL,
	[amount] [float] NOT NULL,
	[payment_status] [varchar](50) NOT NULL,
	[transaction_reference] [varchar](225) NOT NULL,
	[transaction_date] [datetime] NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[transaction_reference] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRODUCT_IMAGES]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCT_IMAGES](
	[image_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_product_id] [int] NOT NULL,
	[url_link] [varchar](max) NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[image_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRODUCT_INGREDIENTS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCT_INGREDIENTS](
	[FK_product_id] [int] NOT NULL,
	[FK_ingredient_id] [int] NOT NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
 CONSTRAINT [COMPOSITE_KEY_PRODUCT_INGREDIENTS] PRIMARY KEY CLUSTERED 
(
	[FK_ingredient_id] ASC,
	[FK_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRODUCT_REQUESTS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCT_REQUESTS](
	[request_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_customer_id] [int] NOT NULL,
	[product_name] [varchar](255) NOT NULL,
	[quantity_requested] [int] NOT NULL,
	[status] [varchar](10) NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[creation_by] [varchar](max) NULL,
	[update_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[request_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RATES]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RATES](
	[rate_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_order_id] [int] NOT NULL,
	[rate_amount] [float] NOT NULL,
	[rate_message] [varchar](500) NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
	[created_by] [varchar](max) NULL,
	[updated_by] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[rate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SHIPPING_DETAILS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SHIPPING_DETAILS](
	[shipping_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_shipping_order_id] [int] NOT NULL,
	[tracking_number] [varchar](20) NOT NULL,
	[estimated_delivery] [datetime] NOT NULL,
	[shipped_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[shipping_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[tracking_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SHOPPING_CARTS]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SHOPPING_CARTS](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[FK_customer_id] [int] NOT NULL,
	[created_at] [datetime] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[FK_customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ADDRESSES] ADD  CONSTRAINT [DEFAULT_ADDRESS_LINE2]  DEFAULT (NULL) FOR [address_line2]
GO
ALTER TABLE [dbo].[ADMINS] ADD  CONSTRAINT [DEFAULT_LAST_LOGIN]  DEFAULT (getdate()) FOR [last_login]
GO
ALTER TABLE [dbo].[CART_ITEMS] ADD  DEFAULT ((0)) FOR [quantity]
GO
ALTER TABLE [dbo].[CART_ITEMS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[CART_ITEMS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[CART_ITEMS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[CUSTOMERS] ADD  CONSTRAINT [DEFAULT_REWARDS_POINTS]  DEFAULT ((0)) FOR [rewards_points]
GO
ALTER TABLE [dbo].[INGREDIENTS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[INGREDIENTS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[INGREDIENTS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[INVENTORY] ADD  DEFAULT ((0)) FOR [quantity_available]
GO
ALTER TABLE [dbo].[INVENTORY] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[INVENTORY] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[INVENTORY] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[ORDER_ITEMS] ADD  DEFAULT ((0)) FOR [quantity]
GO
ALTER TABLE [dbo].[ORDER_ITEMS] ADD  DEFAULT ((0.0)) FOR [unit_price]
GO
ALTER TABLE [dbo].[ORDER_ITEMS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[ORDER_ITEMS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[ORDER_ITEMS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[ORDERS] ADD  CONSTRAINT [DEFAULT_SUBTOTAL]  DEFAULT ((0.0)) FOR [subtotal]
GO
ALTER TABLE [dbo].[ORDERS] ADD  CONSTRAINT [DEFAULT_TAX]  DEFAULT ((0.00)) FOR [tax]
GO
ALTER TABLE [dbo].[ORDERS] ADD  CONSTRAINT [DEFAULT_SHIPPING_COST]  DEFAULT ((0.0)) FOR [shipping_cost]
GO
ALTER TABLE [dbo].[ORDERS] ADD  CONSTRAINT [DEFAULT_IS_ACTIVE]  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[ORDERS] ADD  CONSTRAINT [DEFAULT_CREATED_AT]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[ORDERS] ADD  CONSTRAINT [DEFAULTUPDATED_AT]  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS] ADD  DEFAULT ((0.0)) FOR [amount]
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[PERSONS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[PRODUCT_IMAGES] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[PRODUCT_IMAGES] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[PRODUCT_IMAGES] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS] ADD  DEFAULT ('Pending') FOR [status]
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[PRODUCTS] ADD  DEFAULT ((0.0)) FOR [base_price]
GO
ALTER TABLE [dbo].[PRODUCTS] ADD  DEFAULT ((0.0)) FOR [selling_price]
GO
ALTER TABLE [dbo].[PRODUCTS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[PRODUCTS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[PRODUCTS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[RATES] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[RATES] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[RATES] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[SHIPPING_DETAILS] ADD  DEFAULT (getdate()) FOR [estimated_delivery]
GO
ALTER TABLE [dbo].[SHIPPING_DETAILS] ADD  DEFAULT (getdate()) FOR [shipped_date]
GO
ALTER TABLE [dbo].[SHOPPING_CARTS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[SHOPPING_CARTS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[WISHLISTS] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[WISHLISTS] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[ADDRESSES]  WITH CHECK ADD  CONSTRAINT [FK_ADDRESSES_CUSTOMER_ID] FOREIGN KEY([FK_address_customer_id])
REFERENCES [dbo].[PERSONS] ([person_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ADDRESSES] CHECK CONSTRAINT [FK_ADDRESSES_CUSTOMER_ID]
GO
ALTER TABLE [dbo].[ADMINS]  WITH CHECK ADD  CONSTRAINT [FK_admin_person_id] FOREIGN KEY([FK_admin_person_id])
REFERENCES [dbo].[PERSONS] ([person_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ADMINS] CHECK CONSTRAINT [FK_admin_person_id]
GO
ALTER TABLE [dbo].[CART_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_CART_ID_CART_ITEMS] FOREIGN KEY([FK_cart_id])
REFERENCES [dbo].[SHOPPING_CARTS] ([cart_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CART_ITEMS] CHECK CONSTRAINT [FK_CART_ID_CART_ITEMS]
GO
ALTER TABLE [dbo].[CART_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_ID_CART_ITEMS] FOREIGN KEY([FK_product_id])
REFERENCES [dbo].[PRODUCTS] ([product_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CART_ITEMS] CHECK CONSTRAINT [FK_PRODUCT_ID_CART_ITEMS]
GO
ALTER TABLE [dbo].[CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [FK_customer_person_id] FOREIGN KEY([FK_customer_person_id])
REFERENCES [dbo].[PERSONS] ([person_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CUSTOMERS] CHECK CONSTRAINT [FK_customer_person_id]
GO
ALTER TABLE [dbo].[INVENTORY]  WITH CHECK ADD  CONSTRAINT [FK_INVENTORY_PRODUCT_ID] FOREIGN KEY([FK_product_id])
REFERENCES [dbo].[PRODUCTS] ([product_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INVENTORY] CHECK CONSTRAINT [FK_INVENTORY_PRODUCT_ID]
GO
ALTER TABLE [dbo].[ORDER_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_ID_ORDER_ITEMS] FOREIGN KEY([FK_order_id])
REFERENCES [dbo].[ORDERS] ([order_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ORDER_ITEMS] CHECK CONSTRAINT [FK_ORDER_ID_ORDER_ITEMS]
GO
ALTER TABLE [dbo].[ORDER_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_ID_ORDER_ITEMS] FOREIGN KEY([FK_product_id])
REFERENCES [dbo].[PRODUCTS] ([product_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ORDER_ITEMS] CHECK CONSTRAINT [FK_PRODUCT_ID_ORDER_ITEMS]
GO
ALTER TABLE [dbo].[ORDERS]  WITH CHECK ADD  CONSTRAINT [FK_ORDER_CUSTOMER_ID] FOREIGN KEY([FK_order_customer_id])
REFERENCES [dbo].[CUSTOMERS] ([customer_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ORDERS] CHECK CONSTRAINT [FK_ORDER_CUSTOMER_ID]
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS]  WITH CHECK ADD  CONSTRAINT [FK_TRANSACTION_ORDER_ID] FOREIGN KEY([FK_transaction_order_id])
REFERENCES [dbo].[ORDERS] ([order_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS] CHECK CONSTRAINT [FK_TRANSACTION_ORDER_ID]
GO
ALTER TABLE [dbo].[PRODUCT_IMAGES]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_IMAGE_PRODUCT_ID] FOREIGN KEY([FK_product_id])
REFERENCES [dbo].[PRODUCTS] ([product_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRODUCT_IMAGES] CHECK CONSTRAINT [FK_PRODUCT_IMAGE_PRODUCT_ID]
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS]  WITH CHECK ADD  CONSTRAINT [FK_INGREDIENT_ID] FOREIGN KEY([FK_ingredient_id])
REFERENCES [dbo].[INGREDIENTS] ([ingredient_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS] CHECK CONSTRAINT [FK_INGREDIENT_ID]
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_ID] FOREIGN KEY([FK_product_id])
REFERENCES [dbo].[PRODUCTS] ([product_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRODUCT_INGREDIENTS] CHECK CONSTRAINT [FK_PRODUCT_ID]
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS]  WITH CHECK ADD  CONSTRAINT [FK_ProductRequest_customer_id] FOREIGN KEY([FK_customer_id])
REFERENCES [dbo].[CUSTOMERS] ([customer_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS] CHECK CONSTRAINT [FK_ProductRequest_customer_id]
GO
ALTER TABLE [dbo].[PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_BRAND_ID] FOREIGN KEY([FK_brand_id])
REFERENCES [dbo].[BRANDS_LOOKUP] ([brand_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRODUCTS] CHECK CONSTRAINT [FK_PRODUCT_BRAND_ID]
GO
ALTER TABLE [dbo].[PRODUCTS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_CATEGORY_ID] FOREIGN KEY([FK_category_id])
REFERENCES [dbo].[CATEGORIES_LOOKUP] ([category_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRODUCTS] CHECK CONSTRAINT [FK_PRODUCT_CATEGORY_ID]
GO
ALTER TABLE [dbo].[RATES]  WITH CHECK ADD  CONSTRAINT [FK_RATE_ORDER_ID] FOREIGN KEY([FK_order_id])
REFERENCES [dbo].[ORDERS] ([order_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RATES] CHECK CONSTRAINT [FK_RATE_ORDER_ID]
GO
ALTER TABLE [dbo].[SHIPPING_DETAILS]  WITH CHECK ADD  CONSTRAINT [FK_SHIPPING_ORDER_ID] FOREIGN KEY([FK_shipping_order_id])
REFERENCES [dbo].[ORDERS] ([order_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SHIPPING_DETAILS] CHECK CONSTRAINT [FK_SHIPPING_ORDER_ID]
GO
ALTER TABLE [dbo].[SHOPPING_CARTS]  WITH CHECK ADD  CONSTRAINT [FK_CUSTOMER_ID] FOREIGN KEY([FK_customer_id])
REFERENCES [dbo].[CUSTOMERS] ([customer_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SHOPPING_CARTS] CHECK CONSTRAINT [FK_CUSTOMER_ID]
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_PRODUCT_ID_WISHLIST_ITEMS] FOREIGN KEY([FK_product_id])
REFERENCES [dbo].[PRODUCTS] ([product_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS] CHECK CONSTRAINT [FK_PRODUCT_ID_WISHLIST_ITEMS]
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS]  WITH CHECK ADD  CONSTRAINT [FK_WISHLIST_ID_WISHIST_ITEMS] FOREIGN KEY([FK_wishlist_id])
REFERENCES [dbo].[WISHLISTS] ([wishlist_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WISHLIST_ITEMS] CHECK CONSTRAINT [FK_WISHLIST_ID_WISHIST_ITEMS]
GO
ALTER TABLE [dbo].[WISHLISTS]  WITH CHECK ADD  CONSTRAINT [FK_WISHLIST_CUSTOMER_ID] FOREIGN KEY([FK_customer_id])
REFERENCES [dbo].[CUSTOMERS] ([customer_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WISHLISTS] CHECK CONSTRAINT [FK_WISHLIST_CUSTOMER_ID]
GO
ALTER TABLE [dbo].[CART_ITEMS]  WITH CHECK ADD  CONSTRAINT [CHK_QUANTITY] CHECK  (([quantity]>=(0)))
GO
ALTER TABLE [dbo].[CART_ITEMS] CHECK CONSTRAINT [CHK_QUANTITY]
GO
ALTER TABLE [dbo].[INGREDIENTS]  WITH CHECK ADD  CONSTRAINT [CHK_DESCRIPTION_MIN_LENGTH] CHECK  ((len([description])>=(10)))
GO
ALTER TABLE [dbo].[INGREDIENTS] CHECK CONSTRAINT [CHK_DESCRIPTION_MIN_LENGTH]
GO
ALTER TABLE [dbo].[INVENTORY]  WITH CHECK ADD  CONSTRAINT [CHK_QUANITITY_AVAILABLE] CHECK  (([quantity_available]>=(0)))
GO
ALTER TABLE [dbo].[INVENTORY] CHECK CONSTRAINT [CHK_QUANITITY_AVAILABLE]
GO
ALTER TABLE [dbo].[ORDER_ITEMS]  WITH CHECK ADD  CONSTRAINT [CHK_QUANITITY] CHECK  (([quantity]>=(0)))
GO
ALTER TABLE [dbo].[ORDER_ITEMS] CHECK CONSTRAINT [CHK_QUANITITY]
GO
ALTER TABLE [dbo].[ORDER_ITEMS]  WITH CHECK ADD  CONSTRAINT [CHK_UNIT_PRICE] CHECK  (([unit_price]>=(0)))
GO
ALTER TABLE [dbo].[ORDER_ITEMS] CHECK CONSTRAINT [CHK_UNIT_PRICE]
GO
ALTER TABLE [dbo].[ORDERS]  WITH CHECK ADD  CONSTRAINT [CHK_STATUS] CHECK  (([status]='Cancelled' OR [status]='Delivered' OR [status]='Shipped' OR [status]='Processing' OR [status]='Pending'))
GO
ALTER TABLE [dbo].[ORDERS] CHECK CONSTRAINT [CHK_STATUS]
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS]  WITH CHECK ADD  CONSTRAINT [CHK_PAYMENT_STATUS] CHECK  (([payment_status]='Refunded' OR [payment_status]='Unpaid' OR [payment_status]='Paid'))
GO
ALTER TABLE [dbo].[PAYMENT_TRANSACTIONS] CHECK CONSTRAINT [CHK_PAYMENT_STATUS]
GO
ALTER TABLE [dbo].[PERSONS]  WITH CHECK ADD  CONSTRAINT [CHK_PHONE_NUMBER] CHECK  (([phone_number] like '07%' AND len([phone_number])=(10)))
GO
ALTER TABLE [dbo].[PERSONS] CHECK CONSTRAINT [CHK_PHONE_NUMBER]
GO
ALTER TABLE [dbo].[PERSONS]  WITH CHECK ADD  CONSTRAINT [CHK_SALARY] CHECK  (([Email] like '%_@_%._%'))
GO
ALTER TABLE [dbo].[PERSONS] CHECK CONSTRAINT [CHK_SALARY]
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS]  WITH CHECK ADD  CONSTRAINT [CHK_PRODUCT_REQUESTS_STATUS] CHECK  (([status]='Rejected' OR [status]='Approved' OR [status]='Pending'))
GO
ALTER TABLE [dbo].[PRODUCT_REQUESTS] CHECK CONSTRAINT [CHK_PRODUCT_REQUESTS_STATUS]
GO
ALTER TABLE [dbo].[PRODUCTS]  WITH CHECK ADD  CONSTRAINT [CHK_PRICES] CHECK  (([base_price]>(0) AND [selling_price]>(0)))
GO
ALTER TABLE [dbo].[PRODUCTS] CHECK CONSTRAINT [CHK_PRICES]
GO
ALTER TABLE [dbo].[RATES]  WITH CHECK ADD  CONSTRAINT [CHK_RATE_AMOUNT] CHECK  (([rate_amount]<=(5) AND [rate_amount]>=(0)))
GO
ALTER TABLE [dbo].[RATES] CHECK CONSTRAINT [CHK_RATE_AMOUNT]
GO
/****** Object:  StoredProcedure [dbo].[sp_AddItemToOrder]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Add Item to Order: 
--Write a stored procedure to add a selected item to a customer's order, 
--ensuring stock availability is checked before adding.
CREATE PROCEDURE [dbo].[sp_AddItemToOrder]
    @OrderID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    DECLARE @AvailableStock INT, @UnitPrice FLOAT
    BEGIN TRANSACTION
    IF NOT EXISTS (SELECT 1 FROM PRODUCTS WHERE product_id = @ProductID AND is_active = 1)
    BEGIN
        RAISERROR ('Product does not exist or is inactive.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    SELECT @AvailableStock = quantity_available, @UnitPrice = selling_price 
    FROM INVENTORY I 
    JOIN PRODUCTS P ON I.FK_product_id = P.product_id
    WHERE P.product_id = @ProductID AND I.is_active = 1

    IF @AvailableStock IS NULL OR @AvailableStock < @Quantity
    BEGIN
        RAISERROR ('Not enough stock available for the requested product.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    IF NOT EXISTS (SELECT 1 FROM ORDERS WHERE order_id = @OrderID AND is_active = 1)
    BEGIN
        RAISERROR ('Order does not exist or is inactive.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    INSERT INTO ORDER_ITEMS (FK_order_id, FK_product_id, quantity, unit_price, is_active, created_at, updated_at)
    VALUES (@OrderID, @ProductID, @Quantity, @UnitPrice, 1, GETDATE(), GETDATE())
    UPDATE INVENTORY 
    SET quantity_available = quantity_available - @Quantity, updated_at = GETDATE()
    WHERE FK_product_id = @ProductID
    COMMIT TRANSACTION
    
    PRINT 'Item added to order successfully.'
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateSalesReport]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Generate Sales Report: 
--Create a stored procedure to generate a detailed sales report for a given 
--period, including itemized sales and total revenue.

CREATE PROCEDURE [dbo].[sp_GenerateSalesReport]
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRANSACTION

    IF @StartDate IS NULL OR @EndDate IS NULL OR @StartDate > @EndDate
    BEGIN
        RAISERROR ('Invalid date range. Ensure both dates are provided and StartDate is not greater than EndDate.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    SELECT 
        O.order_id AS OrderID,
        P.product_id AS ProductID,
        P.name AS ProductName,
        OI.quantity AS QuantitySold,
        OI.unit_price AS UnitPrice,
        (OI.quantity * OI.unit_price) AS TotalRevenue,
        O.created_at AS OrderDate
    FROM ORDER_ITEMS OI
    INNER JOIN ORDERS O ON OI.FK_order_id = O.order_id
    INNER JOIN PRODUCTS P ON OI.FK_product_id = P.product_id
    WHERE O.created_at BETWEEN @StartDate AND @EndDate
    ORDER BY O.created_at DESC

    COMMIT TRANSACTION
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ManageDiscounts]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Manage Discounts: 
--Implement a stored procedure to apply or update discounts for specific 
--items or categories. 

CREATE PROCEDURE [dbo].[sp_ManageDiscounts]
    @ProductID INT,
    @Discount FLOAT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    IF @Discount < 0 OR @Discount > 1
    BEGIN
        RAISERROR ('Invalid discount value. Must be between 0 and 1.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM PRODUCTS WHERE product_id = @ProductID)
    BEGIN
        RAISERROR ('Product ID not found.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE PRODUCTS
    SET discount_amount = @Discount, updated_at = GETDATE(), updated_by = 'System'
    WHERE product_id = @ProductID;

    COMMIT TRANSACTION;
    PRINT 'Discount applied to product.';
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ProcessProductRequest]    Script Date: 3/13/2025 5:13:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ProcessProductRequest]
    @RequestID INT,
    @Status VARCHAR(10) 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;


    IF @Status NOT IN ('Approved', 'Rejected')
    BEGIN
        RAISERROR ('Invalid status. Allowed values are Approved or Rejected.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM PRODUCT_REQUESTS WHERE request_id = @RequestID AND is_active = 1)
    BEGIN
        RAISERROR ('Product request not found or inactive.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE PRODUCT_REQUESTS
    SET status = @Status, updated_at = GETDATE()
    WHERE request_id = @RequestID;

    COMMIT TRANSACTION;
    PRINT 'Product request processed successfully.';
END
GO
USE [master]
GO
ALTER DATABASE [Cosmatics Online Store] SET  READ_WRITE 
GO
