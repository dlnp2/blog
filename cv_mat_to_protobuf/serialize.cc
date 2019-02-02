#include <iostream>
#include <fstream>
#include <string>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/core.hpp>
#include "image.pb.h"

using image::Image;

int main(int argc, char** argv) {
  // Read image with alpha channel
  cv::Mat img = cv::imread(argv[1], cv::IMREAD_UNCHANGED);

  // Construct data string
  int width = img.cols;
  int height = img.rows;
  int channel = img.channels();
  int size = width * height * channel;
  std::string data_str(reinterpret_cast<char const*>(img.data), size);

  std::cout << "Original image width  : " << width << std::endl;
  std::cout << "Original image height : " << height << std::endl;
  std::cout << "Original image channel: " << channel << std::endl;

  // Store into protobuf
  Image image;
  image.set_width(width);
  image.set_height(height);
  image.set_channel(channel);
  image.set_data(data_str);

  // Serialize to .pb
  std::fstream outpb("out.pb", std::ios::out | std::ios::trunc | std::ios::binary);
  if (!image.SerializeToOstream(&outpb)) {
    std::cerr << "Failed to serialize." << std::endl;
    return -1;
  } else {
    std::cout << "Data dumped to out.pb." << std::endl;
    return 0;
  }
}
