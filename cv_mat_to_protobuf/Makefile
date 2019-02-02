CXX = g++
CPPFLAGS += `pkg-config --cflags protobuf`
CXXFLAGS += -std=c++11
OCV_LIB_PATH = /root/workspace/third-party/opencv/lib
LDFLAGS += -L/usr/local/lib `pkg-config --libs protobuf`\
           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed\
           -ldl
LDFLAGS += -L$(OCV_LIB_PATH) -lopencv_core -lopencv_imgcodecs \
           -Wl,-rpath,$(OCV_LIB_PATH)
PROTOC = protoc

PROTOS_PATH = ./proto

vpath %.proto $(PROTOS_PATH)

all: serialize pyproto

serialize: image.pb.o serialize.o
	$(CXX) $^ $(LDFLAGS) -o $@

.PRECIOUS: %.pb.cc
%.pb.cc: %.proto
	$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<

pyproto: image.proto
	$(PROTOC) -I $(PROTOS_PATH) --python_out=. $<

clean:
	rm -f *.o *.pb.cc *.pb.h serialize image_pb2.py

