import random

def generate_test_data(num_lines):
    data = []
    used_ids = set()
    max_id = 127  # Maximum possible ID
    while len(data) < min(num_lines, max_id):
        a = random.randint(1, max_id)
        if a not in used_ids:
            used_ids.add(a)
            b = random.randint(2, 10)
            c = random.randint(10, 80)
            d = random.randint(1, 5)
            data.append(f"{a},{b},{c},{d}")
    return data

# Generate 500 lines of data
test_data = generate_test_data(99)


# Ask user for file name from command line
file_name = input("Enter file name: ")

# Write the data to the specified file
with open(file_name, "w") as file:
    for line in test_data:
        file.write(line + "\n")
with open("test_data.txt", "w") as file:
    for line in test_data:
        file.write(line + "\n")
