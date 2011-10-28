CXX ?= g++
SWIG ?= swig

UNAME := $(shell uname)
# running ruby -e 'print $:[-2]' to get the ruby.h location
RUBY_INCLUDEDIR := $(shell ruby -e 'print $$:[-2]')

ifeq ($(UNAME), Linux)
LDFLAGS = -shared
EXT = so
endif
ifeq ($(UNAME), Darwin)
LDFLAGS = -framework Ruby -bundle
EXT = bundle
endif
#Windows: see ../README ../Makefile.win

ifdef EXT
CFLAGS = -O3 -I$(RUBY_INCLUDEDIR) -I..

all: liblinear.$(EXT)

else

all: ; @echo "Only Linux and OS X are supported, please add your OS in Makefile"

endif

liblinear.$(EXT): liblinear_wrap.o linear.o
	$(CXX) $(LDFLAGS) -o liblinear.$(EXT) liblinear_wrap.o linear.o ../tron.o ../blas/blas.a

liblinear_wrap.o: liblinear_wrap.c ../linear.h
	$(CXX) $(CFLAGS) -fPIC -c liblinear_wrap.cxx

liblinear_wrap.c: liblinear.i
	$(SWIG) -ruby -c++ liblinear.i

linear.o: ../linear.cpp ../linear.h
	$(CXX) $(CFLAGS) -fPIC -c ../linear.cpp

clean:
	rm -f *~ *.o *.so linear.o *.bundle

moreclean:	clean
	rm -f liblinear_wrap.c??
