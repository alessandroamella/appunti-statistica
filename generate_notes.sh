#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Parse command line arguments
DARK_MODE=false
COMPILE_ONCE=false
SKIP_IMAGES=false
COMPILE_ALL=false
for arg in "$@"; do
  case "$arg" in
  "--dark")
    DARK_MODE=true
    ;;
  "--once")
    COMPILE_ONCE=true
    ;;
  "--no-images")
    SKIP_IMAGES=true
    ;;
  "-a" | "--all")
    COMPILE_ALL=true
    ;;
  esac
done

# Versione completa per la generazione del documento finale
echo "==================================================================="
echo "= Script per generare un documento LaTeX unificato da file multipli ="
echo "==================================================================="

# Show theme information
if [ "$DARK_MODE" = true ]; then
  echo "📝 Tema scuro selezionato"
else
  echo "📝 Tema chiaro selezionato (default)"
fi

# Show image generation status
if [ "$SKIP_IMAGES" = true ]; then
  echo "🖼️ Generazione immagini disattivata"
fi

# Show individual compilation status
if [ "$COMPILE_ALL" = true ]; then
  echo "📄 Compilazione individuale dei file attivata"
fi

# Prima verifica che tutti i file esistano
echo "Verifico che tutti i file necessari siano presenti..."

FILES=(
  "01-spazio-prob-condiz.tex"
  "02-calcolo-combinatorio.tex"
  "03-var-aleatorie.tex"
  "04-markov.tex"
  "05-formulari.tex"
)

# Generate the appropriate preamble
echo "Generando il preambolo appropriato..."
if [ "$DARK_MODE" = true ]; then
  ./generate_preamble.sh --dark --no-document-class
  echo "✅ Preambolo con tema scuro generato."
else
  ./generate_preamble.sh --no-document-class
  echo "✅ Preambolo con tema chiaro generato."
fi

FILES+=("preambolo_comune.tex")

MISSING=false
for FILE in "${FILES[@]}"; do
  if [ ! -f "$FILE" ]; then
    echo "⚠️ File mancante: $FILE"
    MISSING=true
  fi
done

if [ "$MISSING" = true ]; then
  echo "Alcuni file necessari mancano. Assicurati che tutti i file siano nella directory corrente."
  exit 1
fi

echo "✅ Tutti i file necessari sono presenti."

# 1. Crea il documento master
echo "Creando il documento master 'appunti_completi.tex'..."

# Choose the appropriate hypersetup based on theme
if [ "$DARK_MODE" = true ]; then
  HYPERSETUP='
\hypersetup{
    colorlinks=true,
    linkcolor=white,
    filecolor=magenta,
    urlcolor=cyan,
    pdftitle={Appunti Completi di Calcolo delle Probabilità e Statistica},
    pdfauthor={Alessandro Amella},
    pdfpagemode=FullScreen,
}'
else
  HYPERSETUP='
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    filecolor=magenta,
    urlcolor=cyan,
    pdftitle={Appunti Completi di Calcolo delle Probabilità e Statistica},
    pdfauthor={Alessandro Amella},
    pdfpagemode=FullScreen,
}'
fi

cat >appunti_completi.tex <<EOT
\documentclass{report}

% Importa tutte le configurazioni dal preambolo comune
\input{preambolo_comune}

% Hyperref configurazione globale (sovrascrive quella nel preambolo)
$HYPERSETUP

% Titolo del documento unificato
\title{Appunti Completi di Calcolo delle Probabilità e Statistica\\\\
  \large Basati sulle dispense della Prof.ssa Elena Bandini}
\author{Alessandro Amella, Gemini e Claude}
\date{\today}

\begin{document}

\maketitle
\tableofcontents
\clearpage

\chapter*{Informazioni sul Documento}
\addcontentsline{toc}{chapter}{Informazioni sul Documento}

Questo documento è la versione compilata automaticamente di tutti i miei appunti di Calcolo delle Probabilità e Statistica per il corso di Laurea in Informatica all'Università di Bologna.

\begin{itemize}
  \item \textbf{Fonte}: Tutti gli appunti sono disponibili come file separati nella repository GitHub: 
        \url{https://github.com/alessandroamella/appunti-statistica}
  \item \textbf{Generazione}: Questo PDF è stato generato automaticamente utilizzando uno script che unisce tutti i singoli file .tex degli appunti.
  \item \textbf{Aggiornamenti}: Per la versione più recente degli appunti, visita la pagina delle release:
        \url{https://github.com/alessandroamella/appunti-statistica/releases/latest}
  \item \textbf{Uso di AI}: Ho usato Gemini e Claude a manetta.
\end{itemize}

\doclicenseThis

Sentiti libero di utilizzare, condividere o contribuire a questi appunti attraverso la repository GitHub.

\clearpage

\chapter{Spazio Campionario e Probabilità}
\input{01-spazio-prob-condiz-content}

\chapter{Calcolo Combinatorio}
\input{02-calcolo-combinatorio-content}

\chapter{Variabili Aleatorie}
\input{03-var-aleatorie-content}

\chapter{Catene di Markov}
\input{04-markov-content}

\appendix

\chapter{Formulario}
\input{05-formulari-content}

\end{document}
EOT

echo "✅ appunti_completi.tex creato."

# 3. Per ogni file .tex, estrai il contenuto e correggi l'indentazione minted
echo "Estraendo contenuto dai file e correggendo l'indentazione minted..."

for FILE in "${FILES[@]}"; do
  # Process files that start with numbers followed by hyphen
  if [[ $FILE =~ ^[0-9]+-.*\.tex$ ]]; then
    CONTENT_FILE="${FILE%.tex}-content.tex"
    TEMP_FILE="${FILE%.tex}-temp.tex"
    echo "Elaborazione di $FILE -> $CONTENT_FILE"

    # Estrai contenuto tra \begin{document} e \end{document}
    sed -n '/\\begin{document}/,/\\end{document}/p' "$FILE" |
      # Rimuovi righe specifiche
      grep -v '\\begin{document}\|\\end{document}\|\\maketitle\|\\tableofcontents\|\\newpage' >"$TEMP_FILE"

    # Correggi l'indentazione dei blocchi minted
    echo "Correggendo l'indentazione minted in $TEMP_FILE..."
    ./fix_minted_indent.sh "$TEMP_FILE" >"$CONTENT_FILE"

    # Rimuovi il file temporaneo
    rm "$TEMP_FILE"

    echo "✅ $CONTENT_FILE creato con indentazione minted corretta."
  fi
done

echo "✅ Estrazione e correzione completate."

# 4. Esegui tutti i file Python per generare le immagini
echo
echo "==================================================================="
if [ "$SKIP_IMAGES" = true ]; then
  echo "Generazione immagini saltata (parametro --no-images attivo)."
else
  echo "Esecuzione di tutti gli script Python per generare immagini in parallelo..."

  PYTHON_FILES=($(find . -maxdepth 1 -name "*.py"))

  if [ ${#PYTHON_FILES[@]} -eq 0 ]; then
    echo "Nessun file Python trovato nella directory corrente."
  else
    echo "Trovati ${#PYTHON_FILES[@]} file Python da eseguire."

    # Function to execute a Python script
    execute_python_script() {
      local py_file="$1"
      echo "Eseguendo $py_file..."

      # Check if dark mode is enabled and file contains "--dark"
      if [ "$DARK_MODE" = true ] && grep -q "\-\-dark" "$py_file"; then
        echo "  → Modalità scura attiva, aggiungendo parametro --dark"
        if python3 "$py_file" --dark >/dev/null 2>&1; then
          echo "✅ $py_file eseguito con successo."
          return 0
        else
          echo "⚠️ $py_file ha restituito un errore."
          return 1
        fi
      else
        if python3 "$py_file" >/dev/null 2>&1; then
          echo "✅ $py_file eseguito con successo."
          return 0
        else
          echo "⚠️ $py_file ha restituito un errore."
          return 1
        fi
      fi
    }

    export -f execute_python_script
    export DARK_MODE

    # Execute Python scripts in parallel with a progress bar
    printf '%s\n' "${PYTHON_FILES[@]}" | parallel --bar execute_python_script

    echo "✅ Esecuzione degli script Python completata."
  fi
fi

# 5. Compila il documento automaticamente
echo
echo "==================================================================="
echo "Compilando il documento..."

# Use a temporary file for compilation
TEMP_PDF="appunti_completi_temp.pdf"
FINAL_PDF="appunti_completi.pdf"

# First compilation
echo "Prima compilazione..."
if ! pdflatex -shell-escape -jobname="${TEMP_PDF%.pdf}" appunti_completi.tex; then
  echo "❌ Errore durante la prima compilazione. Il PDF non è stato generato."
  exit 1
fi

if [ "$COMPILE_ONCE" = false ]; then
  echo "Compilando una seconda volta per l'indice..."
  if ! pdflatex -shell-escape -jobname="${TEMP_PDF%.pdf}" appunti_completi.tex; then
    echo "❌ Errore durante la seconda compilazione. Il PDF non è stato generato."
    exit 1
  fi
fi

# Check if the temporary PDF was created
if [ ! -f "$TEMP_PDF" ]; then
  echo "❌ Il file PDF temporaneo non è stato creato."
  exit 1
fi

# Move the temporary file to the final location
mv "$TEMP_PDF" "$FINAL_PDF"
echo "✅ Compilazione completata con successo."
echo "Il documento PDF è stato generato come '$FINAL_PDF'"

# If --all is specified, compile individual files
if [ "$COMPILE_ALL" = true ]; then
  echo
  echo "==================================================================="
  echo "Compilando i file individuali in parallelo..."

  # Generate the appropriate preamble, with document class
  if [ "$DARK_MODE" = true ]; then
    ./generate_preamble.sh --dark
  else
    ./generate_preamble.sh
  fi

  # Function to compile a single file
  compile_file() {
    local file="$1"
    echo "Compilando $file..."

    # First compilation
    if ! pdflatex -shell-escape "$file" >/dev/null 2>&1; then
      echo "⚠️ Errore durante la prima compilazione di $file"
      return 1
    fi

    if [ "$COMPILE_ONCE" = false ]; then
      # Second compilation for TOC
      if ! pdflatex -shell-escape "$file" >/dev/null 2>&1; then
        echo "⚠️ Errore durante la seconda compilazione di $file"
        return 1
      fi
    fi

    echo "✅ $file compilato con successo"
    return 0
  }

  export -f compile_file
  export COMPILE_ONCE

  # Filter only numbered tex files and compile them in parallel
  printf '%s\n' "${FILES[@]}" | grep '^[0-9].*\.tex$' | parallel --bar compile_file

  echo "==================================================================="
fi

echo "==================================================================="
echo "Processo completato con successo!"
echo "==================================================================="
