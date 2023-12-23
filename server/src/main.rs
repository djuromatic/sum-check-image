use actix_cors::Cors;
use actix_web::{get, http::header, post, web::Bytes, Error, HttpResponse, Responder};
use image::{DynamicImage, GenericImageView};
use serde::Serialize;
use std::env;

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

#[get("/health")]
async fn health() -> Result<impl Responder, Error> {
    println!("Healthy and wealthy");
    Ok(HttpResponse::Ok().body(format!("Healthy and wealthy")))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    use actix_web::{App, HttpServer};

    let args: Vec<String> = env::args().collect();
    let port_number: u16 = args[1].parse().expect("Not a number");
    println!("Port number is {}", port_number);
    HttpServer::new(|| {
        let cors = Cors::default()
            .allow_any_origin()
            .allowed_methods(vec!["GET", "POST"])
            .allowed_headers(vec![
                header::AUTHORIZATION,
                header::ACCEPT,
                header::CONTENT_TYPE,
            ])
            .max_age(3600);

        App::new().wrap(cors).service(index).service(health)
    })
    .bind(("127.0.0.1", port_number))?
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
