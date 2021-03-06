1.)

Send-MailMessage -SmtpServer 'smtp.office365.com' -From ‘sender@domain.com' -To 'someemail@domain.com' -Subject 'this is a subject' -Body 'this is the body' -UseSsl -Port 587 -Credential $credential -Verbose


2.)	test 2

$Cred = Get-Credential
$sendMailParams = @{
    From = ‘sender@domain.com' ## Must be own tenant
    To = 'someemail@domain.com'
    Subject = 'some subject'
    Body = 'some body'
    SMTPServer = ‘smtp.office365.com’
    SMTPPort = 587
    UseSsl = $true
    Credential = $Cred
}

Send-MailMessage @sendMailParams



3.) test 3
# Source https://blog.mailtrap.io/powershell-send-email/

$From = "mother-of-dragons@houseoftargaryen.net"
$To = "jon-snow@winterfell.com", "jorah-mormont@night.watch”
$Cc = "tyrion-lannister@westerlands.com"
$Attachment = "C:\Temp\Drogon.jpg"
$Subject = "Photos of Drogon"
$Body = "<h2>Guys, look at these pics of Drogon!</h2><br><br>"
$Body += “He is so cute!” 
$SMTPServer = "smtp.mailtrap.io"
$SMTPPort = "587"
Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Attachments $Attachment

4) test 4

# Source https://www.undocumented-features.com/2018/05/22/send-authenticated-smtp-with-powershell/

# Sender and Recipient Info
$MailFrom = "sender@senderdomain.com"
$MailTo = "recipient@recipientdomain.com"

# Sender Credentials
$Username = "SomeUsername@SomeDomain.com"
$Password = "SomePassword"

# Server Info
$SmtpServer = "smtp.domain.com"
$SmtpPort = "2525"

# Message stuff
$MessageSubject = "Live your best life now" 
$Message = New-Object System.Net.Mail.MailMessage $MailFrom,$MailTo
$Message.IsBodyHTML = $true
$Message.Subject = $MessageSubject
$Message.Body = @'
<!DOCTYPE html>
<html>
<head>
</head>
<body>
This is a test message to trigger an ETR.
</body>
</html>
'@

# Construct the SMTP client object, credentials, and send
$Smtp = New-Object Net.Mail.SmtpClient($SmtpServer,$SmtpPort)
$Smtp.EnableSsl = $true
$Smtp.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
$Smtp.Send($Message)