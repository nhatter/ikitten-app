Shader "FurFX/Mobile/FurFX Basic 20 Layer"
{
	Properties
	{
		_Color ("Color (RGB)", Color) = (1,1,1,1)
	  	_SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  	_Shininess ("Shininess", Range (0.01, 10)) = 8		
		_FurLength ("Fur Length", Range (.0002, 0.5)) = .05
		_MainTex ("Base (RGB) Mask(A)", 2D) = "white" { }
		_NoiseTex ("Noise (RGB)", 2D) = "white" { }
		_EdgeFade ("Edge Fade", Range(0,1)) = 0.15
		_HairHardness ("Fur Hardness", Range(0.1,1)) = 1
		_HairThinness ("Fur Thinness", Range(0.01,10)) = 2
		_HairShading ("Fur Shading", Range(0.0,1)) = 0.25
		_SkinAlpha ("Mask Alpha Factor", Range(0.0,1)) = 0.5
		_ForceGlobal ("Force Global",Vector) = (0,0,0,0)		
		_ForceLocal ("Force Local",Vector) = (0,0,0,0)	
	}
	Category
	{
		ZWrite On
		Tags {"Queue" = "Transparent"}
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
		
		SubShader
		{
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 48 to 48
//   d3d9 - ALU: 54 to 54
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"!!ARBvp1.0
# 48 ALU
PARAM c[29] = { { 0, 1, 2 },
		state.lightmodel.ambient,
		program.local[2..16],
		state.matrix.mvp,
		program.local[21..28] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[0].z;
MAD R0.xyz, -R1, -R0.w, -R0;
SLT R1.x, R0.w, c[0];
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.y, R0.x, c[25].x;
ABS R1.x, R1;
MOV R0.xyz, c[24];
MUL R0.xyz, R0, c[26];
MOV R2.xyz, c[23];
MUL R0.xyz, R0, R1.y;
SGE R1.w, c[0].x, R1.x;
MOV R1.xyz, c[23];
MAX R0.w, R0, c[0].x;
MUL R1.xyz, R1, c[26];
MUL R1.xyz, R1, R0.w;
MUL R2.xyz, R2, c[1];
ADD R1.xyz, R2, R1;
MOV R0.w, c[8].x;
MAD result.color.xyz, R0, R1.w, R1;
MUL R0.x, R0.w, c[0];
MOV R0.w, c[0].y;
ADD R0.xyz, vertex.position, R0.x;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[28].xyxy, c[28];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[27], c[27].zwzw;
MOV result.color.w, c[0].y;
END
# 48 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_Color]
Vector 21 [_SpecColor]
Float 22 [_Shininess]
Vector 23 [_LightColor0]
Vector 24 [_MainTex_ST]
Vector 25 [_NoiseTex_ST]
"vs_2_0
; 54 ALU
def c26, 0.00000000, 1.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c26.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r1.w, r1, r2
mul r1.xyz, r1, c26.z
mad r1.xyz, -r1.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.z, r1, r0
slt r0.w, r1, c26.x
max r1.y, r0.z, c26.x
sge r0.y, c26.x, r0.w
sge r0.x, r0.w, c26
mul r0.x, r0, r0.y
max r1.x, -r0, r0
pow r0, r1.y, c22.x
slt r0.w, c26.x, r1.x
mov r2.x, r0
mov r1.xyz, c23
mul r0.xyz, c21, r1
mul r0.xyz, r0, r2.x
mov r1.xyz, c23
mov r2.xyz, c16
max r1.w, r1, c26.x
mul r1.xyz, c20, r1
mul r1.xyz, r1, r1.w
mul r2.xyz, c20, r2
add r1.xyz, r2, r1
mad oD0.xyz, r0.w, r0, r1
mov r1.w, c26.x
mul r0.x, c19, r1.w
mov r0.w, c26.y
add r0.xyz, v0, r0.x
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c25.xyxy, c25
mad oT0.xy, v2, c24, c24.zwzw
mov oD0.w, c26.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = _glesVertex.xyz;
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = P;
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  highp vec4 tmpvar_5;
  tmpvar_5 = (gl_ModelViewProjectionMatrix * tmpvar_4);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((tmpvar_6 * _World2Object).xyz);
  normalDirection = tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_10));
  highp vec3 tmpvar_12;
  tmpvar_12 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_12;
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_13;
    tmpvar_13 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_14;
    tmpvar_14 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_13, _Shininess));
    specularReflection = tmpvar_14;
  };
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = ((ambientLighting + tmpvar_11) + specularReflection);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = tmpvar_15;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  o.xyz = (tmpvar_1.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.w = 1.0;
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 4 to 4, TEX: 1 to 1
//   d3d9 - ALU: 4 to 4, TEX: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 4 ALU, 1 TEX
PARAM c[1] = { { 1, 2 } };
TEMP R0;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[0].y;
MOV result.color.w, c[0].x;
END
# 4 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 4 ALU, 1 TEX
dcl_2d s0
def c0, 2.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl v0.xyz
texld r0, t0, s0
mul_pp r0.xyz, v0, r0
mul_pp r0.xyz, r0, c0.x
mov_pp r0.w, c0.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 37

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.049987793, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.0025000002, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.04998779, 1.00000000, -1.00000000, 0.00250000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.05) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.0025) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.05 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.814506 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.0025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.0025005341, 0.81445313, 2, 0.049987793 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.81445313, 2.00000000, 0.00250053, 0.04998779
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 49

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.099975586, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.010000001, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.09997559, 1.00000000, -1.00000000, 0.01000000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.1) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.01) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.1 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.6561 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.01 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.010002136, 0.65625, 2, 0.099975586 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.65625000, 2.00000000, 0.01000214, 0.09997559
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 61

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.15002441, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.022500001, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.15002441, 1.00000000, -1.00000000, 0.02250000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.15) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.0225) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.15 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.522006 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.0225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.022506714, 0.52197266, 2, 0.15002441 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.52197266, 2.00000000, 0.02250671, 0.15002441
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 73

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.19995117, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.040000003, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.19995117, 1.00000000, -1.00000000, 0.04000000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.2) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.04) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.2 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.4096 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.04 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.040008545, 0.40966797, 2, 0.19995117 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.40966797, 2.00000000, 0.04000854, 0.19995117
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 85

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.25, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.0625, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.25000000, 1.00000000, -1.00000000, 0.06250000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.25) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.0625) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.25 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.316406 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.0625 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.0625, 0.31640625, 2, 0.25 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.31640625, 2.00000000, 0.06250000, 0.25000000
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 97

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.30004883, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.090000004, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.30004883, 1.00000000, -1.00000000, 0.09000000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.3) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.09) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.3 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.2401 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.09 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.090026855, 0.2401123, 2, 0.30004883 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.24011230, 2.00000000, 0.09002686, 0.30004883
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 109

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.35009766, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.12249999, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.35009766, 1.00000000, -1.00000000, 0.12249999
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.35) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.1225) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.35 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.178506 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.1225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.12249756, 0.1784668, 2, 0.35009766 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.17846680, 2.00000000, 0.12249756, 0.35009766
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 121

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.39990234, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.16000001, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.39990234, 1.00000000, -1.00000000, 0.16000001
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.4) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.16) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.4 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.1296 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.16 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.16003418, 0.12963867, 2, 0.39990234 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.12963867, 2.00000000, 0.16003418, 0.39990234
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 133

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.44995117, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.20249999, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.44995117, 1.00000000, -1.00000000, 0.20249999
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.45) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.2025) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.45 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0915063 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.2025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20251465, 0.091491699, 2, 0.44995117 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.09149170, 2.00000000, 0.20251465, 0.44995117
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 145

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.5, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.25, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.50000000, 1.00000000, -1.00000000, 0.25000000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.5) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.25) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.5 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0625 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.25 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.25, 0.0625, 2, 0.5 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.06250000, 2.00000000, 0.25000000, 0.50000000
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 157

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.54980469, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.30250001, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.54980469, 1.00000000, -1.00000000, 0.30250001
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.55) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.3025) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.55 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0410062 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.3025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.30249023, 0.041015625, 2, 0.54980469 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.04101563, 2.00000000, 0.30249023, 0.54980469
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 169

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.60009766, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.36000001, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.60009766, 1.00000000, -1.00000000, 0.36000001
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.6) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.36) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.6 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0256 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.36 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.36010742, 0.025604248, 2, 0.60009766 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.02560425, 2.00000000, 0.36010742, 0.60009766
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 181

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.64990234, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.42249995, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.64990234, 1.00000000, -1.00000000, 0.42249995
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.65) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.4225) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.65 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0150062 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.4225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.42260742, 0.015007019, 2, 0.64990234 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.01500702, 2.00000000, 0.42260742, 0.64990234
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 193

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.70019531, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.48999998, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.70019531, 1.00000000, -1.00000000, 0.48999998
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.7) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.49) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.7 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0081 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.49 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.48999023, 0.008102417, 2, 0.70019531 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00810242, 2.00000000, 0.48999023, 0.70019531
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 205

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.75, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.5625, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.75000000, 1.00000000, -1.00000000, 0.56250000
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.75) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.5625) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.75 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.00390625 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.5625 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.5625, 0.00390625, 2, 0.75 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00390625, 2.00000000, 0.56250000, 0.75000000
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 217

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.79980469, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.64000005, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.79980469, 1.00000000, -1.00000000, 0.64000005
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.8) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.64) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.8 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0016 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.64 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.64013672, 0.0016002655, 2, 0.79980469 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00160027, 2.00000000, 0.64013672, 0.79980469
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 229

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.85009766, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.72250003, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.85009766, 1.00000000, -1.00000000, 0.72250003
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.85) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.7225) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.85 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.00050625 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.7225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.72265625, 0.00050640106, 2, 0.85009766 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00050640, 2.00000000, 0.72265625, 0.85009766
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 241

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.89990234, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.80999994, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.89990234, 1.00000000, -1.00000000, 0.80999994
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.9) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.81) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.9 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0001 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.81 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 15 to 15, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.81005859, 0.00010001659, 2, 0.89990234 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MOV R1.zw, c[4].xyxy;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[4];
CMP R0.w, -R0, c[5].x, c[5].y;
SLT R0.w, R0, c[5].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MAD R0.xyz, R1.w, -c[3].x, R0;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[4].z;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 15 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00010002, 2.00000000, 0.81005859, 0.89990234
def c5, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.w
cmp r1.x, -r1, c5, -c5
cmp r1.x, r1, c5.y, c5
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r0.xyz, c4.x, -r2.x, r0
mul_pp r2.xyz, v0, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.z, -r0.x, r1.x
mul_pp r0.xyz, r2, c4.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 253

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 64 to 64
//   d3d9 - ALU: 70 to 70
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 6 [_WorldSpaceCameraPos]
Vector 7 [_WorldSpaceLightPos0]
Matrix 9 [_Object2World]
Matrix 13 [_World2Object]
Float 8 [_FurLength]
Vector 21 [_ForceGlobal]
Vector 22 [_ForceLocal]
Float 23 [_HairHardness]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_LightColor0]
Vector 28 [_MainTex_ST]
Vector 29 [_NoiseTex_ST]
"!!ARBvp1.0
# 64 ALU
PARAM c[31] = { { 0, 0.95019531, -1, 1 },
		state.lightmodel.ambient,
		state.matrix.projection,
		program.local[6..16],
		state.matrix.mvp,
		program.local[21..29],
		{ 0.90249997, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[14];
MAD R0.xyz, vertex.normal.x, c[13], R0;
MAD R0.xyz, vertex.normal.z, c[15], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[7], c[7];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
ADD R2.xyz, -R0, c[6];
RSQ R0.x, R0.w;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R0.xyz, R0.x, c[7];
DP3 R0.w, R1, R0;
MUL R1.xyz, R1, c[30].y;
MAD R0.xyz, -R1, -R0.w, -R0;
MUL R2.xyz, R1.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[0];
POW R1.w, R0.x, c[26].x;
SLT R0.x, R0.w, c[0];
ABS R2.x, R0;
MOV R1.xyz, c[25];
MUL R0.xyz, R1, c[27];
MUL R3.xyz, R0, R1.w;
MOV R0.xyz, c[24];
MOV R1.xyz, c[24];
SGE R2.w, c[0].x, R2.x;
MAX R0.w, R0, c[0].x;
MUL R0.xyz, R0, c[27];
MUL R2.xyz, R0, R0.w;
MOV R1.w, c[0];
MIN R0, R1.w, c[21];
MUL R1.xyz, R1, c[1];
ADD R1.xyz, R1, R2;
MAX R0, R0, c[0].z;
MAD result.color.xyz, R3, R2.w, R1;
MIN R1, R1.w, c[22];
DP4 R2.z, R0, c[15];
DP4 R2.y, R0, c[14];
DP4 R2.x, R0, c[13];
MAX R1, R1, c[0].z;
MOV R0.w, c[0];
DP4 R0.z, R1, c[4];
DP4 R0.y, R1, c[3];
DP4 R0.x, R1, c[2];
MUL R1.xyz, vertex.normal, c[8].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[23].x;
MUL R0.xyz, R0, c[8].x;
MUL R1.xyz, R1, c[0].y;
MUL R0.xyz, R0, c[30].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[20];
DP4 result.position.z, R0, c[19];
DP4 result.position.y, R0, c[18];
DP4 result.position.x, R0, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[28], c[28].zwzw;
MOV result.color.w, c[0];
END
# 64 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 16 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 8 [_Object2World]
Matrix 12 [_World2Object]
Float 19 [_FurLength]
Vector 20 [_ForceGlobal]
Vector 21 [_ForceLocal]
Float 22 [_HairHardness]
Vector 23 [_Color]
Vector 24 [_SpecColor]
Float 25 [_Shininess]
Vector 26 [_LightColor0]
Vector 27 [_MainTex_ST]
Vector 28 [_NoiseTex_ST]
"vs_2_0
; 70 ALU
def c29, 0.95019531, 1.00000000, -1.00000000, 0.90249997
def c30, 0.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp3 r1.x, c18, c18
rsq r1.w, r1.x
mul r0.xyz, v1.y, c13
mad r0.xyz, v1.x, c12, r0
mad r0.xyz, v1.z, c14, r0
add r0.xyz, r0, c30.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r2.xyz, r1.w, c18
dp3 r0.w, r1, r2
mul r1.xyz, r1, c30.y
mad r1.xyz, -r0.w, -r1, -r2
dp4 r0.z, v0, c10
dp4 r0.x, v0, c8
dp4 r0.y, v0, c9
add r0.xyz, -r0, c17
dp3 r1.w, r0, r0
rsq r1.w, r1.w
mul r2.xyz, r1.w, r0
slt r0.x, r0.w, c30
dp3 r0.z, r1, r2
sge r0.y, c30.x, r0.x
sge r0.x, r0, c30
mul r0.x, r0, r0.y
max r0.y, r0.z, c30.x
mov r2.xyz, c16
pow r1, r0.y, c25.x
max r0.x, -r0, r0
slt r1.w, c30.x, r0.x
mov r0.xyz, c26
mul r0.xyz, c24, r0
mul r1.xyz, r0, r1.x
mov r0.xyz, c26
max r0.w, r0, c30.x
mul r0.xyz, c23, r0
mul r3.xyz, r0, r0.w
mov r0, c20
mul r2.xyz, c23, r2
add r2.xyz, r2, r3
mad oD0.xyz, r1.w, r1, r2
min r0, c29.y, r0
max r0, r0, c29.z
mov r1, c21
min r1, c29.y, r1
dp4 r2.z, r0, c14
dp4 r2.y, r0, c13
dp4 r2.x, r0, c12
max r1, r1, c29.z
mov r0.w, c29.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c19.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c22.x
mul r0.xyz, r0, c19.x
mul r1.xyz, r1, c29.x
mul r0.xyz, r0, c29.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c28.xyxy, c28
mad oT0.xy, v2, c27, c27.zwzw
mov oD0.w, c29.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.95) * _HairHardness));
  P = tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_4 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.9025) * _FurLength));
  P = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.xyz = P;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * tmpvar_5);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  normalDirection = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz));
  viewDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_12;
  tmpvar_12 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_11));
  highp vec3 tmpvar_13;
  tmpvar_13 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_13;
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_14;
    tmpvar_14 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_15;
    tmpvar_15 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_14, _Shininess));
    specularReflection = tmpvar_15;
  };
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((ambientLighting + tmpvar_12) + specularReflection);
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_COLOR0 = tmpvar_16;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.95 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.9025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 13 to 13, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[5] = { program.local[0..2],
		{ 0.90234375, 2, 0.95019531, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[3].y;
ADD R1.x, -R1, c[3].z;
MOV R0.w, c[4].x;
CMP R0.w, -R1.x, c[3], R0;
SLT R0.w, R0, c[4].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MOV R0.x, c[3];
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R0.x, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 13 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 2.00000000, 0.90234375, 0.95019531, 1.00000000
def c4, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c3.z
cmp r1.x, -r1, c3.w, -c3.w
cmp r1.x, r1, c4, c4.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mul_pp r2.xyz, r0, v0
mov_pp r0.x, c0
mad_pp_sat r0.w, c3.y, -r0.x, r1.x
mul_pp r0.xyz, r2, c3.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 265


			}
		}		Fallback "Diffuse", 1
	}
}
