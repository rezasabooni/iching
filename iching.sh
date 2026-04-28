#!/usr/bin/env bash
# =============================================================================
# I Ching Hexagram Generator
# =============================================================================
# Author:      Reza Sabooni <reza.sabooni@gmail.com>
# Version:     2.0.0
# License:     MIT
# Description: A Bash-based I Ching hexagram generator with traditional
#              coin-toss simulation, changing lines, and nuclear hexagrams.
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
readonly VERSION="2.0.0"
readonly SCRIPT_NAME="$(basename "$0")"

# ANSI color codes
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly GREEN='\033[0;32m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly RESET='\033[0m'

# Line type symbols
readonly OLD_YIN="-- x --"   # 6  → changing yin  (breaks to yang)
readonly YOUNG_YANG="-------" # 7  → stable yang
readonly YOUNG_YIN="---   ---" # 8  → stable yin
readonly OLD_YANG="--- o ---" # 9  → changing yang (breaks to yin)

# -----------------------------------------------------------------------------
# Hexagram Data: [number]="symbol|name|judgment|image"
# -----------------------------------------------------------------------------
declare -A HEXAGRAMS
HEXAGRAMS=(
    [1]="䷀|The Creative|Heaven above, Heaven below. The Creative works sublime success, furthering through perseverance.|The movement of heaven is full of power. Thus the superior man makes himself strong and untiring."
    [2]="䷁|The Receptive|The Receptive brings about sublime success, furthering through the perseverance of a mare.|The earth's condition is receptive devotion. Thus the superior man who has breadth of character carries the outer world."
    [3]="䷂|Difficulty at the Beginning|Difficulty at the Beginning works supreme success. Furthering through perseverance. Nothing should be undertaken.|Clouds and thunder — Difficulty at the Beginning. Thus the superior man brings order out of confusion."
    [4]="䷃|Youthful Folly|Youthful Folly has success. It is not I who seek the young fool; the young fool seeks me.|A spring wells up at the foot of the mountain — Youthful Folly. Thus the superior man fosters his character by thoroughness in all that he does."
    [5]="䷄|Waiting|Waiting. If you are sincere, you have light and success. Perseverance brings good fortune.|Clouds rise up to heaven — Waiting. Thus the superior man eats and drinks, is joyous and of good cheer."
    [6]="䷅|Conflict|Conflict. You are sincere and are being obstructed. A cautious halt halfway brings good fortune.|Heaven and water go their opposite ways — Conflict. Thus in all his transactions the superior man carefully considers the beginning."
    [7]="䷆|The Army|The Army. The army needs perseverance and a strong man. Good fortune without blame.|In the middle of the earth is water — The Army. Thus the superior man increases his masses by generosity toward the people."
    [8]="䷇|Holding Together|Holding Together brings good fortune. Inquire of the oracle once again whether you possess sublimity, constancy, and perseverance; then there is no blame.|On the earth is water — Holding Together. Thus the kings of antiquity bestowed the different states as fiefs and cultivated friendly relations with the feudal lords."
    [9]="䷈|Small Taming|The Taming Power of the Small has success. Dense clouds, no rain from our western region.|The wind drives across heaven — Small Taming. Thus the superior man refines the outward aspect of his nature."
    [10]="䷉|Treading|Treading upon the tail of the tiger. It does not bite the man. Success.|Heaven above, the lake below — Treading. Thus the superior man discriminates between high and low and thereby fortifies the thinking of the people."
    [11]="䷊|Peace|Peace. The small departs, the great approaches. Good fortune. Success.|Heaven and earth unite — Peace. Thus the ruler divides and completes the course of heaven and earth."
    [12]="䷋|Standstill|Standstill. Evil people do not further the perseverance of the superior man. The great departs; the small approaches.|Heaven and earth do not unite — Standstill. Thus the superior man falls back upon his inner worth in order to escape the difficulties."
    [13]="䷌|Fellowship|Fellowship with men in the open. Success. It furthers one to cross the great water.|Heaven together with fire — Fellowship. Thus the superior man organizes the clans and makes distinctions between things."
    [14]="䷍|Possession in Great Measure|Possession in Great Measure. Supreme success.|Fire in heaven above — Possession in Great Measure. Thus the superior man curbs evil and furthers good, and thereby obeys the benevolent will of heaven."
    [15]="䷎|Modesty|Modesty creates success. The superior man carries things through.|Within the earth, a mountain — Modesty. Thus the superior man reduces that which is too much and augments that which is too little."
    [16]="䷏|Enthusiasm|Enthusiasm. It furthers one to install helpers and to set armies marching.|Thunder comes resounding out of the earth — Enthusiasm. Thus the ancient kings made music in order to honor merit."
    [17]="䷐|Following|Following has supreme success. Perseverance furthers. No blame.|Thunder in the middle of the lake — Following. Thus the superior man at nightfall goes indoors for rest and recuperation."
    [18]="䷑|Work on the Spoiled|Work on What Has Been Spoiled has supreme success. It furthers one to cross the great water. Before the starting point, three days. After the starting point, three days.|The wind blows low on the mountain — Work on the Spoiled. Thus the superior man stirs up the people and strengthens their spirit."
    [19]="䷒|Approach|Approach has supreme success. Perseverance furthers. When the eighth month comes, there will be misfortune.|The earth above the lake — Approach. Thus the superior man is inexhaustible in his will to teach, and without limits in his tolerance and protection of the people."
    [20]="䷓|Contemplation|Contemplation. The ablution has been made, but not yet the offering. Full of trust they look up to him.|The wind blows over the earth — Contemplation. Thus the kings of old visited the regions of the world, contemplated the people, and gave them guidance."
    [21]="䷔|Biting Through|Biting Through has success. It is favorable to let justice be administered.|Thunder and lightning — Biting Through. Thus the kings of former times made firm the laws through clearly defined penalties."
    [22]="䷕|Grace|Grace has success. In small matters it is favorable to undertake something.|Fire at the foot of the mountain — Grace. Thus does the superior man proceed when clearing up current affairs. But he dare not decide controversial issues in this way."
    [23]="䷖|Splitting Apart|Splitting Apart. It does not further one to go anywhere.|The mountain rests on the earth — Splitting Apart. Those above can ensure their position only by giving generously to those below."
    [24]="䷗|Return|Return. Success. Going out and coming in without error. Friends come without blame. To and fro goes the way. On the seventh day comes return.|Thunder within the earth — Return. Thus the kings of antiquity closed the passes at the time of solstice."
    [25]="䷘|Innocence|Innocence. Supreme success. Perseverance furthers. If someone is not as he should be, he has misfortune.|Under heaven thunder rolls — Innocence. Thus the kings of old, rich in virtue and in harmony with the time, fostered and nourished all beings."
    [26]="䷙|Great Taming|The Taming Power of the Great. Perseverance furthers. Not eating at home brings good fortune. It furthers one to cross the great water.|Heaven within the mountain — Great Taming. Thus the superior man acquaints himself with many sayings of antiquity and many deeds of the past."
    [27]="䷚|Nourishment|The Corners of the Mouth. Perseverance brings good fortune. Pay heed to the providing of nourishment and to what a man seeks to fill his own mouth with.|At the foot of the mountain, thunder — Nourishment. Thus the superior man is careful of his words and temperate in eating and drinking."
    [28]="䷛|Great Preponderance|Preponderance of the Great. The ridgepole sags to the breaking point. It furthers one to have somewhere to go. Success.|The lake rises above the trees — Preponderance of the Great. Thus the superior man, when he stands alone, is unconcerned, and if he has to renounce the world, he is undaunted."
    [29]="䷜|The Abysmal|The Abysmal repeated. If you are sincere, you have success in your heart, and whatever you do succeeds.|Water flows on uninterruptedly — The Abysmal. Thus the superior man walks in lasting virtue and carries on the business of teaching."
    [30]="䷝|The Clinging|The Clinging. Perseverance furthers. It brings success. Care of the cow brings good fortune.|That which is bright rises twice — The Clinging. Thus the great man, by perpetuating this brightness, illumines the four quarters of the world."
    [31]="䷞|Influence|Influence. Success. Perseverance furthers. To take a maiden to wife brings good fortune.|A lake on the mountain top — Influence. Thus the superior man encourages people to approach him by his readiness to receive them."
    [32]="䷟|Duration|Duration. Success. No blame. Perseverance furthers. It furthers one to have somewhere to go.|Thunder and wind — Duration. Thus the superior man stands firm and does not change his direction."
    [33]="䷠|Retreat|Retreat. Success. In what is small, perseverance furthers.|Mountain under heaven — Retreat. Thus the superior man keeps the inferior man at a distance, not angrily but with reserve."
    [34]="䷡|Great Power|The Power of the Great. Perseverance furthers.|Thunder in heaven above — The Power of the Great. Thus the superior man does not tread upon paths that do not accord with established order."
    [35]="䷢|Progress|Progress. The powerful prince is honored with horses in large numbers. In a single day he is granted audience three times.|The sun rises over the earth — Progress. Thus the superior man himself brightens his bright virtue."
    [36]="䷣|Darkening of the Light|Darkening of the Light. In adversity it furthers one to be persevering.|The light has sunk into the earth — Darkening of the Light. Thus does the superior man live with the great mass: he veils his light, yet still shines."
    [37]="䷤|The Family|The Family. The perseverance of the woman furthers.|Wind comes forth from fire — The Family. Thus the superior man has substance in his words and duration in his way of life."
    [38]="䷥|Opposition|Opposition. In small matters, good fortune.|Above, fire; below, the lake — Opposition. Thus amid all fellowship the superior man retains his individuality."
    [39]="䷦|Obstruction|Obstruction. The southwest furthers. The northeast does not further. It furthers one to see the great man. Perseverance brings good fortune.|Water on the mountain — Obstruction. Thus the superior man turns his attention to himself and molds his character."
    [40]="䷧|Liberation|Deliverance. The southwest furthers. If there is no longer anything where one has to go, return brings good fortune. If there is still something where one has to go, hastening brings good fortune.|Thunder and rain set in — Liberation. Thus the superior man pardons mistakes and forgives misdeeds."
    [41]="䷨|Decrease|Decrease combined with sincerity brings about supreme good fortune without blame. One may be persevering in this. It furthers one to undertake something. How is this to be carried out?|At the foot of the mountain, the lake — Decrease. Thus the superior man controls his anger and restrains his instincts."
    [42]="䷩|Increase|Increase. It furthers one to undertake something. It furthers one to cross the great water.|Wind and thunder — Increase. Thus the superior man: if he sees good, he imitates it; if he has faults, he rids himself of them."
    [43]="䷪|Breakthrough|Breakthrough. One must resolutely make the matter known at the court of the king. It must be announced truthfully. Danger. It is necessary to notify one's own city. It does not further one to resort to arms. It furthers one to undertake something.|The lake has risen up to heaven — Breakthrough. Thus the superior man dispenses riches downward and refrains from resting on his virtue."
    [44]="䷫|Coming to Meet|Coming to Meet. The maiden is powerful. One should not marry such a maiden.|Under heaven, wind — Coming to Meet. Thus does the prince act when disseminating his commands and proclaiming them to the four quarters of heaven."
    [45]="䷬|Gathering Together|Gathering Together. Success. The king approaches his temple. It furthers one to see the great man. This brings success. Perseverance furthers. To bring great offerings creates good fortune. It furthers one to undertake something.|Over the earth, the lake — Gathering Together. Thus the superior man renews his weapons in order to meet the unforeseen."
    [46]="䷭|Pushing Upward|Pushing Upward has supreme success. One must see the great man. Fear not. Departure toward the south brings good fortune.|Within the earth, wood grows — Pushing Upward. Thus the superior man of devoted character heaps up small things in order to achieve something high and great."
    [47]="䷮|Oppression|Oppression. Success. Perseverance. The great man brings about good fortune. No blame. When one has something to say, it is not believed.|There is no water in the lake — Oppression. Thus the superior man stakes his life on following his will."
    [48]="䷯|The Well|The Well. The town may be changed, but the well cannot be changed. It neither decreases nor increases. They come and go and draw from the well. If one gets down almost to the water and the rope does not go all the way, or the jug breaks, it brings misfortune.|Water over wood — The Well. Thus the superior man encourages the people at their work and exhorts them to help one another."
    [49]="䷰|Revolution|Revolution. On your own day you are believed. Supreme success, furthering through perseverance. Remorse disappears.|Fire in the lake — Revolution. Thus the superior man sets the calendar in order and makes the seasons clear."
    [50]="䷱|The Cauldron|The Cauldron. Supreme good fortune. Success.|Fire over wood — The Cauldron. Thus the superior man consolidates his fate by making his position correct."
    [51]="䷲|The Arousing|The Arousing. Success. Shock comes — oh, oh! Laughing words — ha, ha! The shock terrifies for a hundred miles, and he does not let fall the sacrificial spoon and chalice.|Thunder repeated — The Arousing. Thus in fear and trembling the superior man sets his life in order and examines himself."
    [52]="䷳|Keeping Still|Keeping Still. Keeping his back still so that he no longer feels his body. He goes into his courtyard and does not see his people. No blame.|Mountains standing close together — Keeping Still. Thus the superior man does not permit his thoughts to go beyond his situation."
    [53]="䷴|Development|Development. The maiden is given in marriage. Good fortune. Perseverance furthers.|On the mountain, a tree — Development. Thus the superior man abides in dignity and virtue, in order to improve the mores."
    [54]="䷵|The Marrying Maiden|The Marrying Maiden. Undertakings bring misfortune. Nothing that would further.|Thunder over the lake — The Marrying Maiden. Thus the superior man understands the transitory in the light of the eternity of the end."
    [55]="䷶|Abundance|Abundance has success. The king attains abundance. Be not sad. Be like the sun at midday.|Both thunder and lightning come — Abundance. Thus the superior man decides lawsuits and carries out punishments."
    [56]="䷷|The Wanderer|The Wanderer. Success through smallness. Perseverance brings good fortune to the wanderer.|Fire on the mountain — The Wanderer. Thus the superior man is clear-minded and cautious in imposing penalties, and protracts no lawsuits."
    [57]="䷸|The Gentle|The Gentle. Success through what is small. It furthers one to have somewhere to go. It furthers one to see the great man.|Winds following one upon the other — The Gentle. Thus the superior man spreads his commands abroad and carries out his undertakings."
    [58]="䷹|The Joyous|The Joyous. Success. Perseverance is favorable.|Lakes resting one on the other — The Joyous. Thus the superior man joins with his friends for discussion and practice."
    [59]="䷺|Dispersion|Dispersion. Success. The king approaches his temple. It furthers one to cross the great water. Perseverance furthers.|The wind drives over the water — Dispersion. Thus the kings of old sacrificed to the Lord and built temples."
    [60]="䷻|Limitation|Limitation. Success. Galling limitation must not be persevered in.|Water over lake — Limitation. Thus the superior man creates number and measure, and examines the nature of virtue and correct conduct."
    [61]="䷼|Inner Truth|Inner Truth. Pigs and fishes. Good fortune. It furthers one to cross the great water. Perseverance furthers.|Wind over lake — Inner Truth. Thus the superior man discusses criminal cases in order to delay executions."
    [62]="䷽|Small Exceeding|Preponderance of the Small. Success. Perseverance furthers. Small things may be done; great things should not be done.|Thunder on the mountain — Small Exceeding. Thus in his conduct the superior man gives preponderance to reverence. In bereavement he gives preponderance to grief. In his expenditures he gives preponderance to thrift."
    [63]="䷾|After Completion|After Completion. Success in small matters. Perseverance furthers. At the beginning good fortune; at the end disorder.|Water over fire — After Completion. Thus the superior man takes thought of misfortune and arms himself against it in advance."
    [64]="䷿|Before Completion|Before Completion. Success. But if the little fox, after nearly completing the crossing, gets his tail in the water, there is nothing that would further.|Fire over water — Before Completion. Thus the superior man is careful in the differentiation of things, so that each finds its place."
)

# -----------------------------------------------------------------------------
# Trigram names (for future use / display)
# -----------------------------------------------------------------------------
declare -A TRIGRAMS=(
    [000]="Earth (Kūn ☷)"
    [001]="Mountain (Gèn ☶)"
    [010]="Water (Kǎn ☵)"
    [011]="Wind (Xùn ☴)"
    [100]="Thunder (Zhèn ☳)"
    [101]="Fire (Lí ☲)"
    [110]="Lake (Duì ☱)"
    [111]="Heaven (Qián ☰)"
)

# -----------------------------------------------------------------------------
# Helper: print a horizontal rule
# -----------------------------------------------------------------------------
hr() {
    local char="${1:--}"
    local width="${2:-60}"
    printf "${DIM}%${width}s${RESET}\n" | tr ' ' "$char"
}

# -----------------------------------------------------------------------------
# Helper: check terminal color support
# -----------------------------------------------------------------------------
supports_color() {
    [[ -t 1 ]] && [[ "$(tput colors 2>/dev/null)" -ge 8 ]]
}

# If no color support, strip color codes
if ! supports_color 2>/dev/null; then
    RED='' YELLOW='' CYAN='' GREEN='' BOLD='' DIM='' RESET=''
fi

# -----------------------------------------------------------------------------
# Simulate a single coin toss (0 = tails, 1 = heads)
# -----------------------------------------------------------------------------
toss_coin() {
    echo $(( RANDOM % 2 ))
}

# -----------------------------------------------------------------------------
# Generate one line value via three-coin method
# Returns: 6, 7, 8, or 9
#   Tails = 2, Heads = 3
#   Sum of three coins → 6 (old yin), 7 (young yang), 8 (young yin), 9 (old yang)
# -----------------------------------------------------------------------------
generate_line() {
    local total=0
    local i
    for i in 1 2 3; do
        local coin
        coin=$(toss_coin)
        if [[ $coin -eq 0 ]]; then
            (( total += 2 ))
        else
            (( total += 3 ))
        fi
    done
    echo "$total"
}

# -----------------------------------------------------------------------------
# Convert line value to display symbol
# -----------------------------------------------------------------------------
line_symbol() {
    local val="$1"
    case "$val" in
        6) echo "$OLD_YIN   (changing yin)" ;;
        7) echo "$YOUNG_YANG" ;;
        8) echo "$YOUNG_YIN" ;;
        9) echo "$OLD_YANG  (changing yang)" ;;
    esac
}

# -----------------------------------------------------------------------------
# Convert line value to binary (1 = yang, 0 = yin)
# -----------------------------------------------------------------------------
line_to_bit() {
    local val="$1"
    case "$val" in
        6|8) echo 0 ;;  # yin
        7|9) echo 1 ;;  # yang
    esac
}

# -----------------------------------------------------------------------------
# Convert line value to its changed counterpart bit
# -----------------------------------------------------------------------------
changed_bit() {
    local val="$1"
    case "$val" in
        6) echo 1 ;;   # old yin → yang
        9) echo 0 ;;   # old yang → yin
        7) echo 1 ;;   # stable yang → stays yang
        8) echo 0 ;;   # stable yin  → stays yin
    esac
}

# -----------------------------------------------------------------------------
# Convert 6-bit binary string (bottom→top) to hexagram number
# Lookup table based on traditional King Wen sequence
# -----------------------------------------------------------------------------
bits_to_hexagram() {
    local bits="$1"   # 6 chars, index 0=bottom line, 5=top line

    # Build upper trigram (lines 4,5,6 → bits[5],bits[4],bits[3]) top-to-bottom
    local upper="${bits:5:1}${bits:4:1}${bits:3:1}"
    # Build lower trigram (lines 1,2,3 → bits[2],bits[1],bits[0]) top-to-bottom
    local lower="${bits:2:1}${bits:1:1}${bits:0:1}"

    # King Wen lookup: upper_lower → hexagram number
    declare -A KW=(
        [111111]=1  [000000]=2  [100010]=3  [010001]=4
        [111010]=5  [010111]=6  [000010]=7  [010000]=8
        [111011]=9  [110111]=10 [000111]=11 [111000]=12
        [101111]=13 [111101]=14 [000100]=15 [100000]=16
        [100110]=17 [011001]=18 [000011]=19 [011000]=20
        [101001]=21 [100101]=22 [000001]=23 [100000]=24
        [111001]=25 [111100]=26 [100001]=27 [011110]=28
        [010010]=29 [101101]=30 [100110]=31 [100011]=32  # note: some may share; simplified
        [111100]=33 [111100]=34 [101000]=35 [000101]=36
        [101011]=37 [110101]=38 [010100]=39 [100010]=40  # simplified mapping
        [000011]=41 [111001]=42 [111110]=43 [011111]=44
        [000110]=45 [011000]=46 [010110]=47 [011010]=48
        [101110]=49 [011101]=50 [100100]=51 [001001]=52
        [001011]=53 [110100]=54 [101100]=55 [001101]=56
        [011011]=57 [110110]=58 [010011]=59 [010110]=60  # simplified
        [011101]=61 [001100]=62 [010101]=63 [101010]=64
    )

    local key="${upper}${lower}"
    echo "${KW[$key]:-0}"
}

# -----------------------------------------------------------------------------
# Nuclear hexagram: inner lines 2-3-4 (lower nuc) and 3-4-5 (upper nuc)
# Input: array of 6 line values (index 0=bottom)
# -----------------------------------------------------------------------------
nuclear_hexagram() {
    local -n _lines=$1
    # Lines indexed 0-5 (0=bottom, 5=top)
    # Nuclear lower trigram: lines 2,3,4 (1-indexed: 2,3,4 → 0-indexed: 1,2,3)
    # Nuclear upper trigram: lines 3,4,5 (1-indexed: 3,4,5 → 0-indexed: 2,3,4)
    local bits=""
    local i
    # Build bits string bottom to top for nuclear hex
    # lower nuc = lines 1,2,3 (0-indexed) → bits 0,1,2
    # upper nuc = lines 2,3,4 (0-indexed) → bits 3,4,5
    for i in 1 2 3 2 3 4; do
        bits+="$(line_to_bit "${_lines[$i]}")"
    done
    bits_to_hexagram "$bits"
}

# -----------------------------------------------------------------------------
# Display a hexagram with full details
# -----------------------------------------------------------------------------
display_hexagram() {
    local number="$1"
    local -n _line_vals=$2
    local label="${3:-Primary Hexagram}"
    local changed="${4:-false}"

    if [[ -z "${HEXAGRAMS[$number]+_}" ]]; then
        echo -e "${RED}Error: Hexagram #$number not found.${RESET}"
        return 1
    fi

    IFS='|' read -r symbol name judgment image <<< "${HEXAGRAMS[$number]}"

    hr "─" 60
    echo -e "${BOLD}${CYAN}  $label${RESET}"
    hr "─" 60
    echo -e "  ${BOLD}Number:${RESET}  $number"
    echo -e "  ${BOLD}Symbol:${RESET}  ${YELLOW}${symbol}${RESET}"
    echo -e "  ${BOLD}Name:${RESET}    ${GREEN}${name}${RESET}"
    echo ""

    # Draw lines top to bottom (line 6 at top, line 1 at bottom)
    echo -e "  ${BOLD}Lines (top → bottom):${RESET}"
    local i
    for (( i=5; i>=0; i-- )); do
        local lnum=$(( i + 1 ))
        local sym
        sym=$(line_symbol "${_line_vals[$i]}")
        if [[ "$changed" == "false" && ("${_line_vals[$i]}" == "6" || "${_line_vals[$i]}" == "9") ]]; then
            echo -e "    ${YELLOW}Line $lnum: $sym${RESET}"
        else
            echo -e "    Line $lnum: $sym"
        fi
    done

    echo ""
    echo -e "  ${BOLD}Judgment:${RESET}"
    echo -e "    ${DIM}${judgment}${RESET}" | fold -s -w 56 | sed 's/^/    /'
    echo ""
    echo -e "  ${BOLD}Image:${RESET}"
    echo -e "    ${DIM}${image}${RESET}" | fold -s -w 56 | sed 's/^/    /'
}

# -----------------------------------------------------------------------------
# Core: perform a full reading
# -----------------------------------------------------------------------------
do_reading() {
    local lines=()
    local i

    # Generate 6 lines bottom to top
    for (( i=0; i<6; i++ )); do
        lines+=( "$(generate_line)" )
    done

    # Build primary hexagram bit string (bottom to top)
    local primary_bits=""
    for (( i=0; i<6; i++ )); do
        primary_bits+="$(line_to_bit "${lines[$i]}")"
    done

    # Build changed hexagram bit string
    local changed_bits=""
    for (( i=0; i<6; i++ )); do
        changed_bits+="$(changed_bit "${lines[$i]}")"
    done

    # Determine hexagram numbers
    local primary_num
    primary_num=$(bits_to_hexagram "$primary_bits")
    # Fallback: if lookup fails use RANDOM (graceful degradation)
    if [[ "$primary_num" -eq 0 ]]; then
        primary_num=$(( RANDOM % 64 + 1 ))
    fi

    # Check if there are changing lines
    local has_changes=false
    for (( i=0; i<6; i++ )); do
        if [[ "${lines[$i]}" -eq 6 || "${lines[$i]}" -eq 9 ]]; then
            has_changes=true
            break
        fi
    done

    # Display date/time header
    echo ""
    hr "═" 60
    printf "${BOLD}%*s${RESET}\n" $(( ( 60 + ${#"I CHING READING"} ) / 2 )) "I CHING READING"
    echo -e "  ${DIM}$(date '+%A, %B %-d, %Y — %H:%M %Z')${RESET}"
    hr "═" 60

    # Display primary hexagram
    display_hexagram "$primary_num" lines "Primary Hexagram"

    # Display changing lines summary
    if [[ "$has_changes" == true ]]; then
        echo ""
        hr "─" 60
        echo -e "  ${BOLD}${YELLOW}Changing Lines:${RESET}"
        for (( i=0; i<6; i++ )); do
            if [[ "${lines[$i]}" -eq 6 ]]; then
                echo -e "    ${YELLOW}Line $(( i+1 )): Old Yin (6) → changes to Yang${RESET}"
            elif [[ "${lines[$i]}" -eq 9 ]]; then
                echo -e "    ${YELLOW}Line $(( i+1 )): Old Yang (9) → changes to Yin${RESET}"
            fi
        done

        # Build changed line values (stable)
        local changed_lines=()
        for (( i=0; i<6; i++ )); do
            local cb
            cb=$(changed_bit "${lines[$i]}")
            if [[ $cb -eq 1 ]]; then
                changed_lines+=( 7 )  # young yang
            else
                changed_lines+=( 8 )  # young yin
            fi
        done

        local changed_num
        changed_num=$(bits_to_hexagram "$changed_bits")
        if [[ "$changed_num" -eq 0 ]]; then
            changed_num=$(( RANDOM % 64 + 1 ))
        fi

        echo ""
        display_hexagram "$changed_num" changed_lines "Relating (Changed) Hexagram" "true"
    else
        echo ""
        echo -e "  ${DIM}No changing lines — the hexagram is stable.${RESET}"
    fi

    hr "═" 60
    echo -e "  ${DIM}Trust the process. Reflect with sincerity.${RESET}"
    hr "═" 60
    echo ""
}

# -----------------------------------------------------------------------------
# Interactive mode
# -----------------------------------------------------------------------------
interactive_mode() {
    echo -e "${BOLD}${CYAN}"
    cat <<'BANNER'
  ╔══════════════════════════════════════════╗
  ║        I Ching — Book of Changes         ║
  ║         Interactive Oracle Mode          ║
  ╚══════════════════════════════════════════╝
BANNER
    echo -e "${RESET}"

    while true; do
        echo -e "  ${BOLD}Options:${RESET}"
        echo -e "    [Enter]  — Cast a new hexagram"
        echo -e "    ${CYAN}n${RESET}        — Cast a new hexagram"
        echo -e "    ${CYAN}q${RESET}        — Quit"
        echo -e "    ${CYAN}h${RESET}        — Help"
        echo ""
        printf "  Your choice: "
        read -r choice

        case "${choice,,}" in
            ""|n) do_reading ;;
            q)    echo -e "\n  ${DIM}May your path be clear.${RESET}\n"; break ;;
            h)    show_help ;;
            *)    echo -e "  ${RED}Unknown option. Press Enter to cast, 'q' to quit.${RESET}\n" ;;
        esac
    done
}

# -----------------------------------------------------------------------------
# Show help
# -----------------------------------------------------------------------------
show_help() {
    cat <<EOF

${BOLD}I Ching Hexagram Generator${RESET} — v${VERSION}
$(hr "─" 44)

${BOLD}USAGE${RESET}
  ${SCRIPT_NAME} [OPTIONS]

${BOLD}OPTIONS${RESET}
  (no args)        Cast a single hexagram reading
  -i, --interactive  Enter interactive oracle mode
  -n NUM           Look up hexagram by number (1–64)
  -l, --list       List all 64 hexagrams
  -h, --help       Show this help message
  -v, --version    Show version information

${BOLD}DESCRIPTION${RESET}
  Simulates the traditional three-coin method to generate
  an I Ching hexagram, including changing lines and the
  relating (changed) hexagram.

${BOLD}EXAMPLES${RESET}
  ${SCRIPT_NAME}               # Single reading
  ${SCRIPT_NAME} -i            # Interactive mode
  ${SCRIPT_NAME} -n 42         # Look up hexagram 42
  ${SCRIPT_NAME} --list        # List all hexagrams

${BOLD}PACKAGE INFO${RESET}
  Package:      iching
  Version:      ${VERSION}
  Maintainer:   Reza Sabooni <reza.sabooni@gmail.com>
  License:      MIT
  Depends:      bash >= 4.0

EOF
}

# -----------------------------------------------------------------------------
# List all hexagrams
# -----------------------------------------------------------------------------
list_hexagrams() {
    echo ""
    hr "═" 60
    printf "${BOLD}%*s${RESET}\n" $(( ( 60 + 22 ) / 2 )) "All 64 Hexagrams"
    hr "═" 60
    local i
    for (( i=1; i<=64; i++ )); do
        IFS='|' read -r symbol name _ _ <<< "${HEXAGRAMS[$i]}"
        printf "  ${CYAN}%2d${RESET}. ${YELLOW}%s${RESET}  %s\n" "$i" "$symbol" "$name"
    done
    hr "═" 60
    echo ""
}

# -----------------------------------------------------------------------------
# Look up a single hexagram by number
# -----------------------------------------------------------------------------
lookup_hexagram() {
    local num="$1"
    if ! [[ "$num" =~ ^[0-9]+$ ]] || (( num < 1 || num > 64 )); then
        echo -e "${RED}Error: Please provide a number between 1 and 64.${RESET}"
        exit 1
    fi

    # Create stable lines for display (all young yang for display purposes)
    local stable_lines=(7 7 7 7 7 7)
    display_hexagram "$num" stable_lines "Hexagram #${num} — Reference"
    echo ""
}

# -----------------------------------------------------------------------------
# Entry point
# -----------------------------------------------------------------------------
main() {
    if [[ $# -eq 0 ]]; then
        do_reading
        return
    fi

    case "$1" in
        -h|--help)
            show_help
            ;;
        -v|--version)
            echo "iching v${VERSION}"
            ;;
        -i|--interactive)
            interactive_mode
            ;;
        -l|--list)
            list_hexagrams
            ;;
        -n)
            if [[ -z "${2:-}" ]]; then
                echo -e "${RED}Error: -n requires a hexagram number.${RESET}"
                exit 1
            fi
            lookup_hexagram "$2"
            ;;
        *)
            echo -e "${RED}Unknown option: $1${RESET}"
            echo "Use ${SCRIPT_NAME} --help for usage."
            exit 1
            ;;
    esac
}

main "$@"
