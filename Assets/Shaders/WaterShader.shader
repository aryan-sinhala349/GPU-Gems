Shader "GPU Gems/Water"
{
    Properties
    {
        _NumDivisions("Plane Divisions", Integer) = 4
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
            #pragma geometry GSMain
            #pragma fragment PSMain
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"    

            int _NumDivisions;

            struct VSInput
            {
                float4 PositionOS : POSITION;
            };

            struct GSInput
            {
                float3 PositionOS : COLOR;
            };

            struct PSInput 
            {
                float4 PositionCS : SV_POSITION;

                float Height : TEXCOORD0;
            };

            GSInput VSMain(VSInput input)
            {
                GSInput output;

                output.PositionOS = input.PositionOS.xyz;

                return output;
            }

            [maxvertexcount(204)]
            void GSMain(triangle GSInput input[3], inout TriangleStream<PSInput> triStream)
            {
            	float3 v0 = input[0].PositionOS;
                float3 v1 = input[1].PositionOS;
                float3 v2 = input[2].PositionOS;

                float dx = abs(v0.x - v2.x) / _NumDivisions;
                float dz = abs(v0.z - v1.z) / _NumDivisions;

                float x = v0.x - dx * (_NumDivisions - 1);
                float z = v0.z - dz * (_NumDivisions - 1);

                float3 offsets[4] =
                {
                    float3(-dx,  0,  -dz),
                    float3(-dx,  0,    0),
                    float3(  0,  0,  -dz),
                    float3(  0,  0,    0),
                };

                for (int i = 0; i < _NumDivisions * _NumDivisions; i++)
                {
                    for (int j = 0; j < 4; j++)
                    {
                        float3 objectPos = float3(x, 0, z) + offsets[j];
                        float3 worldPos = TransformObjectToWorld(objectPos);

                        worldPos.y = sin(worldPos.x * worldPos.x + worldPos.z * worldPos.z);

                        PSInput output;

                        output.PositionCS = TransformWorldToHClip(worldPos);
                        output.Height = (worldPos.y + 1) / 2;

                        triStream.Append(output);
                    }

                    triStream.RestartStrip();

                    x += dx;

                    if ((i + 1) % _NumDivisions == 0)
                    {
                        x = v0.x - dx * (_NumDivisions - 1);
                        z += dz;
                    }
                }
            }

            float4 PSMain(PSInput input) : SV_TARGET
            {
                return float4(input.Height, input.Height, input.Height, 1);
            }

            ENDHLSL
        }
    }
}