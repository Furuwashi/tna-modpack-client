# Définition du chemin vers le fichier contenant les liens
$cheminFichier = "lien.csv"

# Vérification de la présence du fichier
if (-Not (Test-Path -Path $cheminFichier)) {
    Write-Error "Le fichier $cheminFichier est introuvable."
    exit
}

# Lecture du fichier ligne par ligne
$urls = Get-Content -Path $cheminFichier

# Boucle sur chaque URL
foreach ($url in $urls) {
    # Nettoyage des espaces et on ignore les lignes vides
    $url = $url.Trim()
    if ([string]::IsNullOrWhiteSpace($url)) { continue }

    Write-Host "Ajout en cours : $url" -ForegroundColor Cyan

    # Exécution de packwiz. 
    # Le "'n' |" envoie automatiquement "n" (non) si packwiz demande une confirmation.
    'n' | .\packwiz.exe modrinth add $url
    
    Write-Host "----------------------------------------"
}

Write-Host "Tous les liens ont été traités !" -ForegroundColor Green