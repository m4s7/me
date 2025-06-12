#!/bin/bash

# Create favicons with proper transparency and high quality
echo "Converting favicon.svg to PNG files..."

# Create high-quality PNGs with transparency
for size in 16 32 48 64 180 192 512; do
    echo "Creating ${size}x${size}..."
    convert \
        -density 600 \
        -background transparent \
        favicon.svg \
        -resize ${size}x${size} \
        -strip \
        -define png:format=png32 \
        favicon-${size}.png
done

# Move files to correct locations
mv favicon-16.png assets/favicon/favicon-16x16.png
mv favicon-32.png assets/favicon/favicon-32x32.png
mv favicon-48.png assets/favicon/favicon-48x48.png
mv favicon-64.png assets/favicon/favicon-64x64.png
mv favicon-180.png apple-touch-icon.png
mv favicon-192.png android-chrome-192x192.png
mv favicon-512.png android-chrome-512x512.png

# Create favicon.ico
convert assets/favicon/favicon-16x16.png \
        assets/favicon/favicon-32x32.png \
        assets/favicon/favicon-48x48.png \
        favicon.ico

echo "Done!"