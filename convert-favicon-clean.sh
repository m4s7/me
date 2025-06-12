#!/bin/bash

# Clean favicon conversion without anti-aliasing artifacts
echo "Creating clean transparent favicon files..."

# Clean up
rm -f favicon-*.png temp-*.png

# For each size, create PNG with proper transparency and no artifacts
for size in 16 32 48 64 180 192 512; do
    echo "Creating clean ${size}x${size}..."
    
    # Convert directly with transparent background and no anti-aliasing against white
    convert \
        -density 300 \
        -background transparent \
        -compose over \
        favicon.svg \
        -resize ${size}x${size} \
        -alpha on \
        -colors 256 \
        PNG32:favicon-${size}.png
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

echo "Clean favicon files created!"

# Check one file to see if it looks correct
echo "Sample file info:"
identify -verbose assets/favicon/favicon-32x32.png | grep -E "(Background|Alpha|Colorspace)"