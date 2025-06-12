#!/bin/bash

# Perfect transparent favicon conversion
echo "Creating perfectly transparent favicon files..."

# Clean up
rm -f favicon-*.png temp-*.png

# For each size, create completely transparent PNG
for size in 16 32 48 64 180 192 512; do
    echo "Creating transparent ${size}x${size}..."
    
    # Create a transparent canvas first, then composite the SVG onto it
    convert \
        -size ${size}x${size} \
        canvas:transparent \
        \( -density 300 -background transparent favicon.svg -resize ${size}x${size} \) \
        -gravity center \
        -composite \
        PNG32:favicon-${size}.png
        
    # Remove any potential background color info
    convert favicon-${size}.png \
        -background transparent \
        -alpha background \
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

echo "Perfect transparent favicon files created!"

# Verify the transparency
echo "Checking transparency in 32x32 file:"
identify -format "Matte: %A, Background: %[background]\n" assets/favicon/favicon-32x32.png