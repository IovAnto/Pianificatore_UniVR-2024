import random

def generate_product(id_product):
    while True:
        duration = random.randint(1, 10)  # Genera una durata casuale compresa tra 1 e 10
        deadline = random.randint(1, 100)  # Genera una scadenza casuale compresa tra 1 e 100
        priority = random.randint(1, 5)  # Genera una priorità casuale compresa tra 1 e 5
        if duration + deadline <= 100:  # Verifica se la somma di durata e scadenza è minore o uguale a 100
            break
    return (id_product, duration, deadline, priority)  # Restituisce una tupla con l'id del prodotto, durata, scadenza e priorità

def calculate_penalty(products, order):
    current_time = 0  # Inizializza il tempo corrente a 0
    total_penalty = 0  # Inizializza la penalità totale a 0
    for idx in order:
        product = products[idx]  # Ottiene il prodotto corrispondente all'indice
        start_time = current_time  # Tempo di inizio è uguale al tempo corrente
        end_time = start_time + product[1]  # Tempo di fine è dato dalla somma del tempo di inizio e la durata del prodotto
        if end_time > product[2]:  # Verifica se il tempo di fine supera la scadenza del prodotto
            total_penalty += (end_time - product[2]) * product[3]  # Calcola la penalità e la aggiunge alla penalità totale
        current_time = end_time  # Aggiorna il tempo corrente al tempo di fine del prodotto
    return total_penalty  # Restituisce la penalità totale

def sort_products(products, algorithm):
    if algorithm == "EDF":
        sorted_indices = sorted(range(len(products)), key=lambda i: (products[i][2], -products[i][3]))  # Ordina gli indici dei prodotti in base alla scadenza più vicina e alla priorità più alta
    elif algorithm == "HPF":
        sorted_indices = sorted(range(len(products)), key=lambda i: (-products[i][3], products[i][2]))  # Ordina gli indici dei prodotti in base alla priorità più alta e alla scadenza più vicina
    return sorted_indices  # Restituisce gli indici dei prodotti ordinati

def generate_dataset(type, length):
    max_attempts = 10000  # Numero massimo di tentativi per generare il dataset
    attempts = 0  # Contatore dei tentativi

    while attempts < max_attempts:
        ids = list(range(1, length + 1))  # Genera una lista di id prodotto da 1 a length
        products = [generate_product(id_product) for id_product in ids]  # Genera una lista di prodotti con id generati casualmente
        random.shuffle(products)  # Mescola casualmente i prodotti
        
        if type == "None":
            penalty_edf = calculate_penalty(products, sort_products(products, "EDF"))  # Calcola la penalità utilizzando l'algoritmo EDF
            penalty_hpf = calculate_penalty(products, sort_products(products, "HPF"))  # Calcola la penalità utilizzando l'algoritmo HPF
            if penalty_edf > 0 and penalty_hpf > 0:  # Verifica se entrambe le penalità sono maggiori di 0
                return products  # Restituisce i prodotti generati
        elif type == "Both":
            penalty_edf = calculate_penalty(products, sort_products(products, "EDF"))  # Calcola la penalità utilizzando l'algoritmo EDF
            penalty_hpf = calculate_penalty(products, sort_products(products, "HPF"))  # Calcola la penalità utilizzando l'algoritmo HPF
            if penalty_edf == 0 and penalty_hpf == 0:  # Verifica se entrambe le penalità sono uguali a 0
                return products  # Restituisce i prodotti generati
        else:
            sorted_indices = sort_products(products, type)  # Ordina i prodotti utilizzando l'algoritmo specificato
            return [products[i] for i in sorted_indices]  # Restituisce i prodotti ordinati

        attempts += 1  # Incrementa il contatore dei tentativi

    raise RuntimeError(f"Impossibile generare un dataset di tipo {type} dopo {max_attempts} tentativi")  # Solleva un'eccezione se non è possibile generare il dataset

def save_to_file(products, filename):
    with open(filename, 'w') as file:  # Apre il file in modalità scrittura
        for product in products:
            file.write(','.join(map(str, product)) + '\n')  # Scrive i prodotti nel file separati da virgole

def main():
    type = input("Inserisci il tipo di dataset (EDF, None, Both): ").strip()  # Chiede all'utente di inserire il tipo di dataset
    length = int(input("Inserisci il numero di prodotti: "))  # Chiede all'utente di inserire il numero di prodotti
    filename = input("Inserisci il nome del file per salvare il dataset: ").strip()  # Chiede all'utente di inserire il nome del file
    
    if type not in ["EDF", "None", "Both"]:  # Verifica se il tipo inserito è valido
        print("Tipo non valido. Scegli tra EDF, None, Both.")
        return

    try:
        products = generate_dataset(type, length)  # Genera il dataset
        save_to_file(products, filename)  # Salva il dataset nel file
        print(f"Dataset salvato in {filename}")
    except RuntimeError as e:
        print(e)

if __name__ == "__main__":
    main()
