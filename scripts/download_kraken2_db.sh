#!/bin/bash

# Directory for databases
DB_DIR="/home/biftrain10/PRJNA947933/databases"
cd $DB_DIR

# Download Kraken2 standard database
kraken2-build --standard --db kraken2-db

# Install Bracken database (this depends on Kraken2 database)
bracken-build -d kraken2-db -t 8 -k 35 -l 150

echo "✅ Kraken2 and Bracken databases downloaded and built."

