#include <iostream>
#include <fstream>
#include <string>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/core.hpp>
#include "image.pb.h"

using image::Image;

typedef unsigned char byte;

byte *matToBytes(cv::Mat image) {
  // Copy cv::Mat.data to unsigned char array
  int size = image.total() * image.elemSize();
  byte *bytes = new byte[size];
  std::memcpy(bytes, image.data, size * sizeof(byte));
  return bytes;
}

int main(int argc, char** argv) {
  // Read image with alpha channel
  cv::Mat img = cv::imread(argv[1], cv::IMREAD_UNCHANGED);

  // Construct data string
  int width = img.cols;
  int height = img.rows;
  int channel = img.channels();
  int size = width * height * channel;
  byte *data = matToBytes(img);
  std::string data_str(reinterpret_cast<char const*>(data), size);

  std::cout << "Original image width  : " << width << std::endl;
  std::cout << "Original image height : " << height << std::endl;
  std::cout << "Original image channel: " << channel << std::endl;

  // Store into protobuf and serialize
  Image image;
  image.set_width(width);
  image.set_height(height);
  image.set_channel(channel);
  image.set_data(data_str);

  std::fstream outpb("out.pb", std::ios::out | std::ios::trunc | std::ios::binary);
  if (!image.SerializeToOstream(&outpb)) {
    std::cerr << "Failed to serialize to .pb" << std::endl;
    return -1;
  } else {
    std::cout << "Data dumped to out.pb." << std::endl;
    return 0;
  }
}
