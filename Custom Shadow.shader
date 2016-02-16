Shader "Custom/Model Shadow" {

	Properties {
		_ShadowColor ("Shadow Color(RBGA)", Color) = (0.1,0.1,0.1,0.2)
		_ShadowDir("Shadow Direction(XYZ), None(W)",Vector)=(0.0,1.0,1.0,1.0)
		_ShadowPlane("Shadow Plane(XYZ), Distance(W)",Vector)=(0.0,1.0,0.0,0.0)
	}

	SubShader {
	
	Pass
	{
		Name "ModelShadow"
		ZWrite ON
		ZTest OFF
		Blend SrcAlpha OneMinusSrcAlpha
		
		Fog {Mode Off}
		
		Stencil {
                Ref 2
                Comp NotEqual
                Pass Replace
            }

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag 
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"

		uniform fixed4 _ShadowDir;
		uniform fixed4 _ShadowColor;
		uniform fixed4 _ShadowPlane;
		struct appdata_t 
		{
			float4 vertex : POSITION;
		} ;
		struct v2f 
		{
			float4 pos : POSITION;
		} ;
		v2f vert ( appdata_t v )
		{
			v2f o;
			o.pos = mul(_Object2World,v.vertex);
			float3 ShadowDir = normalize(_ShadowDir.xyz);
			o.pos.rgb = o.pos.rgb - (dot(_ShadowPlane.xyz,o.pos)- _ShadowPlane.w)/dot(_ShadowPlane.xyz,ShadowDir)*ShadowDir;
			o.pos = mul(UNITY_MATRIX_VP,o.pos) ;
			return o; 
		}
		fixed4 frag(v2f i) :COLOR 
		{ 
			return _ShadowColor;
		}
        ENDCG
	}
	
}


}
