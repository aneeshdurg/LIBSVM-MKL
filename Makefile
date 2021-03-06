CXX ?= g++
CFLAGS = -m32 -Wall -Wconversion -O3 -fPIC
LIBFLAGS = -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm
SHVER = 2
OS = $(shell uname)

all: svm-train 

threaded:
	make -f Makefile.threaded 

lib: svm.o
	if [ "$(OS)" = "Darwin" ]; then \
		SHARED_LIB_FLAG="-dynamiclib -Wl,-install_name,libsvm.so.$(SHVER)"; \
	else \
		SHARED_LIB_FLAG="-shared -Wl,-soname,libsvm.so.$(SHVER)"; \
	fi; \
	$(CXX) $${SHARED_LIB_FLAG} svm.o -o libsvm.so.$(SHVER)

svm-train: svm-train.c svm.o
	$(CXX) $(CFLAGS) svm-train.c svm.o -o svm-train -Wno-float-conversion $(LIBFLAGS)

svm.o: svm.cpp svm.h
	$(CXX) $(CFLAGS) -c svm.cpp -U_GNU_SOURCE

clean:
	rm -f *~ *.o svm-train libsvm.so.$(SHVER)
