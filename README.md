# I Ching Hexagram Generator

A simple I Ching hexagram generator written in Bash. This script generates a random hexagram by selecting from the 64 hexagrams of the I Ching, providing both the symbol and name of the hexagram.

## Features

- Generates a random I Ching hexagram.
- Displays the hexagram number, symbol, and name.
- Supports help and version options.

## Installation

To use this script, you need to have **Bash** installed on your system.

### 1. Clone the Repository

You can clone this repository to your local machine using Git:

```bash
git clone https://github.com/your-username/iching-package.git
cd iching-package
```

### 2. Run the Script Directly

The script does not require any installation. You can run it directly from the terminal.

```bash
chmod +x iching.sh
./iching.sh
```

### 3. Install the Debian Package

If you prefer, you can install the package as a `.deb` file (Debian/Ubuntu-based systems).

- Download the `.deb` package
- Install the package using `dpkg`:

```bash
sudo dpkg -i iching-package.deb
```
## Usage

### Generate a Random Hexagram

To generate a random I Ching hexagram, simply run the script:

```bash
./iching.sh
```

This will output a random hexagram number, its symbol, and its name.

Example output:

```
Hexagram Number: 9
Hexagram: ䷈ Small Taming
```

### Show Help Information

To display help information, use the `-h` or `--help` option:

```bash
./iching.sh -h
```

This will show detailed information about the script, including available options and package details.

### Show Version Information

To show the script version, use the `-v` or `--version` option:

```bash
./iching.sh -v
```

Example output:

```
iching version 1.0
```
# Usage Examples for Python Version of I Ching Hexagram Generator

## 1. Generate a Random Hexagram

To generate a random I Ching hexagram, simply run the Python script:

```bash
python3 iching.py
```
## 2. Show Help Information

To display help information, use the `-h` or `--help` option:

```bash
python3 iching.py -h
```

### Example Output:
```bash
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
```

## 3. Show Version Information

To show the script version, use the `-v` or `--version` option:

```bash
python3 iching.py -v
```

### Example Output:
```bash
iching version 1.0
```

## Package Information

This package contains the `iching` script as a `.deb` file.

- **Package**: iching
- **Version**: 1.0
- **Section**: utils
- **Priority**: optional
- **Architecture**: amd64
- **Depends**: bash
- **Maintainer**: Reza Sabooni <!--<reza.sabooni@gmail.com>-->
- **Description**: A simple I Ching hexagram generator in Bash.

## License

This project is licensed under the MIT License.

<!-- ## Author

- **Reza Sabooni** - [reza.sabooni@gmail.com](mailto:reza.sabooni@gmail.com)
-->
