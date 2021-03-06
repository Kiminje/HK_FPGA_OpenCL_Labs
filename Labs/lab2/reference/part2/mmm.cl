/*
Applied intermediate value optimisation




*/

__constant float w_r[] = {1,0.995183,0.98078,0.956929,0.92386,0.881891,0.831427,0.772954};


__constant float w_i[] = {0,-0.0980298,-0.195115,-0.290321,-0.38273,-0.471453,-0.555634,-0.634462};


__kernel void mmm(__global const float* restrict in_real, __global const float* restrict in_img, __global float* restrict out_real, __global float* restrict out_img, __global int* restrict N) {
	int n = *N;


    for (int gid = 0; gid < n; gid++){

    	


    	int g8 = gid *8;

	
		//here, declare the stage arrays		
		float stage0_r[8];
		float stage1_r[8];
    	float stage2_r[8];
   		float stage3_r [8];
    	

		float stage0_i[8];
    	float stage1_i[8];
    	float stage2_i[8];
    	float stage3_i [8];
    	


	     
    	for (int i =0; i <8; i++)
    	{
		 stage0_r[i]= in_real[g8 +i];
		stage0_i[i] = in_img[g8+i];
    	}

    	int L = 4;
    	int m = 1;
    	#pragma unroll
    	for (int base = 0; base < 4; base += 1) {
    	    int j = base/m;
	   
	    stage1_r[base+(j+0)*m] = stage0_r[base] + stage0_r[base+4];
		stage1_i[base+(j+0)*m] = stage0_i[base] + stage0_i[base+4];
	    	    
	    stage1_r[base+(j+1)*m] =w_r[j*4/L]*(stage0_r[base] - stage0_r[base+4]) - w_i[j*4/L]*(stage0_i[base] - stage0_i[base+4]);
	    stage1_i[base+(j+1)*m] =w_r[j*4/L]*(stage0_i[base] - stage0_i[base+4]) + w_i[j*4/L]*(stage0_r[base] - stage0_r[base+4]);
    	}


    	L = 2;
    	m = 2;
    	#pragma unroll
    	for (int base = 0; base < 4; base += 1) {
    	    int j = base/m;
	    
	   	stage2_r[base+(j+0)*m] = stage1_r[base] + stage1_r[base+4];
		stage2_i[base+(j+0)*m] = stage1_i[base] + stage1_i[base+4];
	    	    
	    stage2_r[base+(j+1)*m] =w_r[j*4/L]*(stage1_r[base] - stage1_r[base+4]) - w_i[j*4/L]*(stage1_i[base] - stage1_i[base+4]);
	    stage2_i[base+(j+1)*m] =w_r[j*4/L]*(stage1_i[base] - stage1_i[base+4]) + w_i[j*4/L]*(stage1_r[base] - stage1_r[base+4]);
    	}
 


    	L = 1;
    	m = 4;
    	#pragma unroll
    	for (int base = 0; base < 4; base += 1) {
    	    int j = base/m;
	    
	   stage3_r[base+(j+0)*m] = stage2_r[base] + stage2_r[base+4];
		stage3_i[base+(j+0)*m] = stage2_i[base] + stage2_i[base+4];
	    	    
	    stage3_r[base+(j+1)*m] =w_r[j*4/L]*(stage2_r[base] - stage2_r[base+4]) - w_i[j*4/L]*(stage2_i[base] - stage2_i[base+4]);
	    stage3_i[base+(j+1)*m] =w_r[j*4/L]*(stage2_i[base] - stage2_i[base+4]) + w_i[j*4/L]*(stage2_r[base] - stage2_r[base+4]);
    	}



    	for (int i =0; i <8; i++)
    	{
		out_real[g8+i] = stage3_r[i];
		out_img[g8+i] =  stage3_i[i];
    	}
    }
}
