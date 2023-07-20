<#
Invoke-WebRequest 'https://github.com/ViggoMode2021/PowerShellScripts/archive/refs/heads/main.zip' -OutFile .\PowerShellScripts.zip
Expand-Archive .\PowerShellScripts.zip .\
Rename-Item .\PowerShellScripts-main .\PowerShellScripts
Remove-Item .\PowerShellScripts.zip
#>

# https://4sysops.com/archives/powershell-invoke-webrequest-parse-and-scrape-a-web-page/

# https://pipe.how/invoke-webscrape/

# https://blog.ironmansoftware.com/daily-powershell/powershell-download-github/

$DesktopPath = [Environment]::GetFolderPath("Desktop")

$GitHub_Profile_Name = Read-Host "What is the name of the GitHub profile you would like to use?"

$GitHub_Profile_Name = 'ViggoMode2021'

$Last_Letter = $GitHub_Profile_Name -replace '^.*(?=.{1}$)'

$URL_Suffix = $GitHub_Profile_Name + '?tab=repositories'

$URL = "https://github.com/$URL_Suffix"

$Site = Invoke-WebRequest $URL

$GitHub_Profile_Name_With_Slashes = '/' + $GitHub_Profile_Name + '/'

$Links = $Site.Links | Select href | Export-CSV .\GitHub-Links.csv

$GitHub_Links = Import-CSV -Path .\GitHub-Links.csv

foreach ($Link in $GitHub_Links) {

$Link = $Link.href

if($Link -match $GitHub_Profile_Name_With_Slashes) {

$Base_URL = "https://github.com/"

$URL_Suffix_Zip = "/archive/refs/heads/main.zip"

$Full_Url = $Base_URL + $Link + $URL_Suffix_Zip

$Position = $Link.IndexOf($Last_Letter)

$Repository = $Link.Substring($Position+2)

Write-Host "Downloading $Repository"

$GitHub_Repositories_Directory = '$DesktopPath\GitHub-Repositories-$GitHub_Profile_Name'

if(Test-Path '$GitHub_Repositories_Directory'){

Invoke-WebRequest $Full_Url -OutFile .\$Repository.zip
#Expand-Archive '$DesktopPath\GitHub-Repositories-For-$GitHub_Profile_Name\$Link.zip' '$DesktopPath\GitHub-Repositories-For-$GitHub_Profile_Name'
#Rename-Item .\PowerShellScripts-main .\PowerShellScripts
#Remove-Item .\PowerShellScripts.zip

}

else{

New-Item -Path "$DesktopPath\GitHub-Repositories-$GitHub_Profile_Name" -ItemType Directory

Invoke-WebRequest $Full_Url -OutFile .\$Repository.zip
#Expand-Archive .\PowerShellScripts.zip .\
#Rename-Item .\PowerShellScripts-main .\PowerShellScripts
#Remove-Item .\PowerShellScripts.zip

}



}

}
