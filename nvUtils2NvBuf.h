#if defined(WITH_NVUTILS)
#include "nvbufsurface.h"
#include "nvbufsurftransform.h"
#include "NvBufSurface.h"
#define MAX_NUM_PLANES NVBUF_MAX_PLANES
#define NvBufferDestroy NvBufSurf::NvDestroy
#define NvBufferCreateParams NvBufSurf::NvCommonAllocateParams
#define NvBufferColorFormat_NV12 NVBUF_COLOR_FORMAT_NV12
#define NvBufferColorFormat_NV12_ER NVBUF_COLOR_FORMAT_NV12_ER
#define NvBufferColorFormat_NV12_709 NVBUF_COLOR_FORMAT_NV12_709
#define NvBufferColorFormat_NV12_709_ER NVBUF_COLOR_FORMAT_NV12_709_ER
#define NvBufferColorFormat_NV12_2020 NVBUF_COLOR_FORMAT_NV12_2020
#define NvBufferColorFormat_YUV420 NVBUF_COLOR_FORMAT_YUV420
//#define NvBufferColorFormat_ABGR32 NVBUF_COLOR_FORMAT_BGRA
//NVBUF_COLOR_FORMAT_BGR - BGR-8-8-8 single plane. /nvbufsurface API only/
//NVBUF_COLOR_FORMAT_B8_G8_R8 -  BGR- unsigned 8-bit multiplanar plane. /nvbufsurface API only/
#define NvBufferLayout_Pitch NVBUF_LAYOUT_PITCH
#define NvBufferLayout_BlockLinear NVBUF_LAYOUT_BLOCK_LINEAR
#define NvBufferTransformParams NvBufSurfTransformParams
#define NvBufferRect NvBufSurfTransformRect
#define NVBUFFER_TRANSFORM_FILTER NVBUFSURF_TRANSFORM_FILTER
#define NvBufferTransform_None NvBufSurfTransform_None
#define NvBufferTransform_Filter_Smart NvBufSurfTransformInter_Algo3
#define NvBufferTransform_Filter_Nearest NvBufSurfTransformInter_Nearest
#define NvBufferParams NvBufSurfTransform
#define NvBufferColorFormat NvBufSurfaceColorFormat

//#define NvBuffer2Raw(dmabuf, plane, out_width, out_height, ptr)
#else
#include "nvbuf_utils.h"
#endif
