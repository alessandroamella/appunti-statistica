#!/bin/bash

# Nome del file di output
OUTPUT_FILE="preambolo_comune.tex"

# Flag per includere o meno \documentclass
INCLUDE_DOCUMENT_CLASS=true

# Impostazioni predefinite per il tema LIGHT
THEME_NAME="Stile Chiaro"
ACTOR_TEXT_COLOR="black"
BLOCK_TEXT_COLOR="black"
INTRUDER_TEXT_COLOR="black"
PROCESS_TEXT_COLOR="black"

# Theme-specific colors for light mode (default)
COLOR_DEF_DARKBG="\\definecolor{darkbg}{rgb}{0.95,0.95,0.95}"  # Light gray in light mode
COLOR_DEF_HIGHLIGHT="\\definecolor{highlight}{RGB}{255,200,0}" # Yellow highlight color
COLOR_DEF_TIKZ_COLOR="\\definecolor{tikz@color}{RGB}{0,0,0}"   # Black in light mode

# datagram text=black (comune)
# key text=black (implicito, font=\tiny) (comune)
# cloud, host, servernode text=lighttext (colore definito diversamente)

# Colore del blu che cambia in base al tema
THEME_BLUE_RGB="0,51,153" # Blu scuro per tema chiaro

NODO_BASE_DRAW="black"
NODO_BASE_FILL="gray!20"
NODO_BASE_TEXT="black"
NODO_TESTO_TEXT="black"
LINEA_DRAW="black"
BLOCCO_TEMPO_DRAW="black"
BLOCCO_TEMPO_FILL="blue!30"
BLOCCO_TEMPO_VERDE_FILL="green!30"
BLOCCO_TEMPO_ROSSO_FILL="red!30"
BLOCCO_TEMPO_TEXT="black"
BLOCCO_TEMPO_HATCH_PATTERN_COLOR="gray!50"
NODE_STYLE_TEXT="black"
# important_node_style text=black (comune)
# info_box text=maintext (colore definito diversamente)

# Nuovo colore di sfondo personalizzato
BG_CUSTOM_FILL="gray!20"
BG_CUSTOM_TEXT="black"
BG_CUSTOM_RGB="0.9,0.9,0.9" # RGB equivalente a gray!20 (per \rowcolor)
BG_CUSTOM_2_FILL="gray!15"
BG_CUSTOM_2_TEXT="black"
BG_CUSTOM_2_RGB="0.925,0.925,0.925" # RGB equivalente a gray!15 (per \rowcolor)
PRIMARY_TEXT_RGB="0,0,0"            # Colore primario del testo (per light theme)

COLOR_DEF_LIGHTTEXT="\\definecolor{lighttext}{rgb}{0.98,0.98,0.98}"
COLOR_DEF_DARKTEXT="\\definecolor{darktext}{rgb}{0.1,0.1,0.1}" # Solo per light
COLOR_DEF_BGCOLOR="\\definecolor{bgcolor}{RGB}{250,250,250}"
COLOR_DEF_MAINTEXT="\\definecolor{maintext}{RGB}{30,30,30}"
COLOR_DEF_ACCENTCOLOR="\\definecolor{accentcolor}{RGB}{0,100,200}"
COLOR_DEF_NODECOLOR="\\definecolor{nodecolor}{RGB}{200,220,240}"
COLOR_DEF_LINKCOLOR="\\definecolor{linkcolor}{RGB}{80,80,80}"
COLOR_DEF_HIGHLIGHTCOLOR="\\definecolor{highlightcolor}{RGB}{255,180,0}"
COLOR_DEF_PRIMARYTEXT="\\definecolor{primarytext}{RGB}{${PRIMARY_TEXT_RGB}}"
HYPERSETUP_LINKCOLOR="darktext"
HYPERSETUP_URLCOLOR="darktext"

PAGECOLOR_CMD="\\pagecolor{white}"
COLOR_CMD="\\color{black}"

MINTED_STYLE="default"
MINTED_BGCOLOR="gray!10"

# Parsing degli argomenti in qualsiasi ordine
while [[ $# -gt 0 ]]; do
    case "$1" in
    --dark)
        THEME_NAME="Stile Scuro"
        ACTOR_TEXT_COLOR="white"
        BLOCK_TEXT_COLOR="white"
        INTRUDER_TEXT_COLOR="white"
        PROCESS_TEXT_COLOR="white"

        NODO_BASE_DRAW="white"
        NODO_BASE_FILL="gray!60!black"
        NODO_BASE_TEXT="white"
        NODO_TESTO_TEXT="white"
        LINEA_DRAW="white"
        BLOCCO_TEMPO_DRAW="white"
        BLOCCO_TEMPO_FILL="blue!70!black"
        BLOCCO_TEMPO_VERDE_FILL="green!70!black"
        BLOCCO_TEMPO_ROSSO_FILL="red!70!black"
        BLOCCO_TEMPO_TEXT="white"
        BLOCCO_TEMPO_HATCH_PATTERN_COLOR="gray"
        NODE_STYLE_TEXT="white"

        BG_CUSTOM_FILL="gray!80!black"
        BG_CUSTOM_TEXT="white"
        BG_CUSTOM_RGB="0.2,0.2,0.2"
        BG_CUSTOM_2_FILL="gray!85!black"
        BG_CUSTOM_2_TEXT="white"
        BG_CUSTOM_2_RGB="0.15,0.15,0.15"
        PRIMARY_TEXT_RGB="255,255,255"
        THEME_BLUE_RGB="102,178,255"

        COLOR_DEF_LIGHTTEXT="\\definecolor{lighttext}{rgb}{0.98,0.98,0.98}"
        COLOR_DEF_DARKTEXT="\\definecolor{darktext}{rgb}{0.9,0.9,0.9}"
        COLOR_DEF_BGCOLOR="\\definecolor{bgcolor}{RGB}{20,20,20}"
        COLOR_DEF_MAINTEXT="\\definecolor{maintext}{RGB}{230,230,230}"
        COLOR_DEF_ACCENTCOLOR="\\definecolor{accentcolor}{RGB}{70,170,255}"
        COLOR_DEF_NODECOLOR="\\definecolor{nodecolor}{RGB}{60,100,160}"
        COLOR_DEF_LINKCOLOR="\\definecolor{linkcolor}{RGB}{150,150,150}"
        COLOR_DEF_HIGHLIGHTCOLOR="\\definecolor{highlightcolor}{RGB}{255,220,100}"
        COLOR_DEF_PRIMARYTEXT="\\definecolor{primarytext}{RGB}{${PRIMARY_TEXT_RGB}}"
        HYPERSETUP_LINKCOLOR="white"
        HYPERSETUP_URLCOLOR="cyan"

        # Redefine theme-specific colors for dark mode
        COLOR_DEF_DARKBG="\\definecolor{darkbg}{rgb}{0.15,0.15,0.15}"      # Dark gray in dark mode
        COLOR_DEF_HIGHLIGHT="\\definecolor{highlight}{RGB}{255,220,100}"   # Brighter yellow in dark mode
        COLOR_DEF_TIKZ_COLOR="\\definecolor{tikz@color}{RGB}{255,255,255}" # White in dark mode

        PAGECOLOR_CMD="\\pagecolor{black}"
        COLOR_CMD="\\color{white}"

        MINTED_STYLE="monokai"
        MINTED_BGCOLOR="black!80"
        ;;
    --no-document-class)
        INCLUDE_DOCUMENT_CLASS=false
        ;;
    *)
        echo "Argomento non riconosciuto: $1"
        echo "Uso: $0 [--dark] [--no-document-class]"
        exit 1
        ;;
    esac
    shift
done

# Inizia a scrivere il file
# Il 'cat << \'EOF\'' con l'apostrofo evita l'espansione delle variabili bash $ all'interno dell'heredoc
# se non sono esplicitamente referenziate come $VARIABILE.
# Per le variabili LaTeX che usano $, dobbiamo fare l'escape: \$
# Tuttavia, qui stiamo generando codice LaTeX, quindi i \$ sono interpretati da LaTeX, non da bash.

cat >"$OUTPUT_FILE" <<EOF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREAMBOLO COMUNE PER APPUNTI (${THEME_NAME})
%
% Questo file contiene tutte le impostazioni e i pacchetti comuni.
% NON contiene \\begin{document} o \\end{document}.
%
% Istruzioni per la compilazione del file principale:
% pdflatex -shell-escape nomefile_principale.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EOF

# Aggiungi \documentclass solo se richiesto
if $INCLUDE_DOCUMENT_CLASS; then
    cat >>"$OUTPUT_FILE" <<EOF
\\documentclass{article}

EOF
fi

cat >>"$OUTPUT_FILE" <<EOF
% --- Encoding e lingua ---
\\usepackage[utf8]{inputenc}
\\usepackage[italian]{babel}

% --- Margini e layout ---
\\usepackage{geometry}
\\geometry{a4paper, margin=1in}

% --- Font sans-serif (come Helvetica) ---
\\usepackage[scaled]{helvet}
\\renewcommand{\\familydefault}{\\sfdefault}
\\usepackage[T1]{fontenc}

% --- Matematica ---
\\usepackage{amsmath}
\\usepackage{amssymb}

% --- Liste personalizzate ---
\\usepackage{enumitem}
% \\setlist{nosep}

% --- Immagini e Grafica ---
\\usepackage{float}
% \\usepackage{graphicx}
\\usepackage{tikz}
\\usetikzlibrary{matrix, shapes.geometric, shadows, shapes.symbols, positioning, arrows.meta, calc, fit, backgrounds, patterns, decorations.pathreplacing, shapes.misc}

% Ensure the key shape from shapes.symbols is loaded
\\tikzset{key/.append style={shape=key}}

% Pacchetto aggiuntivo per i grafici con ambiente axis
\\usepackage{pgfplots}
\\pgfplotsset{compat=1.18}

% Pacchetto xcolor (necessario per \definecolor e TikZ)
\\usepackage[table]{xcolor}

% Robe
\\newcommand{\\Pcond}[2]{P(#1 \mid #2)}
\\newcommand{\\Pc}{P}
\\newcommand{\\OmegaSet}{\\Omega}
\\newcommand{\\capSet}{\\cap}
\\newcommand{\\cupSet}{\\cup}
\\newcommand{\\compSet}[1]{{#1}^c}

% Multicolonna e multirow per tabelle
\\usepackage{multicol}
\\usepackage{multirow}

% Definizioni colori tema-specifiche
${COLOR_DEF_LIGHTTEXT}
${COLOR_DEF_DARKTEXT}
${COLOR_DEF_BGCOLOR}
${COLOR_DEF_MAINTEXT}
${COLOR_DEF_ACCENTCOLOR}
${COLOR_DEF_NODECOLOR}
${COLOR_DEF_LINKCOLOR}
${COLOR_DEF_HIGHLIGHTCOLOR}
${COLOR_DEF_PRIMARYTEXT}
\\definecolor{themeblue}{RGB}{${THEME_BLUE_RGB}}

% Additional theme-specific colors
${COLOR_DEF_DARKBG}
${COLOR_DEF_HIGHLIGHT}
${COLOR_DEF_TIKZ_COLOR}

% Definizione del colore di sfondo personalizzato per tabelle
\\definecolor{bg_custom}{rgb}{${BG_CUSTOM_RGB}} % Colore personalizzato per tabelle
\\definecolor{bg_custom_2}{rgb}{${BG_CUSTOM_2_RGB}} % Colore personalizzato per tabelle (variante)

% --- Tabelle Avanzate ---
\\usepackage{array}
\\usepackage{booktabs}
\\usepackage{longtable}

\\usepackage{siunitx} % Per unità di misura come GHz, dBm, ecc.

% --- Hyperlink e Metadati PDF ---
\\usepackage{hyperref}

\\usepackage{graphicx} % Caricato anche qui in entrambi i preamboli

\\hypersetup{
    colorlinks=true,
    linkcolor=${HYPERSETUP_LINKCOLOR},
    filecolor=magenta,
    urlcolor=${HYPERSETUP_URLCOLOR},
    citecolor=green,
    % pdftitle, pdfauthor, ecc. verranno impostati nel file principale
    pdfpagemode=FullScreen,
    bookmarksopen=true,
    bookmarksnumbered=true
}

% --- Licenza del documento ---
\\usepackage[
  type={CC},
  modifier={by-sa},
  version={4.0},
]{doclicense}

% --- Colori e Sfondo ---
${PAGECOLOR_CMD}
${COLOR_CMD}

% --- Evidenziazione del Codice ---
\\usepackage{minted}
\\setminted{
    frame=lines,
    framesep=2mm,
    fontsize=\\small,
    breaklines=true,
    style=${MINTED_STYLE},
    bgcolor=${MINTED_BGCOLOR}
}
\\usemintedstyle{${MINTED_STYLE}}

% --- Inclusione PDF ---
\\usepackage{pdfpages}

\\newcommand{\\R}{\\mathbb{R}}
% \\newcommand{\\N}{\\mathbb{N}}
\\newcommand{\\Z}{\\mathbb{Z}}
\\newcommand{\\E}{\\mathbb{E}}
\\newcommand{\\Prob}{\\mathbb{P}}
\\newcommand{\\Var}{\\mathrm{Var}}
\\newcommand{\\Cov}{\\mathrm{Cov}}
\\newcommand{\\dd}{\\mathrm{d}} % per il differenziale negli integrali

\\newtheorem{theorem}{Teorema}[section]
\\newtheorem{lemma}[theorem]{Lemma}
\\newtheorem{proposition}[theorem]{Proposizione}
\\newtheorem{corollary}[theorem]{Corollario}
\\newtheorem{definition}[theorem]{Definizione}
\\newtheorem{example}[theorem]{Esempio}
\\newtheorem{remark}[theorem]{Osservazione}
\\newtheorem{exercise}[theorem]{Esercizio}

\\newenvironment{proof}[1][Dimostrazione]
    {\\begin{trivlist}\\item[\\hskip \\labelsep {\\bfseries #1}]}
    {\\end{trivlist}}  % Ambiente per le dimostrazioni
EOF

echo "File '$OUTPUT_FILE' generato con ${THEME_NAME}."
if ! $INCLUDE_DOCUMENT_CLASS; then
    echo "Nota: \\documentclass{article} non incluso nel preambolo."
fi
