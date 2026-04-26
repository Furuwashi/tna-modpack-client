param (
    [Parameter(Mandatory=$true, HelpMessage="Spécifiez la cible : 'client' (c) ou 'server' (s)")]
    [ValidateSet('client', 'c', 'server', 's')]
    [string]$Cible
)

# Configuration selon le paramètre choisi
if ($Cible -eq 'client' -or $Cible -eq 'c') {
    $nomDossier = "..\client"
    $nomFichier = "lien-client.csv"
    $nomAffichage = "Client"
} else {
    $nomDossier = "..\server"
    $nomFichier = "lien-server.csv"
    $nomAffichage = "Serveur"
}

# Utilisation de $PSScriptRoot pour garantir que les chemins sont toujours corrects,
# même si tu lances le script depuis un autre dossier.
$cheminFichier = Join-Path -Path $PSScriptRoot -ChildPath $nomFichier
$cheminCible   = Join-Path -Path $PSScriptRoot -ChildPath $nomDossier

# Vérifications
if (-Not (Test-Path -Path $cheminFichier)) {
    Write-Error "Le fichier $nomFichier est introuvable dans le dossier scripts/."
    exit
}

if (-Not (Test-Path -Path $cheminCible)) {
    Write-Error "Le dossier cible $nomDossier est introuvable."
    exit
}

# Lecture du fichier
$urls = Get-Content -Path $cheminFichier

Write-Host "Début de l'importation pour le $nomAffichage..." -ForegroundColor Yellow

# On sauvegarde l'emplacement actuel et on se déplace dans le dossier cible
# C'est vital car packwiz doit s'exécuter là où se trouve le pack.toml
Push-Location -Path $cheminCible

# Boucle sur chaque URL
foreach ($url in $urls) {
    $url = $url.Trim()
    if ([string]::IsNullOrWhiteSpace($url)) { continue }

    Write-Host "Ajout en cours : $url" -ForegroundColor Cyan

    # Exécution du packwiz local au dossier cible
    'n' | .\packwiz.exe modrinth add $url
    
    Write-Host "----------------------------------------"
}

# --- Le rafraîchissement ---
Write-Host "Mise à jour de l'index global (packwiz refresh)..." -ForegroundColor Yellow
.\packwiz.exe refresh
Write-Host "Index mis à jour avec succès !" -ForegroundColor Green
Write-Host "----------------------------------------"

# On revient proprement dans le dossier scripts/
Pop-Location

Write-Host "Tous les liens ont été traités pour le $nomAffichage !" -ForegroundColor Green