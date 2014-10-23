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

all: $(LIBSWIFT)

$(LIBSWIFT): $(CXXOBJS)
	$(CXX) -m64 -fPIC -DPIC -shared -Wl,-soname,$(LIBSWIFT) -o $@ $^ $(LIBS)
	#ar rcs $@ $^

install:
	mkdir -p $(DESTDIR)/libSwift/include/swift
	mkdir -p $(DESTDIR)/libSwift/lib
	mv -f $(LIBSWIFT) $(DESTDIR)/libSwift/lib
	cp -rf $(LIBSWIFTHEADERS) $(DESTDIR)/libSwift/include/swift

clean:
	rm -rf $(CXXOBJS) $(LIBSWIFT) $(wildcard build/*)
