# Import Active Directory Module
Import-Module ActiveDirectory

# Define OUs to create
$OUs = @("HR", "IT", "Finance", "Operation", "Marketing")

# 1. Create OUs if they don't already exist
foreach ($OU in $OUs) {
    $OUPath = "OU=$OU,DC=lab,DC=local"
    if (-not [ADSI]::Exists("LDAP://$OUPath")) {
        New-ADOrganizationalUnit -Name $OU -Path "DC=lab,DC=local"
        Write-Host "Created OU: $OU" -ForegroundColor Green
    } else {
        Write-Host "OU already exists: $OU" -ForegroundColor Yellow
    }
}

# 2. Define standard password for all lab users
$Password = ConvertTo-SecureString "Pass1234!" -AsPlainText -Force

# 3. Generate 50 unique fake users
for ($i = 1; $i -le 50; $i++) {
    # Distribute users evenly across OUs/Departments
    $Dept = $OUs[($i % 5)] 
    
    $FirstName = "User"
    $LastName = "{0:D3}" -f $i # Format as User001, User002, etc.
    $SamAccountName = "user$i"
    $UserPrincipalName = "user$i@lab.local"
    
    # Create the user in AD
    New-ADUser -Name "$FirstName $LastName" `
               -GivenName $FirstName `
               -Surname $LastName `
               -SamAccountName $SamAccountName `
               -UserPrincipalName $UserPrincipalName `
               -Path "OU=$Dept,DC=lab,DC=local" `
               -AccountPassword $Password `
               -ChangePasswordAtLogon $false `
               -Enabled $true
               
    Write-Host "Created user: $SamAccountName ($FirstName $LastName) in OU: $Dept" -ForegroundColor Cyan
}

Write-Host "Bulk import completed successfully!" -ForegroundColor Green -BackgroundColor Black