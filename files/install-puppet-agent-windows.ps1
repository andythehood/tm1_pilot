Param()
Set-TimeZone "AUS Eastern Standard Time"
# These are per user settings, so not useful when running as a Startup script
# Should use GPO to set these
# Set-WinHomeLocation 12
# Set-WinSystemLocale en-AU

$puppet_uri = "https://downloads.puppetlabs.com/windows/puppet/puppet-agent-x64-latest.msi"
$puppet_msi = Split-Path -Leaf $puppet_uri
Invoke-WebRequest -Uri $puppet_uri -OutFile "c:/windows/temp/$puppet_msi"
Start-Process -FilePath "c:/windows/temp/$puppet_msi" -ArgumentList "/qn PUPPET_MASTER_SERVER=${tpl_PUPPET_SERVER}" -Wait

# Install Google Chrome
$chrome_uri = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B2CA098CA-A146-824F-FF8C-AEB59612F365%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeSetup.exe"
$chrome_setup = Split-Path -Leaf $chrome_uri
Invoke-WebRequest -Uri $chrome_uri -OutFile "c:/windows/temp/$chrome_setup"
Start-Process -FilePath "c:/windows/temp/$chrome_setup" -Wait
