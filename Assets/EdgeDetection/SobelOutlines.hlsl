#ifndef SOBEL_OUTLINES_INCLUDED
#define SOBEL_OUTLINES_INCLUDED

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

static float2 samplePoints[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 1),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

static float sobelXMatrix[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

static float sobelYMatrix[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

// Source: https://www.youtube.com/watch?v=RMt6DcaMxcE, modified to accept any texture and convert to grayscale before applying Sobel
void SobelEdgeDetect_float(float2 uv, UnityTexture2D blitSource, UnitySamplerState st, float thickness, out float sobel)
{
    float2 sobelValue = 0;

    [unroll] for (int i = 0; i < 9; i++)
    {
        float grayscale = dot(
            SAMPLE_TEXTURE2D(blitSource, st, uv + samplePoints[i] * thickness), float3(0.2126, 0.7152, 0.0722));
        sobelValue += grayscale * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    sobel = length(sobelValue);
}

static float blurMatrixSum = 159;
static float blurMatrix[25] = {
    2, 4, 5, 4, 2,
    4, 9, 12, 9, 4,
    5, 12, 15, 12, 5,
    4, 9, 12, 9, 4,
    2, 4, 5, 4, 2,
};

static float2 samplePoints5[25] = {
    float2(-2, -2), float2(-1, -2), float2(0, -2), float2(1, -2), float2(2, -2),
    float2(-2, -1), float2(-1, -1), float2(0, -1), float2(1, -1), float2(2, -1),
    float2(-2, 0),  float2(-1, 0),  float2(0, 0),  float2(1, 0),  float2(2, 0),
    float2(-2, 1),  float2(-1, 1),  float2(0, 1),  float2(1, 1),  float2(2, 1),
    float2(-2, 2),  float2(-1, 2),  float2(0, 2),  float2(1, 2),  float2(2, 2)
};
static float sobelXMatrix5[25] = {
    -1, -4, -6, -4, -1,
    -2, -8, -12, -8, -2,
     0,  0,  0,   0,  0,
     2,  8,  12,  8,  2,
     1,  4,  6,   4,  1
};

static float sobelYMatrix5[25] = {
    -1, -2,  0,  2,  1,
    -4, -8,  0,  8,  4,
    -6, -12,  0, 12,  6,
    -4, -8,  0,  8,  4,
    -1, -2,  0,  2,  1
};



void CannyEdgeDetect_float(float2 uv, UnityTexture2D blitSource, UnitySamplerState st, float thickness, out float sobel)
{
    float2 cannyValue = 0;
    [unroll] for (int i = 0; i < 25; i++)
    {
        float grayscale = dot(
            SAMPLE_TEXTURE2D(blitSource, st, uv + samplePoints5[i] * thickness), float3(0.2126, 0.7152, 0.0722));
        float grayscaleBlurred = grayscale * (blurMatrix[i] / blurMatrixSum);
        cannyValue += grayscaleBlurred;
    }

   

    sobel = cannyValue;
}

#endif
