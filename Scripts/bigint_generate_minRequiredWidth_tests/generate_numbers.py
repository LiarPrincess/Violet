import random

# ===========
# === Smi ===
# ===========

smi_max = 2147483647
smi_min = -2147483648


def generate_smi_numbers():
    result = []
    result.append(0)
    result.append(1)
    result.append(-1)

    value = smi_max

    while value != 0:
        result.append(value)
        result.append(-value)
        value = int(value / 2)

    return result

# ============
# === Heap ===
# ============


word_max = 18446744073709551615
word_min = 0


def generate_heap_numbers(count_but_not_really):
    result = []

    result.append(word_max)
    result.append(-word_max)

    maxWordCount = 3

    for i in range(0, count_but_not_really):
        min_1_word_because_we_already_added_0 = 1
        word_count = (i % maxWordCount) + min_1_word_because_we_already_added_0

        value = 1
        for j in range(0, word_count):
            word = random.randint(0, word_max)
            value = value * word_max + word
            word += 1

        # Hmm... this will produce very boring numbers
        # Let's make it a little bit more random:
        removeCount = random.randint(0, 10)
        s = str(value)[removeCount:]
        value = int(s)

        assert value > smi_max

        result.append(value)
        result.append(-value)

    return result
