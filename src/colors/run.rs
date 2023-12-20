extern crate image;

use image::{GenericImageView, Pixel};

pub fn main() {
    // Open an image file
    let img_path = "file.jpg";
    let img = image::open(img_path).expect("Failed to open image");

    // Get dimensions of the image
    let (width, height) = img.dimensions();

    println!("Image Dimensions: {} x {}", width, height);

    // Create a vector to store RGB values
    let mut rgb_values: Vec<[u8; 3]> = Vec::new();

    // Iterate over each pixel in the image
    for y in 0..height {
        for x in 0..width {
            // Get the RGB values of the pixel at (x, y)
            let pixel = img.get_pixel(x, y);
            let rgb = pixel.channels();

            // Push the RGB values to the vector
            rgb_values.push([rgb[0], rgb[1], rgb[2]]);
        }
    }

    println!("pixel number {:?}", rgb_values.len());

    // Print the RGB values for the first few pixels
    for i in 0..10 {
        println!("Pixel {}: {:?}", i + 1, rgb_values[i]);
    }
}
