$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("qaa-latn")
Set-WinUserLanguageList $LanguageList -Force
$LanguageList = Get-WinUserLanguageList
$Language = $LanguageList | where LanguageTag -eq "qaa-Latn"
$LanguageList.Remove($Language)
Set-WinUserLanguageList $LanguageList -Force