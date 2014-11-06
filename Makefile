DESTDIR ?= build

CXXFLAGS = -ggdb -g -Wall -fmessage-length=0 -std=c++11
CXXFLAGS += -m64 -fPIC -DPIC

SWIFT=$(wildcard interface/*.cpp io/*.cpp model/*.cpp header/*.cpp)

LIBSWIFTHEADERS=$(wildcard interface/*.h io/*.h model/*.h header/*.h)
TEST=test.cpp
CXXSOURCES=$(SWIFT)
TESTSOURCES=$(TEST)

CXXOBJS=$(CXXSOURCES:%.cpp=%.o)
TESTOBJS=$(TESTSOURCES:%.cpp=%.o)

#Includes
LFLAGS=-I/usr/include/jsoncpp -Iheader -Iinterface -Iio -Imodel
CXXFLAGS+= $(LFLAGS)

LIBS = -lPocoUtil -lPocoXML -lPocoNet -lPocoFoundation -lPocoXML -ljsoncpp -lpthread

LIBSWIFT = libSwift.so.0.1
LIBSWIFT_SO = libSwift.so

all: $(LIBSWIFT)

$(LIBSWIFT): $(CXXOBJS)
	$(CXX) -m64 -fPIC -DPIC -shared -Wl,-soname,$(LIBSWIFT) -o $@ $^ $(LIBS)

install:
	mkdir -p $(DESTDIR)/usr/lib
	mv -f $(LIBSWIFT) $(DESTDIR)/usr/lib
	(cd $(DESTDIR)/usr/lib; ln -s -f $(LIBSWIFT) $(LIBSWIFT_SO))
	mkdir -p $(DESTDIR)/usr/include/swift
	cp -rf $(LIBSWIFTHEADERS) $(DESTDIR)/usr/include/swift

clean:
	rm -rf $(CXXOBJS) $(LIBSWIFT) $(wildcard build/*)
