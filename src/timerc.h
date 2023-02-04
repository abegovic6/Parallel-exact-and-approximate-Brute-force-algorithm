/* timerc.h
 * this files contains 
 *				timer header functions IMP
 * 	that can be compiled with nvcc without -std=c++11 flag
 */

		/* function prototype */

#ifndef TIMERC_P_H
#define TIMERC_P_H
#include <stdio.h>

inline void gstart();
inline void gend(float * gputime);

#endif

#ifndef TIMERC_H
#define TIMERC_H


//------------------------------------------------------------------------
//	GPU
//------------------------------------------------------------------------


static void _init();
static cudaEvent_t gpu_start, gpu_end;

//gstart
inline void gstart(){
	_init();
	cudaEventRecord(gpu_start, 0);
}

//gend
inline void gend(float * gputime){
	cudaEventRecord(gpu_end, 0);
	cudaEventSynchronize(gpu_end);
	cudaEventElapsedTime(gputime, gpu_start, gpu_end);
}

static int init = 0;
static void _init()
{
	if(!init){
		cudaEventCreate(&gpu_start);
		cudaEventCreate(&gpu_end);
		init = 1;
	}
}

#endif
