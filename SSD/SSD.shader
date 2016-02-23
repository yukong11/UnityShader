Shader "Effect_Mid/SSD"
{
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"= "Transparent" "Queue" = "Transparent" }
		Pass{
		Zwrite off
		Lighting Off
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		uniform sampler2D _MainTex;
		uniform sampler2D _CameraDepthTexture;
		uniform float4x4 _invMVP;
		float4 _MainTex_ST;
		struct VSInput {
			float4 vertex : POSITION;
		};

		struct VSOut{
		  float4 position :SV_POSITION;
		  float4 ScreenPos : TEXCOORD0;
		  float4 recPos :TEXCOORD1;
		  
		};
		
		VSOut vert (VSInput v)
		{
			VSOut o ;
			o.position = mul (UNITY_MATRIX_MVP, v.vertex);
			o.recPos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.ScreenPos = ComputeScreenPos(o.position);
			return o;
		}
		
		fixed4 frag( VSOut i): Color  
		{
		    fixed4 color = fixed4(1.0,0,0,0);
		    half depth = tex2D(_CameraDepthTexture,i.ScreenPos.xy/i.ScreenPos.w).r;
			float4 prjPos = float4 (i.recPos.xy/i.recPos.w,depth,1.0);
			float4 objPos = mul(_invMVP,prjPos);
			objPos/= objPos.w;
			if(objPos.x < -0.5||objPos.x > 0.5||objPos.y < -0.5||objPos.y > 0.5||objPos.z < -0.5||objPos.z > 0.5)
				clip(-1.0);
			color = tex2D(_MainTex,_MainTex_ST.xy*(objPos.xz+0.5)+_MainTex_ST.zw);
			return color;
		}
		ENDCG
		}
	} 
	FallBack "Unlit/Transparent"
}
