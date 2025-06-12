#!/bin/bash

# High-quality favicon conversion with guaranteed transparency
echo "Converting favicon.svg to PNG files with transparent backgrounds..."

# Clean up existing files
rm -f favicon-*.png temp-*.png

# Generate different sizes directly with transparency
for size in 16 32 48 64 180 192 512; do
    echo "Creating ${size}x${size} with transparency..."
    
    # Method 1: Direct conversion with explicit transparency
    convert \
        -background none \
        -size ${size}x${size} \
        favicon.svg \
        -alpha set \
        -channel RGBA \
        PNG32:favicon-${size}.png
    
    # Verify transparency and fix if needed
    convert favicon-${size}.png \
        -alpha extract \
        temp-alpha-${size}.png
    
    # If alpha channel exists, use it, otherwise create transparent version
    if [ -f temp-alpha-${size}.png ]; then
        convert \
            \( favicon-${size}.png -alpha off \) \
            \( temp-alpha-${size}.png \) \
            -alpha off -compose copy_opacity -composite \
            PNG32:favicon-${size}.png
    fi
    
    # Clean up temp files
    rm -f temp-alpha-${size}.png
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

# Create favicon.ico (ICO format doesn't support transparency well, but we'll try)
convert \
    assets/favicon/favicon-16x16.png \
    assets/favicon/favicon-32x32.png \
    assets/favicon/favicon-48x48.png \
    -background transparent \
    favicon.ico

echo "Transparent favicon conversion complete!"

# Verify transparency in generated files
echo "Verifying transparency..."
for file in assets/favicon/favicon-32x32.png apple-touch-icon.png android-chrome-192x192.png; do
    if [ -f "$file" ]; then
        echo "File: $file"
        identify -format "Format: %m, Alpha: %A, Channels: %[channels]\n" "$file"
    fi
done