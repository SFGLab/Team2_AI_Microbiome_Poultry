#!/usr/bin/env python3

import pandas as pd
import argparse

def parse_metadata(metadata_file, output_file):
    # Read metadata file
    metadata = pd.read_csv(metadata_file, sep=None, engine='python')  # auto-detect separator

    # Display basic info
    print("\nMetadata Summary:")
    print(metadata.info())
    print("\nFirst 5 rows:")
    print(metadata.head())

    # Example: Drop rows with missing SampleID
    metadata_clean = metadata.dropna(subset=['SampleID'])

    # Save cleaned metadata
    metadata_clean.to_csv(output_file, index=False)
    print(f"\nCleaned metadata saved to: {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Parse and clean microbiome metadata file.')
    parser.add_argument('-i', '--input', required=True, help='Input metadata file path (CSV/TSV).')
    parser.add_argument('-o', '--output', required=True, help='Output cleaned metadata file path.')

    args = parser.parse_args()
    parse_metadata(args.input, args.output)
