use actix_web::{
    web::{self, Bytes},
    App, Error, HttpResponse, HttpServer,
};
use image::{DynamicImage, GenericImageView};

async fn upload_image(payload: Bytes) -> Result<HttpResponse, Error> {
    if payload.is_empty() {
        return Ok(HttpResponse::BadRequest().body("No image uploaded"));
    }
    let image = image::load_from_memory(&payload).expect("Error loading from memory");
    let resized_image = resize_image(image, 64, 64);
    let rgb_values = get_rgb_values(&resized_image);
    return Ok(HttpResponse::Ok().body(format!("{:?}", rgb_values)));
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

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new().service(web::resource("/upload").route(web::post().to(upload_image)))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
