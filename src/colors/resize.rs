use image::EncodableLayout;
use image::{codecs::jpeg::JpegEncoder, io::Reader, ColorType, ImageEncoder};
use std::fs::File;
use std::{
    io::{BufWriter, Write},
    num::NonZeroU32,
};

pub fn resize() {
    let img = Reader::open("file.jpg").unwrap().decode().unwrap();

    let width = NonZeroU32::new(img.width()).unwrap();
    let height = NonZeroU32::new(img.height()).unwrap();

    let mut src_image = fast_image_resize::Image::from_vec_u8(
        width,
        height,
        img.to_rgba8().into_raw(),
        fast_image_resize::PixelType::U8x4,
    )
    .unwrap();

    let alpha_mul_div = fast_image_resize::MulDiv::default();
    alpha_mul_div
        .multiply_alpha_inplace(&mut src_image.view_mut())
        .unwrap();

    let dst_width = NonZeroU32::new(4).unwrap();
    let dst_height = NonZeroU32::new(8).unwrap();

    let mut dst_image =
        fast_image_resize::Image::new(dst_width, dst_height, src_image.pixel_type());

    let mut dst_view = dst_image.view_mut();

    let mut resizer = fast_image_resize::Resizer::new(fast_image_resize::ResizeAlg::Convolution(
        fast_image_resize::FilterType::Lanczos3,
    ));

    resizer.resize(&src_image.view(), &mut dst_view).unwrap();

    alpha_mul_div.divide_alpha_inplace(&mut dst_view).unwrap();

    let mut result_buf = BufWriter::new(Vec::new());

    JpegEncoder::new(&mut result_buf)
        .write_image(
            dst_image.buffer(),
            dst_width.get(),
            dst_height.get(),
            ColorType::Rgba8,
        )
        .unwrap();

    let result_img = File::create("test.jpg").expect("Unable to create a file");

    let mut result_img_buf = BufWriter::new(result_img);

    result_img_buf
        .write_all(result_buf.buffer().as_bytes())
        .expect("Unable to write data");

    println!("Buf length: {}", result_buf.buffer().len());

    for buf in result_buf.buffer() {
        println!("{}", buf);
    }
}
