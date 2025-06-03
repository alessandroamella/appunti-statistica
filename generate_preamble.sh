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

# Definizione degli stili TikZ per tema chiaro e scuro
LIGHT_TIKZSET="\\tikzset{
    % White-named styles (keep white colors as specified)
    block_white/.style={rectangle, draw=primarytext, fill=gray!30!black, text=white,
        text width=6em, text centered, rounded corners, minimum height=3em, line width=1pt},
    block_wide_white/.style={rectangle, draw=primarytext, fill=gray!20!white, text=white,
        text width=10em, text centered, rounded corners, minimum height=3em, line width=1pt},
    cloud_white/.style={ellipse, draw=primarytext, fill=blue!70!black, text=white,
        minimum height=2em, minimum width=3em, line width=1pt},
    sensor_white/.style={circle, draw=primarytext, fill=green!60!black, text=white,
        minimum size=1.5em, line width=1pt},
    line_white/.style={draw=primarytext, -{Stealth[length=2mm, width=1.5mm]}, line width=1pt},
    line_double_white/.style={draw=primarytext, {Stealth[length=2mm, width=1.5mm]}-{Stealth[length=2mm, width=1.5mm]}, line width=1pt},
    label_white/.style={text=primarytext, font=\footnotesize},
    % Generic styles for light theme
    block/.style={rectangle, draw=blue!70!black, fill=blue!10!white, text=black,
        text width=8em, text centered, rounded corners, minimum height=3em, line width=0.5pt},
    block_dark/.style={rectangle, draw=blue!70!black, fill=gray!10!white, text=black,
        minimum height=2.5em, minimum width=6em, text centered, rounded corners=3pt,
        drop shadow={opacity=0.2, shadow xshift=0.05cm, shadow yshift=-0.05cm, fill=gray}},
    diamond_block/.style={diamond, draw=blue!70!black, fill=blue!10!white, text=black,
        text width=6em, text centered, minimum height=2.5em, aspect=2, line width=0.5pt, inner sep=0pt},
    key_block/.style={rectangle, draw=orange!70!black, fill=orange!10!white, text=black,
        text width=4em, text centered, rounded corners, minimum height=2em, line width=0.5pt},
    keyblock/.style={rectangle, draw=orange!70!black, fill=orange!10!white, text=black,
        text width=5em, text centered, minimum height=2em},
    ioblock/.style={rectangle, draw=green!70!black, fill=green!10!white, text=black,
        text width=6em, text centered, minimum height=3em},
    startend/.style={rectangle, rounded corners, minimum width=3cm, minimum height=1cm,
        text centered, draw=blue!70!black, fill=blue!10!white, text=black, line width=0.5pt},
    % Operators and special shapes
    op_dark/.style={circle, draw=blue!70!black, fill=blue!20!white, text=black,
        minimum size=1.5em, drop shadow={opacity=0.2, shadow xshift=0.05cm, shadow yshift=-0.05cm, fill=gray}},
    sum/.style={circle, draw=orange!70!black, fill=yellow!20!white, text=black, minimum size=1.5em, inner sep=0pt},
    operator/.style={circle, draw=blue!20!white, text=black, minimum size=1.5em, font=\Large},
    % Actors and entities
    actor/.style={circle, draw=black, fill=gray!20!white, minimum size=2em, text=black},
    user/.style={rectangle, rounded corners, minimum width=2.5cm, minimum height=1cm,
        text centered, draw=black, fill=gray!20!white, text=black, font=\sffamily},
    userNodeStyle/.style={ellipse, draw=black, fill=blue!30!white, text=black,
        minimum height=2.5em, text centered},
    entity/.style={rectangle, rounded corners, minimum width=2.5cm, minimum height=1cm,
        text centered, draw=blue!70!black, fill=blue!20!white, text=black, font=\sffamily},
    challenger/.style={rectangle, draw=green!70!black, fill=green!20!white, rounded corners,
        minimum width=3cm, minimum height=2cm, text centered, text=black},
    adversary/.style={rectangle, draw=red!70!black, fill=red!20!white, rounded corners,
        minimum width=3cm, minimum height=2cm, text centered, text=black},
    attacker/.style={ellipse, minimum width=2cm, minimum height=1cm, text centered,
        draw=red!70!black, fill=red!20!white, text=black, font=\sffamily},
    attacker_dark/.style={cloud, draw=red!70!black, fill=red!20!white, cloud puffs=10,
        minimum width=2.5cm, text=black, font=\sffamily\small, drop shadow},
    authority/.style={cylinder, shape border rotate=90, aspect=0.5, minimum height=1.5cm,
        text width=2cm, text centered, draw=black, fill=green!20!white, text=black, font=\sffamily},
    % Nodes and generic elements
    genericNodeStyle/.style={rectangle, rounded corners, draw=black, fill=gray!20!white,
        text=black, minimum height=2em, minimum width=3em, text centered},
    roleNodeStyle/.style={rectangle, draw=black, fill=green!30!white, text=black,
        minimum height=2em, minimum width=5em, text centered},
    resourceNodeStyle/.style={cylinder, shape border rotate=90, aspect=0.3, draw=black,
        fill=red!30!white, text=black, minimum height=2.5em, text centered, alias=cyl},
    mynode/.style={rectangle, rounded corners, draw=black, fill=gray!20!white, text=black,
        minimum height=0.8cm, minimum width=1.8cm, text centered, thick},
    goodnode/.style={mynode, fill=green!20!white},
    neutralnode/.style={mynode, fill=blue!20!white},
    node_dark/.style={circle, draw=black, fill=gray!20!white, text=black, minimum size=7mm},
    concept/.style={ellipse, draw=orange!70!black, fill=orange!10!white, text=black, minimum width=2.5cm, text centered},
    % Data and information
    data/.style={rectangle, draw=black, fill=gray!20!white, text=black,
        font=\sffamily\footnotesize, inner sep=2pt},
    data_dark/.style={rectangle, draw=black, fill=gray!30!white, text=black,
        font=\sf\footnotesize, minimum height=1.2em, inner sep=2pt},
    key/.style={rectangle, draw=black, fill=gray!20!white, text=black,
        text width=3em, text centered, minimum height=2em, font=\footnotesize},
    infonode/.style={rectangle, draw=black, fill=white, text=black, font=\footnotesize, inner sep=2pt},
    itembox/.style={rectangle, draw=gray, fill=gray!10!white, text=black, font=\footnotesize, align=left, inner sep=2mm},
    % Memory blocks
    memblock/.style={rectangle, draw=black, fill=blue!20!white, text=black,
        minimum height=2em, minimum width=6em, text centered},
    memblock_red/.style={memblock, fill=red!40!white},
    memblock_orange/.style={memblock, fill=orange!60!white},
    memblock_green/.style={memblock, fill=green!40!white, text=black},
    % Device styles
    device_dark/.style={rectangle, draw=blue!70!black, fill=gray!10!white, minimum width=3cm,
        minimum height=1.8cm, text=black, font=\sffamily\small, rounded corners=3pt, drop shadow},
    % Lines and arrows
    line/.style={draw=black, -{Stealth[length=2mm, width=1.5mm]}, line width=0.5pt},
    line_dark/.style={draw=black, thick},
    arrow/.style={draw=green!70!black, -{Latex[length=2mm, width=1.5mm]}, thick},
    arrow_dark/.style={-{Stealth[length=3mm, width=2mm]}, draw=black, thick},
    arrowStyle/.style={->, >=latex, draw=black, thick},
    myarrow/.style={-Latex, thick, black},
    dashedarrow/.style={myarrow, dashed},
    dataline/.style={draw=blue!70!black, thick, -{Stealth}},
    keyline/.style={draw=orange!70!black, thick, dashed, -{Stealth}},
    data_flow/.style={->, >=Stealth, thick, color=black},
    message_flow/.style={draw=black, -{Stealth[length=3mm, width=2mm]}},
    comm_arrow/.style={draw=blue!70!black, -{Latex[length=2mm, width=1.5mm]}, thick},
    key_arrow_dark/.style={-{Stealth[length=3mm, width=2mm]}, thick, black, dashed},
    key_exchange_line/.style={draw=blue!70!black, <->, dashed, thick},
    stack_arrow/.style={-{Stealth[length=3mm, width=2mm]}, black, thick},
    fdlink/.style={->, draw=orange!70!black, thick},
    link/.style={->, draw=gray, thin},
    comm_channel/.style={dashed, color=gray},
    % Labels
    label_dark/.style={text=black, font=\footnotesize, align=center},
    labelStyle/.style={text=black, font=\footnotesize},
    mem_label/.style={text=black, font=\footnotesize},
    % File system diagram styles
    level 1/.style={sibling distance=30mm, level distance=12mm},
    level 2/.style={sibling distance=18mm, level distance=12mm},
    level 3/.style={sibling distance=12mm, level distance=12mm},
    level 4/.style={sibling distance=10mm, level distance=12mm},
    dir/.style={rectangle, draw=blue!70!black, fill=blue!30!white, text=black, minimum size=7mm, font=\tiny, inner sep=1pt},
    file/.style={rectangle, draw=green!70!black, fill=green!20!white, text=black, minimum size=7mm, font=\tiny, inner sep=1pt},
    proc/.style={rectangle, draw=blue!70!black, fill=blue!10!white, text=black, minimum height=2.5cm,
        minimum width=1.8cm, align=center, font=\scriptsize},
    fdt/.style={rectangle, draw=blue!10!white, text=black, minimum height=3.5cm,
        minimum width=2.3cm, align=center, font=\scriptsize},
    fdentry/.style={rectangle, draw=black, fill=gray!20!white, text=black, minimum height=0.45cm,
        minimum width=2.1cm, anchor=north west, font=\tiny},
    obj/.style={ellipse, draw=green!70!black, fill=green!10!white, text=black, minimum width=1.8cm,
        minimum height=0.9cm, align=center, font=\tiny},
    hw/.style={rectangle, draw=orange!70!black, fill=orange!10!white, text=black, minimum width=2.2cm,
        minimum height=0.9cm, font=\tiny, align=center},
    % Additional styles from the other document (adapted for light theme)
    block_alt/.style={rectangle, draw=blue!70!black, fill=gray!10!white, thick,
        text width=8em, text centered, rounded corners, minimum height=3em, font=\sffamily\small, text=black, 
        drop shadow={opacity=0.2, shadow xshift=2pt, shadow yshift=-2pt, fill=gray}},
    data_alt/.style={rectangle, draw=orange!70!black, fill=yellow!10!white, thick,
        text width=5em, text centered, minimum height=2.5em, font=\sffamily\scriptsize, text=black},
    key_shape/.style={trapezium, trapezium left angle=70, trapezium right angle=110, 
        draw=orange!70!black, fill=orange!20!white, thick,
        minimum width=2.5em, minimum height=1.5em, font=\sffamily\tiny, text=black, inner sep=2pt, drop shadow},
    process/.style={ellipse, draw=green!60!black, fill=green!10!white, thick,
        minimum height=2.5em, text centered, font=\sffamily\small, text=black},
    arrow_alt/.style={-{Stealth[length=3mm, width=2mm]}, thick, draw=black},
    dashed_arrow/.style={-{Stealth[length=3mm, width=2mm]}, thick, draw=black, dashed},
    cloud_alt/.style={cloud, draw=blue!60!black, fill=blue!10!white, cloud puffs=15, 
        cloud puff arc=120, aspect=2, minimum height=3em, text=black, 
        font=\sffamily\small, text centered},
    repo/.style={cylinder, shape border rotate=90, aspect=0.5, draw=gray!70!black, 
        fill=gray!10!white, minimum height=3cm, minimum width=2cm, text width=1.5cm, 
        text centered, font=\sffamily\scriptsize, text=black},
    document/.style={rectangle, draw=blue!70!black, fill=gray!5!white, 
        minimum width=2.5cm, minimum height=3cm, font=\sffamily\scriptsize, text=black,
        path picture={
            \draw[blue!70!black] ([yshift=-0.4cm]path picture bounding box.north west) -- 
                ([yshift=-0.4cm]path picture bounding box.north east);
            \foreach \i in {1,...,5} {
                \draw[blue!70!black!70] ([yshift=-\i*0.2cm-0.6cm]path picture bounding box.north west) -- 
                    ([yshift=-\i*0.2cm-0.6cm]path picture bounding box.north east);
            }
        }},
    person/.style={circle, draw=orange!70!black, fill=yellow!10!white, 
        minimum size=1.5cm, font=\sffamily\small, text=black}
}"

DARK_TIKZSET="\\tikzset{
    % White-named styles (keep white colors)
    block_white/.style={rectangle, draw=white, fill=gray!30!black, text=white,
        text width=6em, text centered, rounded corners, minimum height=3em, line width=1pt},
    block_wide_white/.style={rectangle, draw=white, fill=gray!30!black, text=white,
        text width=10em, text centered, rounded corners, minimum height=3em, line width=1pt},
    cloud_white/.style={ellipse, draw=white, fill=blue!70!black, text=white,
        minimum height=2em, minimum width=3em, line width=1pt},
    sensor_white/.style={circle, draw=white, fill=green!60!black, text=white,
        minimum size=1.5em, line width=1pt},
    line_white/.style={draw=white, -{Stealth[length=2mm, width=1.5mm]}, line width=1pt},
    line_double_white/.style={draw=white, {Stealth[length=2mm, width=1.5mm]}-{Stealth[length=2mm, width=1.5mm]}, line width=1pt},
    label_white/.style={text=white, font=\footnotesize},
    % Generic styles for dark theme
    block/.style={rectangle, draw=cyan, fill=blue!20!black, text=white,
        text width=8em, text centered, rounded corners, minimum height=3em, line width=0.5pt},
    block_dark/.style={rectangle, draw=cyan!80!white, fill=gray!20!black, text=white,
        minimum height=2.5em, minimum width=6em, text centered, rounded corners=3pt,
        drop shadow={opacity=0.4, shadow xshift=0.05cm, shadow yshift=-0.05cm, fill=black}},
    diamond_block/.style={diamond, draw=cyan, fill=blue!20!black, text=white,
        text width=6em, text centered, minimum height=2.5em, aspect=2, line width=0.5pt, inner sep=0pt},
    key_block/.style={rectangle, draw=orange, fill=orange!20!black, text=white,
        text width=4em, text centered, rounded corners, minimum height=2em, line width=0.5pt},
    keyblock/.style={rectangle, draw=orange, fill=orange!20!black, text=white,
        text width=5em, text centered, minimum height=2em},
    ioblock/.style={rectangle, draw=green, fill=green!20!black, text=white,
        text width=6em, text centered, minimum height=3em},
    startend/.style={rectangle, rounded corners, minimum width=3cm, minimum height=1cm,
        text centered, draw=cyan, fill=blue!20!black, text=white, line width=0.5pt},
    % Operators and special shapes
    op_dark/.style={circle, draw=cyan!80!white, fill=blue!60!black, text=white,
        minimum size=1.5em, drop shadow={opacity=0.4, shadow xshift=0.05cm, shadow yshift=-0.05cm, fill=black}},
    sum/.style={circle, draw=yellow, fill=yellow!30!black, text=white, minimum size=1.5em, inner sep=0pt},
    operator/.style={circle, draw=cyan, fill=blue!50!black, text=white, minimum size=1.5em, font=\Large},
    % Actors and entities
    actor/.style={circle, draw=white, fill=gray!30!black, minimum size=2em, text=white},
    user/.style={rectangle, rounded corners, minimum width=2.5cm, minimum height=1cm,
        text centered, draw=white, fill=gray!30!black, text=white, font=\sffamily},
    userNodeStyle/.style={ellipse, draw=white, fill=blue!50!black, text=white,
        minimum height=2.5em, text centered},
    entity/.style={rectangle, rounded corners, minimum width=2.5cm, minimum height=1cm,
        text centered, draw=cyan, fill=blue!60!black, text=white, font=\sffamily},
    challenger/.style={rectangle, draw=green!70!white, fill=green!30!black, rounded corners,
        minimum width=3cm, minimum height=2cm, text centered, text=white},
    adversary/.style={rectangle, draw=red!70!white, fill=red!30!black, rounded corners,
        minimum width=3cm, minimum height=2cm, text centered, text=white},
    attacker/.style={ellipse, minimum width=2cm, minimum height=1cm, text centered,
        draw=red!80!white, fill=red!40!black, text=white, font=\sffamily},
    attacker_dark/.style={cloud, draw=red!70!white, fill=red!40!black, cloud puffs=10,
        minimum width=2.5cm, text=white, font=\sffamily\small, drop shadow},
    authority/.style={cylinder, shape border rotate=90, aspect=0.5, minimum height=1.5cm,
        text width=2cm, text centered, draw=white, fill=green!40!black, text=white, font=\sffamily},
    % Nodes and generic elements
    genericNodeStyle/.style={rectangle, rounded corners, draw=white, fill=gray!20!black,
        text=white, minimum height=2em, minimum width=3em, text centered},
    roleNodeStyle/.style={rectangle, draw=white, fill=green!50!black, text=white,
        minimum height=2em, minimum width=5em, text centered},
    resourceNodeStyle/.style={cylinder, shape border rotate=90, aspect=0.3, draw=white,
        fill=red!50!black, text=white, minimum height=2.5em, text centered, alias=cyl},
    mynode/.style={rectangle, rounded corners, draw=white, fill=gray!20!black, text=white,
        minimum height=0.8cm, minimum width=1.8cm, text centered, thick},
    goodnode/.style={mynode, fill=green!40!black},
    neutralnode/.style={mynode, fill=blue!40!black},
    node_dark/.style={circle, draw=white, fill=gray!40!black, text=white, minimum size=7mm},
    concept/.style={ellipse, draw=orange, fill=black!70, text=white, minimum width=2.5cm, text centered},
    % Data and information
    data/.style={rectangle, draw=white, fill=gray!50!black, text=white,
        font=\sffamily\footnotesize, inner sep=2pt},
    data_dark/.style={rectangle, draw=white, fill=gray!60!black, text=white,
        font=\sf\footnotesize, minimum height=1.2em, inner sep=2pt},
    key/.style={rectangle, draw=white, fill=gray!50!black, text=white,
        text width=3em, text centered, minimum height=2em, font=\footnotesize},
    infonode/.style={rectangle, draw=white, fill=black, text=white, font=\footnotesize, inner sep=2pt},
    itembox/.style={rectangle, draw=gray, fill=black!60, text=white, font=\footnotesize, align=left, inner sep=2mm},
    % Memory blocks
    memblock/.style={rectangle, draw=white, fill=blue!20!black, text=white,
        minimum height=2em, minimum width=6em, text centered},
    memblock_red/.style={memblock, fill=red!40!black},
    memblock_orange/.style={memblock, fill=orange!60!black},
    memblock_green/.style={memblock, fill=green!40!black, text=white},
    % Device styles
    device_dark/.style={rectangle, draw=cyan!80!white, fill=gray!20!black, minimum width=3cm,
        minimum height=1.8cm, text=white, font=\sffamily\small, rounded corners=3pt, drop shadow},
    % Lines and arrows
    line/.style={draw=white, -{Stealth[length=2mm, width=1.5mm]}, line width=0.5pt},
    line_dark/.style={draw=white, thick},
    arrow/.style={draw=green, -{Latex[length=2mm, width=1.5mm]}, thick},
    arrow_dark/.style={-{Stealth[length=3mm, width=2mm]}, draw=white, thick},
    arrowStyle/.style={->, >=latex, draw=white, thick},
    myarrow/.style={-Latex, thick, white},
    dashedarrow/.style={myarrow, dashed},
    dataline/.style={draw=cyan, thick, -{Stealth}},
    keyline/.style={draw=orange, thick, dashed, -{Stealth}},
    data_flow/.style={->, >=Stealth, thick, color=white},
    message_flow/.style={draw=white, -{Stealth[length=3mm, width=2mm]}},
    comm_arrow/.style={draw=cyan!80!white, -{Latex[length=2mm, width=1.5mm]}, thick},
    key_arrow_dark/.style={-{Stealth[length=3mm, width=2mm]}, thick, white, dashed},
    key_exchange_line/.style={draw=cyan!80!white, <->, dashed, thick},
    stack_arrow/.style={-{Stealth[length=3mm, width=2mm]}, white, thick},
    fdlink/.style={->, draw=yellow, thick},
    link/.style={->, draw=gray, thin},
    comm_channel/.style={dashed, color=gray},
    % Labels
    label_dark/.style={text=white, font=\footnotesize, align=center},
    labelStyle/.style={text=white, font=\footnotesize},
    mem_label/.style={text=white, font=\footnotesize},
    % File system diagram styles
    level 1/.style={sibling distance=30mm, level distance=12mm},
    level 2/.style={sibling distance=18mm, level distance=12mm},
    level 3/.style={sibling distance=12mm, level distance=12mm},
    level 4/.style={sibling distance=10mm, level distance=12mm},
    dir/.style={rectangle, draw=cyan, fill=blue!50!black, text=white, minimum size=7mm, font=\tiny, inner sep=1pt},
    file/.style={rectangle, draw=green, fill=green!40!black, text=white, minimum size=7mm, font=\tiny, inner sep=1pt},
    proc/.style={rectangle, draw=cyan, fill=black!70, text=white, minimum height=2.5cm,
        minimum width=1.8cm, align=center, font=\scriptsize},
    fdt/.style={rectangle, draw=cyan, fill=black!70, text=white, minimum height=3.5cm,
        minimum width=2.3cm, align=center, font=\scriptsize},
    fdentry/.style={rectangle, draw=white, fill=gray!50!black, text=white, minimum height=0.45cm,
        minimum width=2.1cm, anchor=north west, font=\tiny},
    obj/.style={ellipse, draw=green, fill=black!70, text=white, minimum width=1.8cm,
        minimum height=0.9cm, align=center, font=\tiny},
    hw/.style={rectangle, draw=orange, fill=black!70, text=white, minimum width=2.2cm,
        minimum height=0.9cm, font=\tiny, align=center},
    % Additional styles from the other document (adapted for dark theme)
    block_alt/.style={rectangle, draw=cyan!80!white, fill=gray!20!black, thick,
        text width=8em, text centered, rounded corners, minimum height=3em, font=\sffamily\small, text=white, 
        drop shadow={opacity=0.7, shadow xshift=2pt, shadow yshift=-2pt, fill=black}},
    data_alt/.style={rectangle, draw=yellow, fill=yellow!20!black, thick,
        text width=5em, text centered, minimum height=2.5em, font=\sffamily\scriptsize, text=white},
    key_shape/.style={trapezium, trapezium left angle=70, trapezium right angle=110, 
        draw=orange!80!yellow, fill=orange!50!black, thick,
        minimum width=2.5em, minimum height=1.5em, font=\sffamily\tiny, text=black, inner sep=2pt, drop shadow},
    process/.style={ellipse, draw=green!60!white, fill=green!20!black, thick,
        minimum height=2.5em, text centered, font=\sffamily\small, text=white},
    arrow_alt/.style={-{Stealth[length=3mm, width=2mm]}, thick, draw=white},
    dashed_arrow/.style={-{Stealth[length=3mm, width=2mm]}, thick, draw=white, dashed},
    cloud_alt/.style={cloud, draw=blue!60!white, fill=blue!20!black, cloud puffs=15, 
        cloud puff arc=120, aspect=2, minimum height=3em, text=white, 
        font=\sffamily\small, text centered},
    repo/.style={cylinder, shape border rotate=90, aspect=0.5, draw=gray!70!white, 
        fill=gray!30!black, minimum height=3cm, minimum width=2cm, text width=1.5cm, 
        text centered, font=\sffamily\scriptsize, text=white},
    document/.style={rectangle, draw=cyan!80!white, fill=white!10!black, 
        minimum width=2.5cm, minimum height=3cm, font=\sffamily\scriptsize, text=white,
        path picture={
            \draw[cyan!80!white] ([yshift=-0.4cm]path picture bounding box.north west) -- 
                ([yshift=-0.4cm]path picture bounding box.north east);
            \foreach \i in {1,...,5} {
                \draw[cyan!80!white!70] ([yshift=-\i*0.2cm-0.6cm]path picture bounding box.north west) -- 
                    ([yshift=-\i*0.2cm-0.6cm]path picture bounding box.north east);
            }
        }},
    person/.style={circle, draw=yellow, fill=yellow!30!black, 
        minimum size=1.5cm, font=\sffamily\small, text=white}
}"

CURRENT_TIKZSET="$LIGHT_TIKZSET"

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
        CURRENT_TIKZSET="$DARK_TIKZSET"
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

% Stili TikZ
${CURRENT_TIKZSET}

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
EOF

echo "File '$OUTPUT_FILE' generato con ${THEME_NAME}."
if ! $INCLUDE_DOCUMENT_CLASS; then
    echo "Nota: \\documentclass{article} non incluso nel preambolo."
fi
