#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "timerc.h"

#define THREADPERBLOCK 1024

__global__ void approximate_brute_force(char* text, char* pattern, int* match, int pattern_size, int text_size, int k) {
    int pid = threadIdx.x + blockIdx.x * blockDim.x;

    	if (pid <= text_size - pattern_size){
            int flag = 0; 
            for (int i = 0; i < pattern_size; i++){
                if (text[pid+i] != pattern[i]){
                        flag += 1;
			if(flag>k){
				flag=-1
				break;
			}
                }
            }
            match[pid] = flag;
	}
}

int main() {

    //GET THE WORD
    FILE* file_w = fopen("pattern.txt", "r");
    fseek(file_w, 0L, SEEK_END);
    int pattern_size = ftell(file_w);
    rewind(file_w);
    char* pattern = (char*)malloc(pattern_size * sizeof(char));
    fgets(pattern, pattern_size, file_w);
    fclose(file_w);
    pattern_size = strlen(pattern);

    //GET THE TEXT FILE
    FILE* file_s = fopen("text_string.txt", "r");
    fseek(file_s, 0L, SEEK_END);
    int size = ftell(file_s);
    rewind(file_s);
    char* text = (char*)malloc(size * sizeof(char));
    fgets(text, size, file_s);
    fclose(file_s);
    size = strlen(text);


    //CALCULATIONS FOR BLOCK AND THREAD NUMBERS
    int threadnumber = size - pattern_size + 1;
    int blocknumber = 1;
    if (threadnumber > THREADPERBLOCK) {
        blocknumber = (threadnumber / THREADPERBLOCK);
        if (threadnumber % THREADPERBLOCK != 0) {
            blocknumber++;
        }
        threadnumber = THREADPERBLOCK;
    }

    int k = 0;
    k = (pattern_size * 99)/100;

    //PRINT INFORMATION
    printf("Word to find: <%s> - is a placeholder\n", pattern);
    printf("Pattern length is:  %d, Text length is: %d\n", pattern_size, size);
    printf("\n");
    printf("Thread count: %d, Block count: %d\n", threadnumber, blocknumber);


    /*initialized match array*/
    int* match;
    match = (int*)malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        match[i] = -1;
    }

    float gpuTime0;
    float gpuTime;
    float gpuTime1;


    /* GPU init*/
    //text buffer in device
    char* dev_text;
    //pattern buffer in device
    char* dev_pattern;
    // match buffer in device
    int* dev_match;
    //output buffer in device
    int* dev_output;


    gstart();
    cudaMalloc((void**)&dev_text, size * sizeof(char));
    cudaMalloc((void**)&dev_pattern, pattern_size * sizeof(char));
    cudaMalloc((void**)&dev_match, size * sizeof(int));
    //cudaMalloc((void **)&dev_output, sizeof(int)*size);

    cudaMemcpy(dev_text, text, size * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_pattern, pattern, pattern_size * sizeof(char), cudaMemcpyHostToDevice);
    gend(&gpuTime0);

    gstart();

    approximate_brute_force << <number_of_blocks, THREADPERBLOCK >> > (dev_text, dev_pattern, dev_match, pattern_size, size, k);
    gend(&gpuTime);

    gstart();
    cudaMemcpy(match, dev_match, size * sizeof(int), cudaMemcpyDeviceToHost);

    gend(&gpuTime1);


    /*free memory*/
    cudaFree(dev_text);
    cudaFree(dev_pattern);
    cudaFree(dev_match);
    cudaFree(dev_output);

    free(text);
    free(pattern);
    free(match);

    printf("GPUTIME0: %f, GPUTIME: %f, GPUTIME1:%f", gpuTime0, gpuTime, gpuTime1);

}