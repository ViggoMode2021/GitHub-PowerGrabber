#GitHub PowerGrabber!

# References: 
<#

https://4sysops.com/archives/powershell-invoke-webrequest-parse-and-scrape-a-web-page/

https://pipe.how/invoke-webscrape/

https://blog.ironmansoftware.com/daily-powershell/powershell-download-github/

#>

$DesktopPath = [Environment]::GetFolderPath("Desktop")

Write-Host "###################################################################################################################" -ForegroundColor "Cyan"

Write-Host "Welcome to GitHub-PowerGrabber! This script will download zip folders of all repositories associated with a requested GitHub page.
It is written in 100% PowerShell and does not get Git to be installed. Enjoy!" -ForegroundColor "Green"

Write-Host Write-Host "###################################################################################################################" -ForegroundColor "Cyan"

$GitHub_Profile_Name = Read-Host "What is the name of the GitHub profile you would like to use?"

$Last_Letter = $GitHub_Profile_Name -replace '^.*(?=.{1}$)'

$URL_Suffix = $GitHub_Profile_Name + '?tab=repositories'

$URL = "https://github.com/$URL_Suffix"

$Site = Invoke-WebRequest $URL

$GitHub_Profile_Name_With_Slashes = '/' + $GitHub_Profile_Name + '/'

$Links = $Site.Links | Select href | Export-CSV .\GitHub-Links.csv

$GitHub_Links = Import-CSV -Path .\GitHub-Links.csv

$Repository_Names = Import-CSV -Path .\GitHub-Links.csv | Where-Object { $_ -match "$GitHub_Profile_Name_With_Slashes" -and $_ -notmatch 'stargazers' } | Out-String


$Count_Repositories = Import-CSV -Path .\GitHub-Links.csv | Where-Object href -match "$GitHub_Profile_Name_With_Slashes" | Measure-Object | Select -expand count

Write-Host "Here are the repositories to download: $Repository_Names" -ForegroundColor "Cyan"

Write-Host "There are $Count_Repositories repositories associated with GitHub profile $GitHub_Profile_Name." -ForegroundColor "Cyan"

Read-Host "Press any key to continue and download these repositories:"

foreach ($Link in $GitHub_Links) {

$Link = $Link.href

if($Link -match $GitHub_Profile_Name_With_Slashes -and $Link -notmatch "stargazers") {

$Base_URL = "https://github.com/"

$URL_Suffix_Zip = "/archive/refs/heads/main.zip"

$Full_Url = $Base_URL + $Link + $URL_Suffix_Zip

$Position = $Link.IndexOf($Last_Letter)

$Repository = $Link.Substring($Position+2)

Write-Host "Downloading $Repository"

$GitHub_Repositories_Directory = "$DesktopPath\GitHub-Repositories-$GitHub_Profile_Name"

Write-Host $GitHub_Repositories_Directory -ForegroundColor "Cyan"

if(Test-Path $GitHub_Repositories_Directory){

Set-Location -Path $GitHub_Repositories_Directory

Invoke-WebRequest $Full_Url -OutFile .\$Repository.zip
#Expand-Archive '$DesktopPath\GitHub-Repositories-For-$GitHub_Profile_Name\$Link.zip' '$DesktopPath\GitHub-Repositories-For-$GitHub_Profile_Name'
#Rename-Item .\PowerShellScripts-main .\PowerShellScripts
#Remove-Item .\PowerShellScripts.zip

}

else{

New-Item -Path "$DesktopPath\GitHub-Repositories-$GitHub_Profile_Name" -ItemType Directory

$GitHub_Repositories_Directory = '$DesktopPath\GitHub-Repositories-$GitHub_Profile_Name'

Set-Location -Path $GitHub_Repositories_Directory

Invoke-WebRequest $Full_Url -OutFile .\$Repository.zip
#Expand-Archive .\PowerShellScripts.zip .\
#Rename-Item .\PowerShellScripts-main .\PowerShellScripts
#Remove-Item .\PowerShellScripts.zip

}


}

}
