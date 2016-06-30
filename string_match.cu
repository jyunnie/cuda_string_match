#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<cuda_gl_interop.h>
#define N 2048
#define Blocksize 16
#define TOTAL_LINES 50000
//#include "kernel_calculation.cu"

//cuda memory allocation
char *cuda_lines;
char *cuda_wholedb;
unsigned int obj_size = TOTAL_LINES * sizeof(char);
unsigned int wholedb = 1000000 * sizeof(char);
char *cuda_output;
//unsigned int 

char output[N*N];
//FILES
FILE *fp;
FILE *db;
FILE *result;
char *st[4096],*st_db[10000000];
char line[511];
char dbline[511];

void cuda_init();
void calculation();
void cleanup();

int main()
{
  cudaSetDevice(0);
  int i = 0;//
  int j= 0;

  fp=fopen("InputAnnotation.txt","r");
   if(fp != NULL)
    {
      char line[255];
      while(fgets(line,sizeof line,fp))
	{
	  st[i]=strdup(line);// seperated lines in st[]
	  i++;
	}
  fclose(fp);
  db=fopen("10mdbsnp.txt","r");
  if(db != NULL)
    {
      char line[255];
      while(fgets(dbline,sizeof dbline,db))
	{
	  st_db[j]=strdup(dbline);// seperated dblines in st_db[]
	  j++;
	}
  fclose(db)
  cuda_init();
  calculation();
  atexit(cleanup);
  cudaThreadExit();
  
  return 0;
}

void cuda_init(){
  int deviceCount;
  cudaGetDevice(&deviceCount);
  cudaMalloc((void**) &cuda_lines , obj_size);
  cudaMalloc((void**) &cuda_wholedb,wholedb);
  cudaMalloc((void**) &cuda_output,obj_size);
}

void calculation()
{
  int deviceCount;
  dim3 grid(4096);
  dim3 threads(256);
  
  cudaGetDevice(&deviceCount);
  cudaMemset(cuda_lines,0,obj_size);
  cudaMemset(cuda_wholedb,0,wholedb);
  cudaMemset(cuda_output,0,obj_size);
  cudaMemcpy(cuda_lines,st,obj_size,cudaMemcpyHostToDevice);
  cudaMemcpy(cuda_wholedb,st_db,wholedb,cudaMemcpyHostToDevice);

  string_match<<< grid,threads >>>(cuda_lines,cuda_wholedb,cuda_output);
 
  cudaMemcpy(output,cuda_output,obj_size,cudaMemcpyDeviceToHost);
  if((result = fopen("Output_Annotation.txt","wb")) == NULL){
      printf("FILE OPEN ERROR!! _WRITE");
      exit(1);
  }
  fwrite(output,sizeof(char),2048*2048),result);
 
  fclose(result);
}

void cleanup()
{
	printf("cleanup\n");
	//---------------------------------------------
	
	cudaFree(cuda_lines);
	cudaFree(cuda_wholedb);
	cudaFree(cudaoutput);
}

__global__ void calculation(const char *substr,int len,int substrlen)
{

  unsigned int x = blockIdx.x*blockDim.x + threadIdx.x;
  const* char s1 = s; //text in device memory;
  const* char s2 = substr;//input text
  unsigned int yes = 1;
  int curr_marker = 0;

  if((len - shft)<substrlen)
  {
	res[shft]=0;
	return;
   }
	//scan the text in device memory,attempt to match pattern
   for(int i=shft;curr_marker <= substrlen && i<len;curr_marker++,i++){
	if(s2[curr_marker] && (s2[curr_marker]!=s1[i])){
		yes = 0;
		break;
	}
    }

   if(yes==1)
	res[shft] = yes;
}









