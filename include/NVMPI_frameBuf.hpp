#pragma once
#include "nvUtils2NvBuf.h"

struct NVMPI_frameBuf
{
#ifdef WITH_NVUTILS
	NvBufSurface *dst_dma_surface = NULL;
#endif
	int dst_dma_fd = -1;
	unsigned long long timestamp = 0;
	
	//allocate DMA buffer
	bool alloc(NvBufferCreateParams& input_params);
	//destroy DMA buffer
	bool destroy();
};
