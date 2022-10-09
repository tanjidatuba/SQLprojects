/*

Cleaning data in SQL

*/

Select *
From [Portfolio Project].dbo.[housingdata]


Select SaleDate
From [Portfolio Project].dbo.[housingdata]

---saledate standardization
Select SaleDate, CONVERT(Date,SaleDate) as datenew
From [Portfolio Project].dbo.[housingdata]





ALTER TABLE housingdata
add Saledateconverted Date;

update housingdata
set Saledateconverted = CONVERT(Date,SaleDate)

SELECT Saledateconverted
FROM [Portfolio Project].dbo.[housingdata]

---populate property adress

SELECT *
FROM [Portfolio Project].dbo.[housingdata]
WHERE PropertyAddress is null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,a.UniqueID, b.UniqueID, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].dbo.[housingdata] a
JOIN [Portfolio Project].dbo.[housingdata] b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].dbo.[housingdata] a
JOIN [Portfolio Project].dbo.[housingdata] b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null

SELECT *
FROM [Portfolio Project].dbo.[housingdata]
WHERE PropertyAddress is null


----Breaking the address in state
SELECT 
SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress))
FROM [Portfolio Project].dbo.housingdata

ALTER TABLE [Portfolio Project].dbo.[housingdata]
add propertysplitaddress nvarchar(255);

update [Portfolio Project].dbo.[housingdata]
SET propertysplitaddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE [Portfolio Project].dbo.[housingdata]
add propertyaddresscity nvarchar(255);

update [Portfolio Project].dbo.[housingdata]
SET propertyaddresscity = SUBSTRING(propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress)) 


SELECT *
FROM [Portfolio Project].dbo.[housingdata]

----owneraddress

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [Portfolio Project].dbo.housingdata


ALTER TABLE [Portfolio Project].dbo.[housingdata]
add ownerstate nvarchar(255);

update [Portfolio Project].dbo.[housingdata]
SET ownerstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 

ALTER TABLE [Portfolio Project].dbo.[housingdata]
add ownercity nvarchar(255);

update [Portfolio Project].dbo.[housingdata]
SET ownercity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

ALTER TABLE [Portfolio Project].dbo.[housingdata]
add ownerroad nvarchar(255);

update [Portfolio Project].dbo.[housingdata]
SET ownerroad = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 

SELECT *
FROM [Portfolio Project].dbo.housingdata

---format yes and no

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project].dbo.housingdata
Group by SoldAsVacant
Order by 1


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 1 THEN 'YES' 
	ELSE 'NO' 
	END as soldasvacnew

FROM [Portfolio Project].dbo.housingdata


UPDATE [Portfolio Project].dbo.housingdata
SET SoldAsVacant = CASE(CASE WHEN SoldAsVacant = 1 THEN 'YES' 
	ELSE 'NO' 
	END) as int)




ALTER TABLE [Portfolio Project].dbo.[housingdata]
add soldstate nvarchar(255);

update [Portfolio Project].dbo.[housingdata]
SET soldstate = CASE WHEN SoldAsVacant = 1 THEN 'YES' 
	ELSE 'NO' 
	END

SELECT *
FROM [Portfolio Project].dbo.housingdata

----remove duplicates

WITH RownumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference,
				SaleDate
				ORDER BY
				UniqueID
				) row_num
FROM [Portfolio Project].dbo.housingdata
)

SELECT *
FROM RownumCTE
WHERE row_num >1
ORDER by Propertyaddress
DELETE 
FROM RownumCTE
WHERE row_num >1


ALTER TABLE [Portfolio Project].dbo.housingdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

SELECT *
FROM [Portfolio Project].dbo.housingdata