import random
import sys

HEXAGRAMS = {
    1: ("䷀", "The Creative"),
    2: ("䷁", "The Receptive"),
    3: ("䷂", "Difficulty at the Beginning"),
    4: ("䷃", "Youthful Folly"),
    5: ("䷄", "Waiting"),
    6: ("䷅", "Conflict"),
    7: ("䷆", "The Army"),
    8: ("䷇", "Holding Together"),
    9: ("䷈", "Small Taming"),
    10: ("䷉", "Treading"),
    11: ("䷊", "Peace"),
    12: ("䷋", "Standstill"),
    13: ("䷌", "Fellowship"),
    14: ("䷍", "Possession in Great Measure"),
    15: ("䷎", "Modesty"),
    16: ("䷏", "Enthusiasm"),
    17: ("䷐", "Following"),
    18: ("䷑", "Work on What Has Been Spoiled"),
    19: ("䷒", "Approach"),
    20: ("䷓", "Contemplation"),
    21: ("䷔", "Biting Through"),
    22: ("䷕", "Grace"),
    23: ("䷖", "Splitting Apart"),
    24: ("䷗", "Return"),
    25: ("䷘", "Innocence"),
    26: ("䷙", "Great Taming"),
    27: ("䷚", "Nourishment"),
    28: ("䷛", "Preponderance of the Great"),
    29: ("䷜", "The Abysmal"),
    30: ("䷝", "The Clinging"),
    31: ("䷞", "Influence"),
    32: ("䷟", "Duration"),
    33: ("䷠", "Retreat"),
    34: ("䷡", "The Power of the Great"),
    35: ("䷢", "Progress"),
    36: ("䷣", "Darkening of the Light"),
    37: ("䷤", "The Family"),
    38: ("䷥", "Opposition"),
    39: ("䷦", "Obstruction"),
    40: ("䷧", "Liberation"),
    41: ("䷨", "Decrease"),
    42: ("䷩", "Increase"),
    43: ("䷪", "Breakthrough"),
    44: ("䷫", "Coming to Meet"),
    45: ("䷬", "Gathering Together"),
    46: ("䷭", "Pushing Upward"),
    47: ("䷮", "Oppression"),
    48: ("䷯", "The Well"),
    49: ("䷰", "Revolution"),
    50: ("䷱", "The Cauldron"),
    51: ("䷲", "The Arousing"),
    52: ("䷳", "Keeping Still"),
    53: ("䷴", "Development"),
    54: ("䷵", "The Marrying Maiden"),
    55: ("䷶", "Abundance"),
    56: ("䷷", "The Wanderer"),
    57: ("䷸", "The Gentle"),
    58: ("䷹", "The Joyous"),
    59: ("䷺", "Dispersion"),
    60: ("䷻", "Limitation"),
    61: ("䷼", "Inner Truth"),
    62: ("䷽", "Small Exceeding"),
    63: ("䷾", "After Completion"),
    64: ("䷿", "Before Completion")
}

def show_help():
    help_text = """
    I Ching Hexagram Generator (Python Script)
    --------------------------------------------

    Usage: python iching.py [OPTIONS]

    Generate a random I Ching hexagram.

    OPTIONS:
      -h, --help       Show this help message and package information.
      -v, --version    Show the script version.

    Package Information:
      Package: iching
      Version: 1.0
      Description: A simple I Ching hexagram generator in Python.
      Maintainer: Reza Sabooni

    """
    print(help_text)
    sys.exit()

# Function to generate a random hexagram and display its details
def generate_hexagram():
    # Randomly select a hexagram number (1 to 64)
    random.seed()
    hexagram_number = random.randint(1, 64)

    # Retrieve the corresponding Unicode symbol and name
    symbol, name = HEXAGRAMS[hexagram_number]

    # Return the details as a string or a dictionary
    return f"Hexagram Number: {hexagram_number}\nHexagram: {symbol}\nName: {name}"

# Example of calling the function:
if __name__ == "__main__":
    if len(sys.argv) == 1:
        print(generate_hexagram())
    elif sys.argv[1] in ("-h", "--help"):
        show_help()
    elif sys.argv[1] in ("-v", "--version"):
        print("iching version 1.0")
    else:
        print("Invalid option. Use -h or --help for usage information.")
        sys.exit(1)