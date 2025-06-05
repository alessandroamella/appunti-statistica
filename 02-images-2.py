from graphviz import Digraph

# Colori approssimati dal tuo tema LaTeX (come sopra)
bgcolor_page = "#141414"
node_fill_color = "#3C64A0"
node_border_color = "#46AAFF"
text_color = "#E6E6E6"
edge_color = "#969696"

# Crea un nuovo grafo diretto
dot = Digraph(comment="Albero Urna di Polya")
dot.attr(rankdir="LR", bgcolor=bgcolor_page)

# Attributi globali per i nodi
dot.node_attr.update(
    style="filled",
    shape="box",
    rounded="true",
    color=node_border_color,
    fillcolor=node_fill_color,
    fontcolor=text_color,
    fontname="Helvetica",
    fontsize="10",
)

# Attributi globali per gli archi
dot.edge_attr.update(
    color=edge_color, fontcolor=text_color, fontname="Helvetica", fontsize="9"
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

# Genera e salva l'immagine
try:
    dot.render("images/albero_polya", format="png", cleanup=True)
    print("File 'images/albero_polya.png' generato con successo.")
except Exception as e:
    print(f"Errore durante la generazione dell'immagine: {e}")
    print("Assicurati che Graphviz sia installato e nel PATH di sistema.")
