--Cleaning Data via SQL Queries
select *
from PortfolioProject.dbo.housingdata

--Standardize Date format
select saledate, cast(SaleDate as date)
from PortfolioProject.dbo.housingdata

alter table housingdata
add SaleDateConverted date;

update housingdata
set SaleDateConverted = cast(SaleDate as date) 

--Populate Null Property Address Data
select PropertyAddress
from PortfolioProject.dbo.housingdata

select a.parcelid, a.PropertyAddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from PortfolioProject.dbo.housingdata a
join PortfolioProject.dbo.housingdata b
	on a.Parcelid = b.Parcelid
	and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
from PortfolioProject.dbo.housingdata a
join PortfolioProject.dbo.housingdata b
	on a.Parcelid = b.Parcelid
	and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null

--Split addresses into Individual Columns (address, city, state) using substring and parsing
--Property Address
alter table housingdata
add MainAddress nvarchar(255);

update housingdata
set MainAddress = substring(PropertyAddress, 1, charindex(',',PropertyAddress) - 1)

alter table housingdata
add City nvarchar(255);

update housingdata
set City = substring(PropertyAddress, charindex(',',PropertyAddress) + 1, len(Propertyaddress))

--Owner Address
select
parsename(replace(owneraddress,',','.'), 3) as OwnerMainAddress,
parsename(replace(owneraddress,',','.'), 2) as OwnerCity,
parsename(replace(owneraddress,',','.'), 1) as OwnerState
from housingdata

alter table housingdata
add Ownerstate nvarchar(255);

update housingdata
set Ownermainaddress = parsename(replace(owneraddress,',','.'), 3)

alter table housingdata
add OwnerCity nvarchar(255);

update housingdata
set OwnerCity = parsename(replace(owneraddress,',','.'), 2)

alter table housingdata
add OwnerMainAddress nvarchar(255);

update housingdata
set OwnerState = parsename(replace(owneraddress,',','.'), 1)

--Change Y or N to Yes or No
update housingdata
set soldasvacant = case 
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end

--Delete Unused Columns
alter table housingdata
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







