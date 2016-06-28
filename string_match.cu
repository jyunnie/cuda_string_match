include<stdio.h>
#include<stdlib.h>
#define N 2048
#define Blocksize 16



int main()
{
  FILE *fp;
  int i,*input_file_index;
  char ch;
  
  fp=fopen("InputAnnotation.txt","r");
  while(!feof(fp))
    {
      ch = fgetc(fp);
      if(ch == '\n')
	{
	  i++;
	}
    }
  input_file_index = (int *)malloc(sizeof(i));
  
}

/*void fgetdata()
{
  //sprintf(FILENAME,"%s%.3d%s",__FILENAME, FILE_NUM, FILETYPE);
  
  if ((fp = fopen(FILENAME, "rb")) == NULL) {
    puts(FILENAME);
    puts("file open error!!");
  }
  
  fread(DATA_NUM, sizeof(int), 1, fp);
  printf("FILENAME: %s, DATA_NUM[0]: %d\n",FILENAME,DATA_NUM[0]);	
  fread(st, sizeof(int), DATA_NUM[0] * 6, fp); 
  for(int j=0; j<=DATA_NUM[0]*6;j++)
    {
      chr[j] = st[j*6];
      start[j] = st[j*6+1];
      end[j]= st[j*6+2];
      ref[j] = st[j*6+3];
      alt[j] = st[j*6+4];
    }	
  fclose(fp);
  
  }*/

void memory_init(int lines){
  int deviceCount;
  cudaGetDevice(&deviceCount);
  cudaMalloc((void**) &d_row);
  cudaMalloc((void**) &d_T);
}

void calculation()
{
  int deviceCount;
  dim3 grid();
  dim3 threads();
  fgetdata();
  cudaGetDevice(&deviceCount);
  cudaMemset();
  cudaMemcpy(cudaMemcpyHostToDevice);
  string_match<<< grid,threads >>>(parameters);
 
  cudaMemcpy(cudaMemcpyDeviceToHost);
  sprintf(FILENAME,write);
  fwrite();
  fp=fopen();
  fclose(fp);
}

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
