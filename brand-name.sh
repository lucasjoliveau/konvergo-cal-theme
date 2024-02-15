#!/bin/bash

# Définit les chaînes de recherche et de remplacement
SEARCH1="Cal.com"
SEARCH2="Calendso" # Ancien nom utilisé pour Cal.com
REPLACE="Konvergo CAL"
DIRECTORY="./"
EXCLUDE_DIR="--exclude-dir=node_modules"

# Initialise les compteurs
countFiles=0
countReplaced=0
countSearch1=0
countSearch2=0
countFailed=0

# Cherche les fichiers contenant les chaînes de recherche, en excluant le dossier node_modules
FILES=$(grep -Rl $EXCLUDE_DIR -E "$SEARCH1|$SEARCH2" $DIRECTORY)

# Boucle à travers les fichiers trouvés
for FILE in $FILES
do
  echo "--------------------------------------------------------------------------------"
  echo "Analyse de $FILE"
  let countFiles++
  
  # Vérifie et affiche le contexte pour les chaînes de recherche
  if grep -q -E "$SEARCH1|$SEARCH2" "$FILE"; then
    echo "Occurrences de '$SEARCH1' ou '$SEARCH2' trouvées :"
    grep -C 2 -E "$SEARCH1|$SEARCH2" "$FILE"
    grep -q "$SEARCH1" "$FILE" && let countSearch1++
    grep -q "$SEARCH2" "$FILE" && let countSearch2++
    
    # Exécute le remplacement
    if sed -i "s/$SEARCH1/$REPLACE/g; s/$SEARCH2/$REPLACE/g" "$FILE"; then
      echo "Remplacement effectué dans $FILE"
      let countReplaced++
    else
      echo "Échec du remplacement dans $FILE"
      let countFailed++
    fi
  fi
done

echo "--------------------------------------------------------------------------------"
echo "Résumé :"
echo "Fichiers analysés : $countFiles"
echo "Fichiers modifiés : $countReplaced"
echo "Occurrences '$SEARCH1' remplacées : $countSearch1"
echo "Occurrences '$SEARCH2' remplacées : $countSearch2"
echo "Échecs de remplacement : $countFailed"