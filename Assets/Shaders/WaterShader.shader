Shader "GPU Gems/Water"
{
    Properties
    {

    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalRenderPipeline"
        }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex VSMain
            #pragma fragment PSMain
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"    

            struct VSInput
            {
                float4 PositionOS : POSITION;
            };

            struct PSInput 
            {
                float4 PositionCS : SV_POSITION;
            };

            PSInput VSMain(VSInput input)
            {
                PSInput output;

                output.PositionCS = TransformObjectToHClip(input.PositionOS.xyz);

                return output;
            }

            float4 PSMain(PSInput input) : SV_TARGET
            {
                return float4(1, 1, 1, 1);
            }

            ENDHLSL
        }
    }
}