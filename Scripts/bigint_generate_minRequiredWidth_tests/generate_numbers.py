import random

# ===========
# === Smi ===
# ===========

smiMax = 2147483647
smiMin = -2147483648

def generateSmiNumbers():
  result = []
  result.append(0)
  result.append(1)
  result.append(-1)

  value = smiMax

  while value != 0:
    result.append(value)
    result.append(-value)
    value = int(value / 2)

  return result

# ============
# === Heap ===
# ============

wordMax = 18446744073709551615
wordMin = 0

def generateHeapNumbers(countButNotReally):
  result = []

  result.append(wordMax)
  result.append(-wordMax)

  maxWordCount = 3

  for i in range(0, countButNotReally):
    min1WordBecauseWeAlreadyAddedZero = 1
    wordCount = (i % maxWordCount) + min1WordBecauseWeAlreadyAddedZero

    value = 1
    for j in range(0, wordCount):
      word = random.randint(0, wordMax)
      value = value * wordMax + word
      word += 1

    # Hmm... this will produce very boring numbers
    # Let's make it a little bit more random:
    removeCount = random.randint(0, 10)
    s = str(value)[removeCount:]
    value = int(s)

    assert value > smiMax

    result.append(value)
    result.append(-value)

  return result
