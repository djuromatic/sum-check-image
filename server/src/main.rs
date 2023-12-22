use actix_web::{post, web::Bytes, Error, HttpResponse, Responder};
use image::{DynamicImage, GenericImageView};
use serde::Serialize;

#[derive(Serialize, Debug)]
struct ImageData {
    a: Vec<u8>,
    length: usize,
}

#[post("/upload")]
async fn index(payload: Bytes) -> Result<impl Responder, Error> {
    if payload.is_empty() {
        return Ok(HttpResponse::BadRequest().body("No image uploaded"));
    }
    let image = image::load_from_memory(&payload).expect("Error loading from memory");
    let resized_image = resize_image(image, 64, 64);
    let rgb_values = get_rgb_values(&resized_image);
    let data = ImageData {
        a: rgb_values.clone(),
        length: rgb_values.len(),
    };
    Ok(HttpResponse::Ok().body(format!("{:?}", data)))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    use actix_web::{App, HttpServer};

    HttpServer::new(|| App::new().service(index))
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}

fn resize_image(image: DynamicImage, width: u32, height: u32) -> DynamicImage {
    image.resize(width, height, image::imageops::FilterType::Triangle)
}

fn get_rgb_values(image: &DynamicImage) -> Vec<u8> {
    let mut rgb_values = Vec::new();

    for (_, _, pixel) in image.pixels() {
        rgb_values.push(pixel[0]);
        rgb_values.push(pixel[1]);
        rgb_values.push(pixel[2]);
    }

    rgb_values
}
