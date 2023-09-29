Create Database Nashville_Housing_Data_Analytics;
Use Nashville_Housing_Data_Analytics;

Select * from Nashville;

-- Changing Datatype of SaleDate
Alter Table Nashville
Add SaleDate date;

Update Nashville
SET SaleDate = Convert(SaleDateConverted,Date);

-- Splitting PropertyAddress  
Select Substring(PropertyAddress,1,Locate(',',PropertyAddress)-1) From Nashville;
Select Substring(PropertyAddress,Locate(',',PropertyAddress)+1) From Nashville;

Alter Table Nashville
Add PropertSplitCity nvarchar(255);

Update Nashville 
Set PropertSplitCity = Substring(PropertyAddress,Locate(',',PropertyAddress)+1);

Alter Table Nashville
Add PropertSplitAddress nvarchar(255);

Update Nashville 
Set PropertSplitAddress = Substring(PropertyAddress,1,Locate(',',PropertyAddress)-1);


Select PropertyAddress,OwnerAddress from Nashville 
where Substring(PropertyAddress,1,Locate(',',PropertyAddress)) != Substring(OwnerAddress,1,Locate(',',OwnerAddress));

-- Splitting OwnerAddress 
Alter Table Nashville
Add OwnerSplitState nvarchar(255);

Update Nashville 
Set OwnerSplitState = Substring_index(OwnerAddress,",",-1);

Alter Table Nashville
Add OwnerSplitAddress nvarchar(255);

Update Nashville 
Set OwnerSplitAddress =Substring_index(OwnerAddress,",",1);

Alter Table Nashville
Add OwnerSplitCity nvarchar(255);

Update Nashville 
Set OwnerSplitCity = Substring_index(Substring_index(OwnerAddress,",",2),",",-1);

-- Converting different Yes to Y and No to N
Select Distinct SoldAsVacant, Count(SoldAsVacant)
From Nashville
Group by SoldAsVacant
Order By 2;

Update Nashville
Set SoldAsVacant = Replace(SoldAsVacant,"Yes","Y");

Update Nashville
Set SoldAsVacant = Replace(SoldAsVacant,"No","N");

-- Removing Duplicates
With RowNumCTE as 
(Select *, ROW_NUMBER() Over 
(PARTITION BY 
ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY
UniqueID) row_num
From Nashville)
Select * From RowNumCTE
Where row_num = 1;
