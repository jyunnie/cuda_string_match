PROGRAM = a.out

LIBDIRS = -L/usr/local/cuda/samples/common/lib/linux/x86_64 -I/usr/local/cuda/include -I/usr/local/cuda/samples/common/inc
LLDLIBS = -lglut -lGLEW -lGLU -lGL -lm 


CC      = nvcc  -m64 -arch=sm_20
SOURCES = string_match.cu
OBJECTS = $(SOURCES:.c=.o)

all: $(PROGRAM)

$(PROGRAM): $(OBJECTS)
	$(CC) $(FLAGS) -o $(PROGRAM) $(OBJECTS) $(LIBDIRS) $(LLDLIBS)


