//-----------------------------------
// -- -juvs
//-----------------------------------
//
//-----------------------------------
// Global variables
//-----------------------------------
float4x4 g_matWorld; 
float4x4 g_matWV; 
float4x4 g_matWVP; 
float2   g_vFOG; 
float    g_fVS_1_1_ColorMulti = 0.75f; 
float    g_fAlpha; 
int      g_Flag; 
float2	 g_vLightMapUV_Offset; 
float    g_fTime; 
float3   g_vCameraFrom;
float4   g_vWindowSize;
float4  g_vDLightDir;

//material blend
float    g_fRotate_UV;	 
float    g_fScaleFactor; 

//material watercube
float2	 g_vReflectPower; 
float 	 g_fWaveDensity; 
float 	 g_fWaveScale; 
float 	 g_fWaveSpeed; 
float2   g_vMoveSpeed; 

//material texupdown
float    g_fTexColorUpDown = 1.f; 
float    g_fTexColorUpDownMin = 0.f; 
float    g_fTexColorUpDownAdd = 1.f; 
float	 g_fTexColorUpDownSpeed = 5.f; 

//material waterstream	
float 	 g_fImageScale0; 
float 	 g_fImageScale1; 
float2   g_vMoveSpeed0; 
float2   g_vMoveSpeed1; 

//material waterstream2 
float    g_fColorPower0;
float    g_fColorPower1;

//decal
float    g_fSpecularPower = 256.f; 
float    g_fSpecularIntensity = 0.f; 
float3	 g_vDecalBelndColor;  
float	 g_fCubeMapValue;
float	 g_fDecalNormal=1.f;
float	g_fSeamless_Near_Distance;
float	g_fSeamless_Far_Distance;
float	g_fSeamless_Far_Alpha;
float	g_fSeamless_Near_Alpha;
//
//-----------------------------------
// Material Parameters
//-----------------------------------
texture g_BaseTexture; 
sampler BaseTexSampler = sampler_state  
{ 
	Texture = (g_BaseTexture); 
}; 

texture g_BaseTexture2; 
sampler BaseTex2Sampler = sampler_state  
{ 
	Texture = (g_BaseTexture2); 
}; 

texture g_LightMapDayTex; 
sampler LightMapTexSampler_1st = sampler_state  
{ 
	Texture = (g_LightMapDayTex);	 
}; 

texture g_NormalTexture; 
sampler NormalTexSampler = sampler_state  
{ 
	Texture = (g_NormalTexture); 
}; 

texture g_ReflectTexRT; 
sampler ReflectTexRTSampler = sampler_state  
{ 
	Texture = (g_ReflectTexRT); 

	//AddressU = Mirror; 
	//AddressV = Mirror; 
}; 

texture g_CubeTexture; 
samplerCUBE CubeTexSampler = sampler_state  
{ 
	Texture = (g_CubeTexture); 
}; 

//
//-----------------------------------
// Basic vertex transformation 
//-----------------------------------
struct VS_INPUT		
{
	float4 m_vPosition  : POSITION;    
	float4 m_vVertColor : COLOR0;
	float3 m_vNormal    : NORMAL;
	float2 m_vTexCoord0 : TEXCOORD0;
};

struct VS_OUTPUT_1		
{
	float4 m_vPosition  : POSITION;
	float4 m_vVertColor : COLOR0;
	float2 m_vTexCoord0 : TEXCOORD0;
	float  m_fFog       : FOG;
};

struct VS_OUTPUT_2
{ 
	float4 m_vPosition       : POSITION; 
	float4 m_vVertColor      : COLOR0;
	float2 m_vTexCoord0      : TEXCOORD0;
	float2 m_vTexCoord1      : TEXCOORD1;
	float3 m_vEnumPosition   : TEXCOORD2; 
	float  m_fFog            : FOG; 
}; 
//
//-----------------------------------
// Shader
//-----------------------------------
VS_OUTPUT_1 VS_1( VS_INPUT In ) 
{
	VS_OUTPUT_1 Out;
	Out.m_vPosition = mul(In.m_vPosition, g_matWVP );
	Out.m_vTexCoord0 = In.m_vTexCoord0;
	Out.m_vVertColor = In.m_vVertColor;
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y);

	return Out;
}

float4 PS_1( VS_OUTPUT_1 In ) : COLOR0 
{
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 );
	vColor *= In.m_vVertColor;
	vColor *= g_vReflectPower.xxxy;

	return vColor;
}

VS_OUTPUT_2 VS_2( VS_INPUT In, uniform bool bReflectRT  ) 
{
	VS_OUTPUT_2 Out;
	Out.m_vPosition = mul(In.m_vPosition, g_matWVP );

	Out.m_vTexCoord0 = In.m_vTexCoord0*g_fWaveDensity + float2(sin(g_fTime*g_fWaveSpeed), cos(g_fTime*g_fWaveSpeed));
	Out.m_vTexCoord1 = In.m_vTexCoord0*g_fWaveDensity + float2(sin(g_fTime*g_fWaveSpeed+(3.14f*0.5f)), cos(g_fTime*g_fWaveSpeed+(3.14f*0.5f)));
	Out.m_vTexCoord0 += float2(g_fTime*g_vMoveSpeed.x, g_fTime*g_vMoveSpeed.y);
	Out.m_vTexCoord1 += float2(g_fTime*g_vMoveSpeed.x, g_fTime*g_vMoveSpeed.y);
	Out.m_vVertColor = In.m_vVertColor;

	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y);

	Out.m_vEnumPosition.xyz = 1.f;
	if ( bReflectRT )
	{
		Out.m_vEnumPosition.xyz = mul(In.m_vPosition, g_matWVP ).xyw;
	}
	else
	{
		float3 vWorldPos = mul(In.m_vPosition, g_matWorld );
		Out.m_vEnumPosition = vWorldPos;
	}

	return Out;
}

float4 PS_2( VS_OUTPUT_2 In ) : COLOR0 
{
	float3 vBump1 = tex2D( NormalTexSampler, In.m_vTexCoord0 );
	float3 vBump2 = tex2D( NormalTexSampler, In.m_vTexCoord1 );

	vBump1 = (vBump1.rgb * 2.0f) - 1.0f;
	vBump2 = (vBump2.rgb * 2.0f) - 1.0f;
	float3 vBump = normalize(vBump1 + vBump2);
	vBump *= float3(g_fWaveScale,g_fWaveScale,1.f);
	vBump = normalize(vBump);

	float3 vEyeToVector = normalize(In.m_vEnumPosition - g_vCameraFrom);
	float3 vCubeTexcoord = reflect(vEyeToVector, vBump.xzy);
	float4 vColor = texCUBE( CubeTexSampler, vCubeTexcoord );

	vColor *= In.m_vVertColor;
	vColor *= g_vReflectPower.xxxy;

	return vColor;
}

float4 PS_2_REAL_TIME( VS_OUTPUT_2 In ) : COLOR0 
{
	float3 vBump1 = tex2D( NormalTexSampler, In.m_vTexCoord0 );
	float3 vBump2 = tex2D( NormalTexSampler, In.m_vTexCoord1 );

	vBump1 = (vBump1.rgb * 2.0f) - 1.0f;
	vBump2 = (vBump2.rgb * 2.0f) - 1.0f;
	float3 vBump = normalize(vBump1 + vBump2);
	vBump *= float3(g_fWaveScale,g_fWaveScale,1.f);
	vBump = normalize(vBump);

	float2 vProjectionUV = 0.5 * In.m_vEnumPosition.xy / In.m_vEnumPosition.z + float2( 0.5, 0.5 );
	vProjectionUV.y = 1.0f - vProjectionUV.y;
	vProjectionUV.xy += g_vWindowSize.xy;
	vProjectionUV.xy += vBump.xz;

	float4 vColor = tex2D( ReflectTexRTSampler, vProjectionUV );

	vColor *= In.m_vVertColor;
	vColor *= g_vReflectPower.xxxy;
	//vColor.w = 1.0f;

	return vColor;
}
//
//-----------------------------------
//	technique 
//-----------------------------------
technique runtime_1 
{ 
	pass high 
	{ 
		VertexShader = compile vs_2_0 VS_1(); 
		PixelShader = compile ps_2_0 PS_1(); 

		DEPTHBIAS = -0.00020f;
		//FOGENABLE = FALSE;
		//ALPHABLENDENABLE = TRUE;
		//SRCBLEND = SRCALPHA;
		//DESTBLEND = INVSRCALPHA;
		//FOGCOLOR = 0L;
	} 
} 

technique runtime_2 
{ 
	pass high
	{ 
		VertexShader = compile vs_2_0 VS_2(false); 
		PixelShader = compile ps_2_0 PS_2(); 

		DEPTHBIAS = -0.00020f;
		//FOGENABLE = FALSE;
		//ALPHABLENDENABLE = TRUE;
		//SRCBLEND = SRCALPHA;
		//DESTBLEND = INVSRCALPHA;
		//FOGCOLOR = 0L;
	}

	pass realtime
	{ 
		VertexShader = compile vs_2_0 VS_2(true); 
		PixelShader = compile ps_2_0 PS_2_REAL_TIME(); 

		DEPTHBIAS = -0.00020f;
		FOGENABLE = FALSE;
		ALPHABLENDENABLE = TRUE;
		SRCBLEND = SRCALPHA;
		DESTBLEND = INVSRCALPHA;
		FOGCOLOR = 0L;
	}
};
//-----------------------------------
//	ver 1 4-30-2018
//	initial version
//-----------------------------------
//
