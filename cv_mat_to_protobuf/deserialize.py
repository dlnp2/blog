import sys
import numpy as np
import cv2
import image_pb2


def main(pbpath):
    with open(pbpath, "rb") as pb:
        image = image_pb2.Image()
        image.ParseFromString(pb.read())
    w = image.width
    h = image.height
    c = image.channel
    print("Deserialized image width  :", w)
    print("Deserialized image height :", h)
    print("Deserialized image channel:", c)
    data = image.data
    img_np = np.frombuffer(data, np.uint8)
    img_np = img_np.reshape(h, w, c)
    cv2.imwrite("deserialized.png", img_np)
    print("Deserialized image dumped to deserialized.png.")


if __name__ == "__main__":
    main(sys.argv[1])

