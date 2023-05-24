#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
// Enable mipmapping
#pragma multi_compile USE_LOD

void CheapBlur_float(float2 uv, UnityTexture2D blitSource, UnitySamplerState st,out float3 color)
{
    color = SAMPLE_TEXTURE2D_GRAD(blitSource, st, uv,ddx(uv)* 0.1f, ddy(uv)* 0.1f);
}
