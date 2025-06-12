#!/bin/bash

# Final attempt at transparent favicons using color replacement
echo "Creating truly transparent favicon files..."

# Clean up
rm -f favicon-*.png temp-*.png

# For each size, create PNG with white background removed
for size in 16 32 48 64 180 192 512; do
    echo "Creating transparent ${size}x${size}..."
    
    # Step 1: Convert SVG to PNG with white background
    convert \
        -size ${size}x${size} \
        -background white \
        favicon.svg \
        temp-white-${size}.png
    
    # Step 2: Make white pixels transparent
    convert temp-white-${size}.png \
        -fuzz 1% \
        -transparent white \
        favicon-${size}.png
    
    # Clean up temp file
    rm -f temp-white-${size}.png
done

# Move files to correct locations
mkdir -p assets/favicon/
mv favicon-16.png assets/favicon/favicon-16x16.png
mv favicon-32.png assets/favicon/favicon-32x32.png  
mv favicon-48.png assets/favicon/favicon-48x48.png
mv favicon-64.png assets/favicon/favicon-64x64.png
mv favicon-180.png apple-touch-icon.png
mv favicon-192.png android-chrome-192x192.png
mv favicon-512.png android-chrome-512x512.png

# Create favicon.ico
convert \
    assets/favicon/favicon-16x16.png \
    assets/favicon/favicon-32x32.png \
    assets/favicon/favicon-48x48.png \
    favicon.ico

echo "Transparent favicon files created!"
echo "White backgrounds should now be completely removed."