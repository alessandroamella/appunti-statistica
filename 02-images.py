import argparse
import os

from graphviz import Digraph

# --- Color Palettes ---
# Dark Mode Colors (as originally provided)
dark_colors = {
    "bgcolor_page": "#000000",  # Black
    "node_fill_color": "#3C64A0",  # nodecolor (60,100,160) ma più chiaro come nodecolor!60
    "node_border_color": "#46AAFF",  # accentcolor (70,170,255)
    "text_color": "#FFFFFF",  # maintext (230,230,230)
    "edge_color": "#969696",  # linkcolor (150,150,150)
}

# Light Mode Colors (newly defined)
light_colors = {
    "bgcolor_page": "#ffffff",  # White
    "node_fill_color": "#E8F0FE",  # Light, soft blue (e.g., Google Material light blue)
    "node_border_color": "#1967D2",  # Stronger blue for border (e.g., Google blue)
    "text_color": "#202124",  # Dark gray, nearly black for text
    "edge_color": "#5F6368",  # Medium gray for edges
}


def generate_albero_moneta_lancio(colors, output_dir, dpi):
    """Generates the 'Albero Scelta Moneta e Lancio' graph."""
    dot = Digraph(comment="Albero Scelta Moneta e Lancio")
    dot.attr(rankdir="LR", bgcolor=colors["bgcolor_page"], dpi=str(dpi))

    # Attributi globali per i nodi
    dot.node_attr.update(
        style="filled",
        shape="box",
        rounded="true",  # Graphviz uses 'rounded' for rounded corners on box shape
        color=colors["node_border_color"],
        fillcolor=colors["node_fill_color"],
        fontcolor=colors["text_color"],
        fontname="Helvetica",
        fontsize="10",
    )

    # Attributi globali per gli archi
    dot.edge_attr.update(
        color=colors["edge_color"],
        fontcolor=colors["text_color"],
        fontname="Helvetica",
        fontsize="9",
    )

    # Nodi del primo livello (Scelta Moneta)
    dot.node("S", "Inizio")
    dot.node("A", "Moneta A")
    dot.node("B", "Moneta B")

    # Archi dal nodo Inizio
    dot.edge("S", "A", label="P(A)=1/2")
    dot.edge("S", "B", label="P(B)=1/2")

    # Nodi del secondo livello (Risultato Lancio) e probabilità congiunte
    dot.node("TA", "Testa (T)\nP(A ∩ T) = 1/2 * 1/2 = 1/4")
    dot.node("CA", "Croce (C)\nP(A ∩ C) = 1/2 * 1/2 = 1/4")
    dot.node("TB", "Testa (T)\nP(B ∩ T) = 1/2 * 2/3 = 1/3")
    dot.node("CB", "Croce (C)\nP(B ∩ C) = 1/2 * 1/3 = 1/6")

    # Archi dal nodo Moneta A
    dot.edge("A", "TA", label="P(T|A)=1/2")
    dot.edge("A", "CA", label="P(C|A)=1/2")

    # Archi dal nodo Moneta B
    dot.edge("B", "TB", label="P(T|B)=2/3")
    dot.edge("B", "CB", label="P(C|B)=1/3")

    output_path = os.path.join(output_dir, "albero_moneta_lancio")
    try:
        dot.render(output_path, format="png", cleanup=True)
        print(f"File '{output_path}.png' generato con successo.")
    except Exception as e:
        print(f"Errore durante la generazione dell'immagine '{output_path}.png': {e}")
        print("Assicurati che Graphviz sia installato e nel PATH di sistema.")


def generate_albero_polya(colors, output_dir, dpi):
    """Generates the 'Albero Urna di Polya' graph."""
    dot = Digraph(comment="Albero Urna di Polya")
    dot.attr(rankdir="LR", bgcolor=colors["bgcolor_page"], dpi=str(dpi))

    # Attributi globali per i nodi
    dot.node_attr.update(
        style="filled",
        shape="box",
        rounded="true",
        color=colors["node_border_color"],
        fillcolor=colors["node_fill_color"],
        fontcolor=colors["text_color"],
        fontname="Helvetica",
        fontsize="10",
    )

    # Attributi globali per gli archi
    dot.edge_attr.update(
        color=colors["edge_color"],
        fontcolor=colors["text_color"],
        fontname="Helvetica",
        fontsize="9",
    )

    # Nodo Radice
    dot.node("Start", "Urna Iniziale\n(4R, 2N, Tot=6)")

    # Primo Livello di Estrazione
    dot.node("R1", "Estratta R1\nUrna: (5R, 2N, Tot=7)")
    dot.node("N1", "Estratta N1\nUrna: (4R, 3N, Tot=7)")

    dot.edge("Start", "R1", label="P(R1)=4/6")
    dot.edge("Start", "N1", label="P(N1)=2/6")

    # Secondo Livello di Estrazione e probabilità congiunte
    dot.node("R1R2", "Estratta R2\nP(R1 ∩ R2) = 4/6 * 5/7 = 20/42")
    dot.node("R1N2", "Estratta N2\nP(R1 ∩ N2) = 4/6 * 2/7 = 8/42")
    dot.node("N1R2", "Estratta R2\nP(N1 ∩ R2) = 2/6 * 4/7 = 8/42")
    dot.node("N1N2", "Estratta N2\nP(N1 ∩ N2) = 2/6 * 3/7 = 6/42")

    dot.edge("R1", "R1R2", label="P(R2|R1)=5/7")
    dot.edge("R1", "R1N2", label="P(N2|R1)=2/7")
    dot.edge("N1", "N1R2", label="P(R2|N1)=4/7")
    dot.edge("N1", "N1N2", label="P(N2|N1)=3/7")

    output_path = os.path.join(output_dir, "albero_polya")
    try:
        dot.render(output_path, format="png", cleanup=True)
        print(f"File '{output_path}.png' generato con successo.")
    except Exception as e:
        print(f"Errore durante la generazione dell'immagine '{output_path}.png': {e}")
        print("Assicurati che Graphviz sia installato e nel PATH di sistema.")


def main():
    parser = argparse.ArgumentParser(
        description="Generate graph images with selectable color themes and resolution."
    )
    parser.add_argument(
        "--dark",
        action="store_true",
        help="Use dark mode colors for the images. If not specified, light mode is used.",
    )
    parser.add_argument(
        "--dpi",
        type=int,
        default=300,  # Default DPI for higher resolution
        help="Resolution (DPI) for the output PNG images. Default: 300.",
    )
    args = parser.parse_args()

    if args.dark:
        selected_colors = dark_colors
        print("Using dark mode colors.")
    else:
        selected_colors = light_colors
        print("Using light mode colors (default).")

    output_directory = "images"
    # Create the output directory if it doesn't exist
    os.makedirs(output_directory, exist_ok=True)
    if not os.path.isdir(
        output_directory
    ):  # Should not happen with exist_ok=True unless permissions issue
        print(f"Error: Could not create directory {output_directory}")
        return

    print(f"Output images will be saved with {args.dpi} DPI.")

    generate_albero_moneta_lancio(selected_colors, output_directory, args.dpi)
    generate_albero_polya(selected_colors, output_directory, args.dpi)


if __name__ == "__main__":
    main()
