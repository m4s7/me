#!/bin/bash

# High-quality favicon conversion with proper transparency
echo "Converting favicon.svg to high-quality PNG files..."

# Clean up existing files
rm -f favicon-*.png

# Create temporary high-resolution base
echo "Creating high-resolution base..."
convert \
    -size 1024x1024 \
    xc:transparent \
    -density 1200 \
    \( favicon.svg -resize 1024x1024 \) \
    -composite \
    temp-base.png

# Generate different sizes from the high-res base
for size in 16 32 48 64 180 192 512; do
    echo "Creating ${size}x${size}..."
    convert temp-base.png \
        -resize ${size}x${size} \
        -alpha on \
        -background transparent \
        -define png:format=png32 \
        favicon-${size}.png
done

# Clean up temporary file
rm -f temp-base.png

# Move files to correct locations
mkdir -p assets/favicon/
mv favicon-16.png assets/favicon/favicon-16x16.png
mv favicon-32.png assets/favicon/favicon-32x32.png
mv favicon-48.png assets/favicon/favicon-48x48.png
mv favicon-64.png assets/favicon/favicon-64x64.png
mv favicon-180.png apple-touch-icon.png
mv favicon-192.png android-chrome-192x192.png
mv favicon-512.png android-chrome-512x512.png

# Create favicon.ico from multiple sizes
convert \
    assets/favicon/favicon-16x16.png \
    assets/favicon/favicon-32x32.png \
    assets/favicon/favicon-48x48.png \
    favicon.ico

echo "High-quality favicon conversion complete!"
echo "Files created:"
echo "  - favicon.ico"
echo "  - apple-touch-icon.png"
echo "  - android-chrome-192x192.png"
echo "  - android-chrome-512x512.png"
echo "  - assets/favicon/favicon-16x16.png"
echo "  - assets/favicon/favicon-32x32.png"
echo "  - assets/favicon/favicon-48x48.png"
echo "  - assets/favicon/favicon-64x64.png"