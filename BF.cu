#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define DATASIZE 1000000
FILE *fp;
FILE *db;
cudaError_t searchKeyword(unsigned int *result,unsigned  char **data,unsigned  char **keyword);
__global__ void searchKeywordKernel(unsigned int *result,unsigned char *data,unsigned  char *keyword)
{
 int i = threadIdx.x;
 // Detect the first matching character
 if (data[i] == keyword[0]) {
   // Loop through next keyword character
   for (int j=1; j<3; i++) {
     if (data[i+j] != keyword[j])
       break;
     else
     // Store the first matching character to the result list
       result[i] = 1;
   }
  }
}
int main()
{
 printf("Start\n");	
 unsigned char *line[DATASIZE];
 unsigned char *dbline[DATASIZE];
 char *datacp[DATASIZE];
 char *keywordcp[DATASIZE];
 //char data[DATASIZE];
 char *keyword[DATASIZE];
 unsigned int result[DATASIZE] = { 0 };
 // Set false value in result array
 memset(result, 0, DATASIZE);
 unsigned long i = 0;//
 unsigned long j= 0;
  
  fp=fopen("Taiwan_input.input","r");
  if(fp != NULL)
    {
      printf("reading input\n");
      while(fgets(line,sizeof(line),fp))
	{
	
	  strcpy(keyword[i],line);// seperated lines in st[]
	  i++;
	}
    }
  printf("complete!\n");
  fclose(fp);
  db=fopen("Taiwan_db.txt","r");

  if(db != NULL)
    {
      printf("reading db\n");
      while(fgets(dbline,sizeof(dbline),db))
	{
	  strcpy(datacp[j],dbline);// seperated dblines in st_db[]
	  j++;
	}
    }
  printf("complete!\n");
  fclose(db);
 // Generate input data
 
// Search keyword in parallel.
cudaError_t cudaStatus = searchKeyword(result, datacp, keywordcp);
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "addWithCuda failed!");
  return 1;
}
 
// Print out the string match result position
int total_matches = 0;
for (int i=0; i<DATASIZE; i++) {
  if (result[i] == 1) {
    printf("Character found at position % i\n", i);
    total_matches++;
  }
}
printf("Total matches = %d\n", total_matches);
// cudaDeviceReset must be called before exiting in order for profiling and
// tracing tools such as Parallel Nsight and Visual Profiler to show complete traces.
cudaStatus = cudaDeviceReset();
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "cudaDeviceReset failed!");
  return 1;
}
system("pause");
return 0;
 
}
// Helper function for using CUDA to search a list of characters in parallel.
cudaError_t searchKeyword(unsigned int *result,unsigned  char **data,unsigned char **keyword)
{
 unsigned char *dev_data = 0;
 unsigned char *dev_keyword = 0;
 unsigned int *dev_result = 0;
 cudaError_t cudaStatus;
 // Choose which GPU to run on, change this on a multi-GPU system.
 cudaStatus = cudaSetDevice(0);
 if (cudaStatus != cudaSuccess) {
   fprintf(stderr, "cudaSetDevice failed! Do you have a CUDA-capable GPU installed?");
   goto Error;
 }
 // Allocate GPU buffers for result set.
 cudaStatus = cudaMalloc((void**)&dev_result, DATASIZE * sizeof(unsigned int));
 if (cudaStatus != cudaSuccess) {
   fprintf(stderr, "cudaMalloc failed!");
   goto Error;
 }
 // Allocate GPU buffers for data set.
 cudaStatus = cudaMalloc((void**)&dev_data, DATASIZE * sizeof(unsigned char));
 if (cudaStatus != cudaSuccess) {
   fprintf(stderr, "cudaMalloc failed!");
   goto Error;
 }
// Allocate GPU buffers for keyword.
cudaStatus = cudaMalloc((void**)&dev_keyword, DATASIZE * sizeof(unsigned char));
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "cudaMalloc failed!");
  goto Error;
}
// Copy input data from host memory to GPU buffers.
cudaStatus = cudaMemcpy(dev_data, data, DATASIZE * sizeof(unsigned char), cudaMemcpyHostToDevice);
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "cudaMemcpy failed!");
  goto Error;
}
// Copy keyword from host memory to GPU buffers.
cudaStatus = cudaMemcpy(dev_keyword, keyword, DATASIZE * sizeof(unsigned char), cudaMemcpyHostToDevice);
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "cudaMemcpy failed!");
  goto Error;
}
// Launch a search keyword kernel on the GPU with one thread for each element.
searchKeywordKernel<<<1, DATASIZE>>>(dev_result, dev_data, dev_keyword);
// cudaDeviceSynchronize waits for the kernel to finish, and returns
// any errors encountered during the launch.
cudaStatus = cudaDeviceSynchronize();
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
  goto Error;
}
// Copy result from GPU buffer to host memory.
cudaStatus = cudaMemcpy(result, dev_result, DATASIZE * sizeof(int), cudaMemcpyDeviceToHost);
if (cudaStatus != cudaSuccess) {
  fprintf(stderr, "cudaMemcpy failed!");
  goto Error;
}
Error:
 cudaFree(dev_result);
 cudaFree(dev_data);
 cudaFree(dev_keyword);
 
 return cudaStatus;
 }
