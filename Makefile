.PYONY:clean
cc = nvcc
CFLAGS = -g -I ./inc -I. -std=c++11 -rdc=true -arch=sm_52#头文件
LIBO = -lpthread -lm -lboost_system -lboost_thread	#链接
BIN = main
SUBDIR = $(shell ls -d */)  
ROOTSRC = $(wildcard *.cu)     
ROOTOBJ = $(ROOTSRC:%.c=%.o)
SUBSRC = $(shell find $(SUBDIR) -name '*.cu')
SUBOBJ = $(SUBSRC:%.c=%.o)
 
$(BIN):$(ROOTOBJ) $(SUBOBJ)
		$(cc) $(CFLAGS) -o $(BIN) $(ROOTOBJ)  $(SUBOBJ) $(LIBO)
 $(SUBOBJ).c.o:
	 $(cc) $(CFLAGS) -c $< -o $@
 
clean:
	  rm -f $(BIN) $(ROOTOBJ) $(SUBOBJ) 



