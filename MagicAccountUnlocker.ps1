# Read in some usernames from a file and unlock them if they are locked & send an email out if unlocking them
#
# Ian Manning 2011-01-24
#

Add-PSSnapin Quest.ActiveRoles.ADManagement
# Email Configuration
$smtpsrv = "smtp0"
$from = "server@server.com"
$emailsubject = "Account unlocked by script  Account was "
# Connect to the local DC
Connect-QADService (Get-Content env:logonserver).Replace("\","")

$objConfig = Import-Csv "D:\ScheduledPSScripts\ADMonitoring\MagicAccountUnlocker\UnlockTheseAccounts.csv"

$objConfig | % { 
	$strTo = $_.EmailRecipients.Split(";")
$objUser = Get-QADUser $_.AccountToUnlock
If ( $objUser.AccountIsLockedOut -eq $true ) { 
	Unlock-QADUser $objUser
    Send-MailMessage -From $from -To ($strTo) -Subject ($emailsubject + $objUser.sAMAccountName) -Body $_.Message -SmtpServer $smtpsrv
	}
	}
	

