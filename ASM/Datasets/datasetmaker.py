import random

def generate_product(id_product):
    while True:
        duration = random.randint(1, 10)
        deadline = random.randint(1, 100)
        priority = random.randint(1, 5)
        if duration + deadline <= 100:
            break
    return (id_product, duration, deadline, priority)

def calculate_penalty(products, order):
    current_time = 0
    total_penalty = 0
    for idx in order:
        product = products[idx]
        start_time = current_time
        end_time = start_time + product[1]
        if end_time > product[2]:
            total_penalty += (end_time - product[2]) * product[3]
        current_time = end_time
    return total_penalty

def sort_products(products, algorithm):
    if algorithm == "EDF":
        sorted_indices = sorted(range(len(products)), key=lambda i: (products[i][2], -products[i][3]))  # Earliest Deadline First, then Highest Priority
    elif algorithm == "HPF":
        sorted_indices = sorted(range(len(products)), key=lambda i: (-products[i][3], products[i][2]))  # Highest Priority First, then Earliest Deadline
    return sorted_indices

def generate_dataset(type, length):
    max_attempts = 10000
    attempts = 0

    while attempts < max_attempts:
        ids = list(range(1, length + 1))
        products = [generate_product(id_product) for id_product in ids]
        random.shuffle(products)
        
        if type == "None":
            penalty_edf = calculate_penalty(products, sort_products(products, "EDF"))
            penalty_hpf = calculate_penalty(products, sort_products(products, "HPF"))
            if penalty_edf > 0 and penalty_hpf > 0:
                return products
        elif type == "Both":
            penalty_edf = calculate_penalty(products, sort_products(products, "EDF"))
            penalty_hpf = calculate_penalty(products, sort_products(products, "HPF"))
            if penalty_edf == 0 and penalty_hpf == 0:
                return products
        else:
            sorted_indices = sort_products(products, type)
            return [products[i] for i in sorted_indices]

        attempts += 1

    raise RuntimeError(f"Unable to generate a {type} dataset after {max_attempts} attempts")

def save_to_file(products, filename):
    with open(filename, 'w') as file:
        for product in products:
            file.write(','.join(map(str, product)) + '\n')

def main():
    type = input("Enter the type of dataset (EDF, None, Both): ").strip()
    length = int(input("Enter the number of products: "))
    filename = input("Enter the filename to save the dataset: ").strip()
    
    if type not in ["EDF", "None", "Both"]:
        print("Invalid type. Please choose from EDF, None, Both.")
        return

    try:
        products = generate_dataset(type, length)
        save_to_file(products, filename)
        print(f"Dataset saved to {filename}")
    except RuntimeError as e:
        print(e)

if __name__ == "__main__":
    main()
