#!/bin/bash

# Function to show help with package control information
show_help() {
    cat <<EOF
I Ching Hexagram Generator (Bash Script)
------------------------------------------

Usage: iching [OPTIONS]

Generate a random I Ching hexagram.

OPTIONS:
  -h, --help       Show this help message and package information.
  -v, --version    Show the script version.

Package Information:
  Package: iching
  Version: 1.0
  Section: utils
  Priority: optional
  Architecture: amd64
  Depends: bash
  Maintainer: Reza Sabooni <reza.sabooni@gmail.com>
  Description: A simple I Ching hexagram generator in Bash.

EOF
}

# Define the hexagrams
declare -A HEXAGRAMS=(
    [1]="䷀ The Creative"
    [2]="䷁ The Receptive"
    [3]="䷂ Difficulty at the Beginning"
    [4]="䷃ Youthful Folly"
    [5]="䷄ Waiting"
    [6]="䷅ Conflict"
    [7]="䷆ The Army"
    [8]="䷇ Holding Together"
    [9]="䷈ Small Taming"
    [10]="䷉ Treading"
    [11]="䷊ Peace"
    [12]="䷋ Standstill"
    [13]="䷌ Fellowship"
    [14]="䷍ Possession in Great Measure"
    [15]="䷎ Modesty"
    [16]="䷏ Enthusiasm"
    [17]="䷐ Following"
    [18]="䷑ Work on What Has Been Spoiled"
    [19]="䷒ Approach"
    [20]="䷓ Contemplation"
    [21]="䷔ Biting Through"
    [22]="䷕ Grace"
    [23]="䷖ Splitting Apart"
    [24]="䷗ Return"
    [25]="䷘ Innocence"
    [26]="䷙ Great Taming"
    [27]="䷚ Nourishment"
    [28]="䷛ Preponderance of the Great"
    [29]="䷜ The Abysmal"
    [30]="䷝ The Clinging"
    [31]="䷞ Influence"
    [32]="䷟ Duration"
    [33]="䷠ Retreat"
    [34]="䷡ The Power of the Great"
    [35]="䷢ Progress"
    [36]="䷣ Darkening of the Light"
    [37]="䷤ The Family"
    [38]="䷥ Opposition"
    [39]="䷦ Obstruction"
    [40]="䷧ Liberation"
    [41]="䷨ Decrease"
    [42]="䷩ Increase"
    [43]="䷪ Breakthrough"
    [44]="䷫ Coming to Meet"
    [45]="䷬ Gathering Together"
    [46]="䷭ Pushing Upward"
    [47]="䷮ Oppression"
    [48]="䷯ The Well"
    [49]="䷰ Revolution"
    [50]="䷱ The Cauldron"
    [51]="䷲ The Arousing"
    [52]="䷳ Keeping Still"
    [53]="䷴ Development"
    [54]="䷵ The Marrying Maiden"
    [55]="䷶ Abundance"
    [56]="䷷ The Wanderer"
    [57]="䷸ The Gentle"
    [58]="䷹ The Joyous"
    [59]="䷺ Dispersion"
    [60]="䷻ Limitation"
    [61]="䷼ Inner Truth"
    [62]="䷽ Small Exceeding"
    [63]="䷾ After Completion"
    [64]="䷿ Before Completion"
)


# Function to generate a random hexagram and display its details
generate_hexagram() {
    # Randomly select a hexagram number (1 to 64)
    hexagram_number=$((RANDOM % 64 + 1))

    # Retrieve the corresponding hexagram symbol and name
    hexagram_info="${HEXAGRAMS[$hexagram_number]}"

    # Display the result
    echo -e "Hexagram Number: $hexagram_number\nHexagram: $hexagram_info"
}


# Check if any argument is passed
if [[ $# -eq 0 ]]; then
    generate_hexagram
else
    case "$1" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            echo "iching version 1.0"
            ;;
        *)
            echo "Invalid option. Use -h or --help for usage information."
            exit 1
            ;;
    esac
fi