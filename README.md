# Appunti di Calcolo delle Probabilità e Statistica

> 📥 **Scarica gli ultimi appunti**: [Ultima Release](https://github.com/alessandroamella/appunti-statistica/releases/latest)

Appunti per il corso di Calcolo delle Probabilità e Statistica, Laurea in Informatica, Unibo, 2025.

## Informazioni sul Corso

- [Pagina del corso](https://www.unibo.it/it/studiare/insegnamenti-competenze-trasversali-moocs/insegnamenti/insegnamento/2024/455457)
- [Materiale del professore (slide, appunti, esami)](https://virtuale.unibo.it/course/view.php?id=64497)

## Setup e Release

Per generare una release degli appunti:

1. Installa le dipendenze:

```bash
pnpm install
```

2. Crea un file `.env` con le variabili d'ambiente come definite nel file `.env.example`.

3. Esegui lo script per renderizzare i file LaTeX in PDF:

```bash
./generate_notes.sh
```

Questo script utilizza `pdflatex`s per convertire i file LaTeX in PDF ed esegue automaticamente gli script di indentazione e generazione delle immagini. Va eseguito prima di pubblicare una release.

4. Comandi disponibili:

```bash
pnpm release              # Crea una release standard
pnpm release -m "msg"     # Crea una release con messaggio personalizzato
```

## Script Utili

### Fix Indentazione Minted

Lo script `fix_minted_indent.sh` corregge l'indentazione dei blocchi di codice minted in LaTeX:

```bash
./fix_minted_indent.sh input.tex > output.tex
```

## Licenza

[CC-BY-SA-4.0](LICENSE).

## By

Alessandro Amella

- [GitHub](https://github.com/alessandroamella)
