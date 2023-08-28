/*
Cleaning Data in SQL Queries

Using Skill: update set, alter table add column, str_to_date, substring locate, case when, self join
*/

select *
from Portfolio_Project.NashvilleHousing;


-- Standardize SaleDate Format
update Portfolio_Project.NashvilleHousing
set SaleDate = str_to_date(SaleDate, '%d-%b-%y');



-- Populate Property Address to Change Null Value
update Portfolio_Project.NashvilleHousing n1
join Portfolio_Project.NashvilleHousing n2
	on n1.parcelid = n2.parcelid
set n1.propertyaddress = n2.PropertyAddress
where n1.PropertyAddress is null
and n2.PropertyAddress is not null;



-- Breaking out Propertyaddress into Individual Columns (Address, City, State)
select PropertyAddress, 
	substring(propertyaddress, 1, locate(',', propertyaddress)-1) propertysplitaddress,
	substring(propertyaddress, locate(',', propertyaddress)+1, length(propertyaddress)) propertysplitcity
from Portfolio_Project.NashvilleHousing;


alter table NashvilleHousing
add column propertysplitaddress varchar(255),
add column propertysplitcityy varchar(255);


update NashvilleHousing
set propertysplitaddress = substring(propertyaddress, 1, locate(',', propertyaddress)-1),
	propertysplitcity = substring(propertyaddress, locate(',', propertyaddress)+1, length(propertyaddress));



-- Change Y and N to Yes and No in 'Sold as Vacant' column
select 
	SoldAsVacant,
	case 
		when SoldAsVacant = 'N' then 'No'
        when soldasvacant = 'Y' then 'Yes'
        else soldasvacant 
	end new_soldasvacant
from Portfolio_Project.NashvilleHousing;


update Portfolio_Project.NashvilleHousing
set SoldAsVacant = case 
			when SoldAsVacant = 'N' then 'No'
			when soldasvacant = 'Y' then 'Yes'
			else soldasvacant 
		   end;



-- Remove Duplicates
delete nh1.*
from Portfolio_Project.NashvilleHousing nh1
join Portfolio_Project.NashvilleHousing nh2
	on nh1.ParcelID = nh2.ParcelID
    and nh1.LandUse = nh2.LandUse              
    and nh1.PropertyAddress = nh2.PropertyAddress
    and nh1.SaleDate = nh2.SaleDate
    and nh1.SalePrice = nh2.SalePrice
    and nh1.LegalReference = nh2.LegalReference
where nh1.uniqueid > nh2.uniqueid;



-- Delete Unused Columns
select *
from portfolio_project.nashvillehousing;

alter table portfolio_project.nashvillehousing
drop column propertyaddress,
drop column owneraddress,
drop column taxdistrict;



-- split owneraddress by using the same way of propertyaddress
select OwnerAddress, 
	substring(owneraddress, 1, locate(',', owneraddress)-1) ownersplitaddress,
	substring(owneraddress,
				locate(',', owneraddress)+2, 
				locate(',', owneraddress,
					locate(',', owneraddress)+1) - 
				locate(',', owneraddress) - 2) ownersplitcity,
	substring(owneraddress, locate(',', owneraddress,locate(',', owneraddress)+1)+1, length(owneraddress)) ownersplitstate
from Portfolio_Project.NashvilleHousing;


alter table NashvilleHousing
add column ownersplitaddress varchar(255),
add column ownersplitcity varchar(255),
add column ownersplitstate varchar(255);

update NashvilleHousing
set ownersplitaddress = substring(owneraddress, 1, locate(',', owneraddress)-1),
	ownersplitcity = substring(owneraddress, locate(',', owneraddress)+2, locate(',', owneraddress, locate(',', owneraddress)+1) - locate(',', owneraddress) - 2),
	ownersplitstate = substring(owneraddress, locate(',', owneraddress,locate(',', owneraddress)+1)+1, length(owneraddress));




