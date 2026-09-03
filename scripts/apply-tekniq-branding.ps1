param(
    [ValidateSet('hulp', 'beheer')]
    [string]$Variant = 'hulp'
)

$ErrorActionPreference = 'Stop'

$appName = if ($Variant -eq 'beheer') { 'Tekniq Beheer' } else { 'Tekniq Hulp' }
$organization = if ($Variant -eq 'beheer') { 'nl.tekniq.beheer' } else { 'nl.tekniq.hulp' }

$configPath = Join-Path $PSScriptRoot '..\libs\hbb_common\src\config.rs'
$config = Get-Content -Raw -LiteralPath $configPath

$replacements = [ordered]@{
    'RwLock::new("com.carriez".to_owned())' = "RwLock::new(`"$organization`".to_owned())"
    'pub static ref PROD_RENDEZVOUS_SERVER: RwLock<String> = RwLock::new("".to_owned());' = 'pub static ref PROD_RENDEZVOUS_SERVER: RwLock<String> = RwLock::new("relay.help.tekniq.nl".to_owned());'
    'pub static ref APP_NAME: RwLock<String> = RwLock::new("RustDesk".to_owned());' = "pub static ref APP_NAME: RwLock<String> = RwLock::new(`"$appName`".to_owned());"
    'pub const RENDEZVOUS_SERVERS: &[&str] = &["rs-ny.rustdesk.com"];' = 'pub const RENDEZVOUS_SERVERS: &[&str] = &["relay.help.tekniq.nl"];'
    'pub const RS_PUB_KEY: &str = "OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=";' = 'pub const RS_PUB_KEY: &str = "ExIbdHBS3HL25yQVscXrxztQhAli8OOI8lIes1HBs38=";'
}

foreach ($entry in $replacements.GetEnumerator()) {
    if (-not $config.Contains($entry.Key)) {
        throw "Expected RustDesk source text was not found: $($entry.Key)"
    }
    $config = $config.Replace($entry.Key, $entry.Value)
}

Set-Content -LiteralPath $configPath -Value $config -Encoding utf8NoBOM -NoNewline

Write-Host "$appName branding and self-hosted server settings applied."
