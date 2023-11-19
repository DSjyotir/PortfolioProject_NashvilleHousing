
-- DATA CLEANING IN SQL



SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]



  --changing date 
  Select SaleDateConverted, CONVERT(Date, SaleDate)
  from PortfolioProject.dbo.NashvilleHousing

  Update NashvilleHousing
  SET SaleDate= CONVERT(Date,SaleDate)

  alter table NashvilleHousing
  add SaleDateConverted Date;

  Update NashvilleHousing
  set SaleDateConverted = CONVERT(Date,SaleDate) 


  select * from NashvilleHousing
  --------------------------------------------------------------


  --Handling Null Value

  select * from NashvilleHousing
  Where PropertyAddress IS NULL

  
  select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a inner join PortfolioProject.dbo.NashvilleHousing b on a.ParcelID=b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

  Update a

  SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProject.dbo.NashvilleHousing a INNER JOIN 
  PortfolioProject.dbo.NashvilleHousing b ON 
  a.ParcelID=b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is NULL

  -------------------------------------------------------------------------------------
  --splitting of address into multiple columns with ',' or '.'


  Select PropertyAddress 
  ,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
  ,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)), CHARINDEX(',',PropertyAddress)
  from NashvilleHousing


 alter table NashvilleHousing
 add PropertysplitAddress Nvarchar(255)

 Update NashvilleHousing
 set PropertysplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


 alter table NashvilleHousing
 add PropertysplitCity nvarchar(225)

 update NashvilleHousing
 set PropertysplitCity = SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress))


 select 
 PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnerState
 ,PARSENAME(Replace(OwnerAddress,',','.'),2) as OwnerCity
 ,PARSENAME(REPLACE(OwnerAddress, ',','.'),3) as Ownerstreetaddress
 from NashvilleHousing

 alter table NashvilleHousing
 add OwnerState nvarchar(100)

 alter table NashvilleHousing
 add OwnerCity nvarchar(100)

 alter table NashvilleHousing
 add Ownerstreetaddress nvarchar(100)

 update NashvilleHousing
 SET OwnerState = PARSENAME(Replace(OwnerAddress,',','.'),3)

 update NashvilleHousing
 set OwnerCity= PARSENAME(replace(OwnerAddress,',','.'),2)

 update NashvilleHousing
 set Ownerstreetaddress = PARSENAME(replace(OwnerAddress,',','.'),1)


 alter table NashvilleHousing
 add ConvertedDate Date

 update NashvilleHousing 
 set ConvertedDate = CONVERT(Date,SaleDate)

 select * from NashvilleHousing

 --------------------------------------------

 --change 'Y' and 'N' into 'Yes' and 'No' in "Sold as Vacant" field


 select Distinct (SoldAsVacant),
 COUNT(SoldAsVacant) from NashvilleHousing
 Group by SoldAsVacant

 Select SoldAsVacant 
 ,CASE when SoldAsVacant ='Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant= CASE when SoldAsVacant ='Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


	   Select * from NashvilleHousing

	   select Distinct(SoldAsVacant), count(SoldAsVacant)
	   from NashvilleHousing
	   Group by SoldAsVacant


	   -------------------------------------------------------------


	   --Remove Duplicates using CTE

	   With Rownum_cte AS 
	   (select *, Row_Number() OVER(
	          Partition By ParcelID,
	          PropertyAddress,
			  SaleDate,
			  SalePrice,
			  LegalReference
			  order by ParcelID
			  ) row_num

	  from NashvilleHousing
	  )
	  Select * from Rownum_cte
	  where row_num>1
	  order by PropertyAddress


	  ----------------------------------------------------------

	  --Delete unused columns

	  select * from NashvilleHousing

	  alter table NashvilleHousing
	  DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

	  ALTER TABLE NashvilleHousing
	  Drop column SaleDate
	  ---------------------------------------------------------





