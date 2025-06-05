from graphviz import Digraph

# Colori approssimati dal tuo tema LaTeX
bgcolor_page = "#141414"  # bgcolor (20,20,20)
node_fill_color = "#3C64A0"  # nodecolor (60,100,160) ma più chiaro come nodecolor!60
node_border_color = "#46AAFF"  # accentcolor (70,170,255)
text_color = "#E6E6E6"  # maintext (230,230,230)
edge_color = "#969696"  # linkcolor (150,150,150)

# Crea un nuovo grafo diretto
dot = Digraph(comment="Albero Scelta Moneta e Lancio")
dot.attr(rankdir="LR", bgcolor=bgcolor_page)  # Layout da sinistra a destra, sfondo

# Attributi globali per i nodi
dot.node_attr.update(
    style="filled",
    shape="box",  # Rettangolare
    rounded="true",  # graphviz usa 'rounded'
    color=node_border_color,  # Colore del bordo
    fillcolor=node_fill_color,  # Colore di riempimento
    fontcolor=text_color,
    fontname="Helvetica",  # Font simile a quello sans-serif che usi
    fontsize="10",
)

# Attributi globali per gli archi
dot.edge_attr.update(
    color=edge_color, fontcolor=text_color, fontname="Helvetica", fontsize="9"
)

# Nodi del primo livello (Scelta Moneta)
dot.node("S", "Inizio")
dot.node("A", "Moneta A")
dot.node("B", "Moneta B")

# Archi dal nodo Inizio
dot.edge("S", "A", label="P(A)=1/2")
dot.edge("S", "B", label="P(B)=1/2")

# Nodi del secondo livello (Risultato Lancio) e probabilità congiunte
# Le probabilità congiunte sono calcolate e messe direttamente nell'etichetta del nodo foglia
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

# Genera e salva l'immagine
try:
    dot.render("images/albero_moneta_lancio", format="png", cleanup=True)
    print("File 'images/albero_moneta_lancio.png' generato con successo.")
except Exception as e:
    print(f"Errore durante la generazione dell'immagine: {e}")
    print("Assicurati che Graphviz sia installato e nel PATH di sistema.")
