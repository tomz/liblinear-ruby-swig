CXX? = g++
SWIG ?= swig

#Windows: see ../README ../Makefile.win
RUBY_INCLUDEDIR ?= /usr/local/lib/ruby/1.8/x86_64-linux 

CFLAGS = -O3 -I$(RUBY_INCLUDEDIR) -I..
LDFLAGS = -shared
# Mac OS
# LDFLAGS = -framework Ruby -bundle

all: liblinear.so

liblinear.so: liblinear_wrap.o linear.o
	$(CXX) $(LDFLAGS) -o liblinear.so liblinear_wrap.o linear.o ../tron.o ../blas/blas.a

liblinear_wrap.o: liblinear_wrap.c ../linear.h
	$(CXX) $(CFLAGS) -fPIC -c liblinear_wrap.cxx

liblinear_wrap.c: liblinear.i
	$(SWIG) -ruby -c++ liblinear.i

linear.o: ../linear.cpp ../linear.h
	$(CXX) $(CFLAGS) -fPIC -c ../linear.cpp

clean:
	rm -f *~ *.o *.so linear.o

moreclean:	clean
	rm -f liblinear_wrap.c??
