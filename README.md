# 易 iching — I Ching Hexagram Generator

A Bash terminal oracle that simulates the traditional **three-coin method**
to generate I Ching hexagrams — complete with changing lines,
relating hexagrams, judgments, and images.

## Features

- 🪙 Authentic three-coin toss simulation (values 6–9)
- ☯ Changing lines with relating (transformed) hexagram
- 📖 Judgment & Image text for all 64 hexagrams
- 🔍 Look up any hexagram by number
- 📋 List all 64 hexagrams
- 🔄 Interactive oracle mode
- 🎨 Color terminal output

## Requirements

- Bash ≥ 4.0
- A UTF-8 capable terminal

## Installation

```bash
git clone https://github.com/yourname/iching.git
cd iching
chmod +x iching.sh
sudo cp iching.sh /usr/local/bin/iching
```

## Usage

```bash
iching                # Single reading
iching -i             # Interactive mode
iching -n 42          # Look up hexagram 42
iching --list         # List all 64 hexagrams
iching --help         # Help
iching --version      # Version
```

## Example Output

```
════════════════════════════════════════════════════════════
                      I CHING READING
  Monday, June 9, 2025 — 14:32 UTC
════════════════════════════════════════════════════════════
  Primary Hexagram
  Number:  42
  Symbol:  ䷩
  Name:    Increase

  Lines (top → bottom):
    Line 6: -------
    Line 5: --- o ---  (changing yang)
    Line 4: ---   ---
    Line 3: -------
    Line 2: -------
    Line 1: ---   ---
...

## License

MIT © Reza Sabooni
```
