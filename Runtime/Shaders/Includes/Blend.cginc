
#ifndef __BLEND_CGINC__
#define __BLEND_CGINC__

//https://qiita.com/yoya/items/96c36b069e74398796f3

float3 RGBToHSV( float3 rgb)
{
	float4 K = float4( 0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	float4 P = lerp( float4( rgb.bg, K.wz), float4( rgb.gb, K.xy), step( rgb.b, rgb.g));
	float4 Q = lerp( float4( P.xyw, rgb.r), float4( rgb.r, P.yzx), step( P.x, rgb.r));
	float  D = Q.x - min( Q.w, Q.y);
	float  E = 1e-4;
	return float3( abs( Q.z + (Q.w - Q.y) / (6.0 * D + E)), D / (Q.x + E), Q.x);
}
float3 HSVToRGB( float3 hsv)
{
	float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	float3 P = abs( frac( hsv.xxx + K.xyz) * 6.0 - K.www);
	return hsv.z * lerp( K.xxx, saturate( P - K.xxx), hsv.y);
}


/* グレースケール:平均 */
inline fixed GlayScaleAverage( fixed3 color)
{
	return (color.r + color.g + color.b) / 3.0;
}

/* グレースケール:ITU-R Rec BT.601
 * https://www.itu.int/rec/R-REC-BT.601/en
 */
inline fixed GlayScaleBT601( fixed3 color)
{
	return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
}

/* グレースケール:ITU-R Rec BT.709
 * https://www.itu.int/rec/R-REC-BT.709/en
 */
inline fixed GlayScaleBT709( fixed3 color)
{
	return color.r * 0.2126 + color.g * 0.7152 + color.b * 0.722;
}

/* グレースケール:標準テレビジョン放送規格
 * https://www.tele.soumu.go.jp/horei/reiki_honbun/a72ab21051.html
 */
inline fixed GlayScaleTV( fixed3 color)
{
	return color.r * 0.30 + color.g * 0.59 + color.b * 0.11;
}

/* グレースケール:YCgCo の Y
 * https://www.tele.soumu.go.jp/horei/reiki_honbun/a72ab21051.html
 */
inline fixed GlayScaleYofYCgCo( fixed3 color)
{
	return color.r / 4.0 + color.g / 2.0 + color.b  / 4.0;
//	return (((color.r + color.b) >> 1) + color.g) >> 1;
}

//http://optie.hatenablog.com/entry/2018/03/15/212107
//Base  = Background
//Blend = Foreground

/* 乗算 */
inline fixed3 BelndMultiply( fixed3 Base, fixed3 Blend)
{
	return Base * Blend;
}

/* 比較(暗):各成分の低い方を出力する */
inline fixed3 BelndDarken( fixed3 Base, fixed3 Blend)
{
	return min( Base, Blend);
}

/* 焼き込みカラー:(反転した背景 / 前景) を反転する */
inline fixed3 BelndColorBurn( fixed3 Base, fixed3 Blend)
{
	return 1.0 - (1.0 - Base) / (Blend + 1e-12);
}

/* 焼き込みリニア:(反転背景 + 反転前景) を反転する */
inline fixed3 BelndLinearBurn( fixed3 Base, fixed3 Blend)
{
//	return saturate( 1.0 - ((1.0 - Base) + (1.0 - Blend)));
	return saturate( Base + Blend - 1.0);
}

/* 比較(明):各成分の高い方を出力する */
inline fixed3 BelndLighten( fixed3 Base, fixed3 Blend)
{
	return max( Base, Blend);
}

/* スクリーン:反転して乗算し、また反転して戻す */
inline fixed3 BelndScreen( fixed3 Base, fixed3 Blend)
{
	return 1.0 - (1.0 - Base) * (1.0 - Blend);
}

/* 覆い焼きカラー:背景 / 反転した前景 */
inline fixed3 BelndColorDodge( fixed3 Base, fixed3 Blend)
{
	return Base / (1.0 - clamp( Blend, 1e-12, 0.999999));
}

/* 覆い焼きリニア:加算する */
inline fixed3 BelndLinearDodge( fixed3 Base, fixed3 Blend)
{
	return saturate( Blend + Base);
}

/* オーバーレイ:背景の暗部では乗算、背景の明部ではスクリーン */
inline fixed3 BelndOverlay( fixed3 Base, fixed3 Blend)
{
	float3 result1 = 2.0 * Base * Blend;
	float3 result2 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
    float3 zeroOrOne = step( Base, 0.5);
    return result1 * zeroOrOne + (1 - zeroOrOne) * result2;
}

/* ハードライト:前景の暗部では乗算、前景の明部ではスクリーン */
inline fixed3 BelndHardLight( fixed3 Base, fixed3 Blend)
{
	float3 result1 = 2.0 * Base * Blend;
	float3 result2 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
	float3 zeroOrOne = step( Blend, 0.5);
	return result1 * zeroOrOne + (1 - zeroOrOne) * result2;
}

/* ビビッドライト:前景の暗部では焼き込みカラー、前景の明部では覆い焼きカラー */
inline fixed3 BelndVividLight( fixed3 Base, fixed3 Blend)
{
    float3 result1 = BelndColorBurn( Base, 2.0 * Blend);
    float3 result2 = BelndColorDodge( Base, 2.0 * (Blend - 0.5));
    float3 zeroOrOne = step( Blend, 0.5);
    return result1 * zeroOrOne + (1 - zeroOrOne) * result2;
}

/* リニアライト:前景の暗部では焼き込みリニア、前景の明部では覆い焼きリニア */
inline fixed3 BelndLinearLight( fixed3 Base, fixed3 Blend)
{
	float3 result1 = BelndLinearBurn( Base, 2.0 * Blend);
	float3 result2 = BelndLinearDodge( Base, 2.0 * (Blend - 0.5));
	float3 zeroOrOne = step( Blend, 0.5);
	return result1 * zeroOrOne + (1 - zeroOrOne) * result2;
}

/* ピンライト:前景の暗部では比較(暗)、前景の明部では比較(明) */
inline fixed3 BelndPinLight( fixed3 Base, fixed3 Blend)
{
	float3 result1 = BelndDarken( Base, 2.0 * Blend);
	float3 result2 = BelndLighten( Base, 2.0 * (Blend - 0.5));
	float3 zeroOrOne = step( Blend, 0.5);
	return result1 * zeroOrOne + (1 - zeroOrOne) * result2;
}

/* ハードミックス:ビビッドライトの演算結果を各成分毎に二値化します */
inline fixed3 BelndHardMix( fixed3 Base, fixed3 Blend)
{
//	return step( 0.5, BelndVividLight( Base, Blend));
	return step( 1 - Base, Blend);
}

/* 差:前景と背景の値の差分を出力する */
inline fixed3 BelndDifference( fixed3 Base, fixed3 Blend)
{
	return abs( Base - Blend);
}

/* 除外:前景と背景の相加平均と相乗平均の差をとって2倍する */
inline fixed3 BelndExclusion( fixed3 Base, fixed3 Blend)
{
	return Base + Blend - 2.0 * Base * Blend;
}

/* 減算:背景から前景を引きます */
inline fixed3 BelndSubstract( fixed3 Base, fixed3 Blend)
{
	return saturate( Base - Blend);
}

/* 除算:前景で背景を割ります */
inline fixed3 BelndDivision( fixed3 Base, fixed3 Blend)
{
	return saturate( Base / (Blend + 1e-12));
}

/* 色相:背景の輝度と彩度を維持したまま、前景の色相だけを移します */
inline fixed3 BelndHue( fixed3 Base, fixed3 Blend)
{
	float3 hsvBase = RGBToHSV( Base);
	float3 hsvBlend = RGBToHSV( Blend);
	return HSVToRGB( float3( hsvBlend.x, hsvBase.yz));
}
/* 彩度:背景の輝度と色相を維持したまま、前景の彩度だけを移します */
inline fixed3 BelndSaturation( fixed3 Base, fixed3 Blend)
{
	float3 hsvBase = RGBToHSV( Base);
	float3 hsvBlend = RGBToHSV( Blend);
	return HSVToRGB( float3( hsvBase.x, hsvBlend.y, hsvBase.z));
}
/* 彩度:背景の色相と彩度を維持したまま、前景の輝度だけを移します */
inline fixed3 BelndLuminosity( fixed3 Base, fixed3 Blend)
{
	float3 hsvBase = RGBToHSV( Base);
	float3 hsvBlend = RGBToHSV( Blend);
	return HSVToRGB( float3( hsvBase.xy, hsvBlend.z));
}
/* 彩度:背景の輝度を維持したまま、前景の色相と彩度を移します */
inline fixed3 BelndColor( fixed3 Base, fixed3 Blend)
{
	float3 hsvBase = RGBToHSV( Base);
	float3 hsvBlend = RGBToHSV( Blend);
	return HSVToRGB( float3( hsvBlend.xy, hsvBase.z));
}
inline float remap( float value, float srcMin, float srcMax, float dstMin, float dstMax)
{
	float volume = srcMax - srcMin;
	return dstMin + ((volume != 0.0)? (value - srcMin) * (dstMax - dstMin) / volume : 0.0);
}
inline float remap( float value, float4 param)
{
	return remap( value, param.x, param.y, param.z, param.w);
}
/*
Shader
{
	Properties
	{
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP1( "Multi Map Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC1( "Multi Map Color Blend Ratop Source", float) = 0
		_ColorBlendRatio1( "Multi Map Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_ALPHABLENDOP1( "Multi Map Alpha Blend Op", float) = 2
		_AlphaBlendRatio1( "Multi Map Alpha Blend Ratio Value", float) = 1.0
	}
	SubShader
	{
		Pass
		{
			#pragma shader_feature_local _COLORBLENDOP1_NONE _COLORBLENDOP1_OVERRIDE _COLORBLENDOP1_MULTIPLY _COLORBLENDOP1_DARKEN _COLORBLENDOP1_COLORBURN _COLORBLENDOP1_LINEARBURN _COLORBLENDOP1_LIGHTEN _COLORBLENDOP1_SCREEN _COLORBLENDOP1_COLORDODGE _COLORBLENDOP1_LINEARDODGE _COLORBLENDOP1_OVERLAY _COLORBLENDOP1_HARDLIGHT _COLORBLENDOP1_VIVIDLIGHT _COLORBLENDOP1_LINEARLIGHT _COLORBLENDOP1_PINLIGHT _COLORBLENDOP1_HARDMIX _COLORBLENDOP1_DIFFERENCE _COLORBLENDOP1_EXCLUSION _COLORBLENDOP1_SUBSTRACT _COLORBLENDOP1_DIVISION
			#pragma shader_feature_local _COLORBLENDSRC1_VALUE _COLORBLENDSRC1_ALPHABLENDOP _COLORBLENDSRC1_ONEMINUSALPHABLENDOP _COLORBLENDSRC1_BASEALPHA _COLORBLENDSRC1_ONEMINUSBASEALPHA _COLORBLENDSRC1_BLENDALPHA _COLORBLENDSRC1_ONEMINUSBLENDALPHA _COLORBLENDSRC1_BASECOLORVALUE _COLORBLENDSRC1_ONEMINUSBASECOLORVALUE _COLORBLENDSRC1_BLENDCOLORVALUE _COLORBLENDSRC1_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature_local _ALPHABLENDOP1_NONE _ALPHABLENDOP1_OVERRIDE _ALPHABLENDOP1_MULTIPLY _ALPHABLENDOP1_ADD _ALPHABLENDOP1_SUBSTRACT _ALPHABLENDOP1_REVERSESUBSTRACT _ALPHABLENDOP1_MAXIMUM
		}
	}
}
*/
inline fixed4 Blending1( fixed4 Base, fixed4 Blend, float ColorRatio, float AlphaRatio)
{
	fixed alpha = Base.a;
#if   _ALPHABLENDOP1_OVERRIDE
	alpha = Blend.a;
#elif _ALPHABLENDOP1_MULTIPLY
	alpha = Base.a * Blend.a;
#elif _ALPHABLENDOP1_ADD
	alpha = Base.a + Blend.a;
#elif _ALPHABLENDOP1_SUBSTRACT
	alpha = Base.a - Blend.a;
#elif _ALPHABLENDOP1_REVERSESUBSTRACT
	alpha = Blend.a - Base.a;
#elif _ALPHABLENDOP1_MAXIMUM
	alpha = max( Base.a, Blend.a);
#endif
	alpha = saturate( lerp( Base.a, alpha, AlphaRatio));

#if   _COLORBLENDSRC1_VALUE
#elif _COLORBLENDSRC1_ALPHABLENDOP
	ColorRatio *= alpha;
#elif _COLORBLENDSRC1_ONEMINUSALPHABLENDOP
	ColorRatio *= 1.0 - alpha;
#elif _COLORBLENDSRC1_BASEALPHA
	ColorRatio *= Base.a;
#elif _COLORBLENDSRC1_ONEMINUSBASEALPHA
	ColorRatio *= 1.0 - Base.a;
#elif _COLORBLENDSRC1_BLENDALPHA
	ColorRatio *= Blend.a;
#elif _COLORBLENDSRC1_ONEMINUSBLENDALPHA
	ColorRatio *= 1.0 - Blend.a;
#elif _COLORBLENDSRC1_BASECOLORVALUE
	ColorRatio *= max( Base.r, max( Base.g, Base.b));
#elif _COLORBLENDSRC1_ONEMINUSBASECOLORVALUE
	ColorRatio *= 1.0 - max( Base.r, max( Base.g, Base.b));
#elif _COLORBLENDSRC1_BLENDCOLORVALUE
	ColorRatio *= max( Blend.r, max( Blend.g, Blend.b));
#elif _COLORBLENDSRC1_ONEMINUSBLENDCOLORVALUE
	ColorRatio *= 1.0 - max( Blend.r, max( Blend.g, Blend.b));
#endif

	fixed3 color = Base.rgb;
#if   _COLORBLENDOP1_OVERRIDE
	color = Blend.rgb;
#elif _COLORBLENDOP1_MULTIPLY
	color = BelndMultiply( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_DARKEN
	color = BelndDarken( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_COLORBURN
	color = BelndColorBurn( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_LINEARBURN
	color = BelndLinearBurn( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_LIGHTEN
	color = BelndLighten( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_SCREEN
	color = BelndScreen( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_COLORDODGE
	color = BelndColorDodge( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_LINEARDODGE
	color = BelndLinearDodge( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_OVERLAY
	color = BelndOverlay( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_HARDLIGHT
	color = BelndHardLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_VIVIDLIGHT
	color = BelndVividLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_LINEARLIGHT
	color = BelndLinearLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_PINLIGHT
	color = BelndPinLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_HARDMIX
	color = BelndHardMix( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_DIFFERENCE
	color = BelndDifference( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_EXCLUSION
	color = BelndExclusion( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_SUBSTRACT
	color = BelndSubstract( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP1_DIVISION
	color = BelndDivision( Base.rgb, Blend.rgb);
#endif
	return fixed4( clamp( lerp( Base.rgb, color, ColorRatio), 0.0, 4.0), alpha);
}
/*
Shader
{
	Properties
	{
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_COLORBLENDOP2( "Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_COLORBLENDSRC2( "Color Blend Ratop Source", float) = 0
		_ColorBlendRatio2( "Color Blend Ratio", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_ALPHABLENDOP2( "Alpha Blend Op", float) = 2
		_AlphaBlendRatio2( "Alpha Blend Ratio", float) = 1.0
	}
	SubShader
	{
		Pass
		{
			#pragma shader_feature_local _COLORBLENDOP2_NONE _COLORBLENDOP2_OVERRIDE _COLORBLENDOP2_MULTIPLY _COLORBLENDOP2_DARKEN _COLORBLENDOP2_COLORBURN _COLORBLENDOP2_LINEARBURN _COLORBLENDOP2_LIGHTEN _COLORBLENDOP2_SCREEN _COLORBLENDOP2_COLORDODGE _COLORBLENDOP2_LINEARDODGE _COLORBLENDOP2_OVERLAY _COLORBLENDOP2_HARDLIGHT _COLORBLENDOP2_VIVIDLIGHT _COLORBLENDOP2_LINEARLIGHT _COLORBLENDOP2_PINLIGHT _COLORBLENDOP2_HARDMIX _COLORBLENDOP2_DIFFERENCE _COLORBLENDOP2_EXCLUSION _COLORBLENDOP2_SUBSTRACT _COLORBLENDOP2_DIVISION
			#pragma shader_feature_local _COLORBLENDSRC2_VALUE _COLORBLENDSRC2_ALPHABLENDOP _COLORBLENDSRC2_ONEMINUSALPHABLENDOP _COLORBLENDSRC2_BASEALPHA _COLORBLENDSRC2_ONEMINUSBASEALPHA _COLORBLENDSRC2_BLENDALPHA _COLORBLENDSRC2_ONEMINUSBLENDALPHA _COLORBLENDSRC2_BASECOLORVALUE _COLORBLENDSRC2_ONEMINUSBASECOLORVALUE _COLORBLENDSRC2_BLENDCOLORVALUE _COLORBLENDSRC2_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature_local _ALPHABLENDOP2_NONE _ALPHABLENDOP2_OVERRIDE _ALPHABLENDOP2_MULTIPLY _ALPHABLENDOP2_ADD _ALPHABLENDOP2_SUBSTRACT _ALPHABLENDOP2_REVERSESUBSTRACT _ALPHABLENDOP2_MAXIMUM
		}
	}
}
*/
inline fixed4 Blending2( fixed4 Base, fixed4 Blend, float ColorRatio, float AlphaRatio)
{
	fixed alpha = Base.a;
#if   _ALPHABLENDOP2_OVERRIDE
	alpha = Blend.a;
#elif _ALPHABLENDOP2_MULTIPLY
	alpha = Base.a * Blend.a;
#elif _ALPHABLENDOP2_ADD
	alpha = Base.a + Blend.a;
#elif _ALPHABLENDOP2_SUBSTRACT
	alpha = Base.a - Blend.a;
#elif _ALPHABLENDOP2_REVERSESUBSTRACT
	alpha = Blend.a - Base.a;
#elif _ALPHABLENDOP2_MAXIMUM
	alpha = max( Base.a, Blend.a);
#endif
	alpha = saturate( lerp( Base.a, alpha, AlphaRatio));

#if   _COLORBLENDSRC2_VALUE
#elif _COLORBLENDSRC2_ALPHABLENDOP
	ColorRatio *= alpha;
#elif _COLORBLENDSRC2_ONEMINUSALPHABLENDOP
	ColorRatio *= 1.0 - alpha;
#elif _COLORBLENDSRC2_BASEALPHA
	ColorRatio *= Base.a;
#elif _COLORBLENDSRC2_ONEMINUSBASEALPHA
	ColorRatio *= 1.0 - Base.a;
#elif _COLORBLENDSRC2_BLENDALPHA
	ColorRatio *= Blend.a;
#elif _COLORBLENDSRC2_ONEMINUSBLENDALPHA
	ColorRatio *= 1.0 - Blend.a;
#elif _COLORBLENDSRC2_BASECOLORVALUE
	ColorRatio *= max( Base.r, max( Base.g, Base.b));
#elif _COLORBLENDSRC2_ONEMINUSBASECOLORVALUE
	ColorRatio *= 1.0 - max( Base.r, max( Base.g, Base.b));
#elif _COLORBLENDSRC2_BLENDCOLORVALUE
	ColorRatio *= max( Blend.r, max( Blend.g, Blend.b));
#elif _COLORBLENDSRC2_ONEMINUSBLENDCOLORVALUE
	ColorRatio *= 1.0 - max( Blend.r, max( Blend.g, Blend.b));
#endif

	fixed3 color = Base.rgb;
#if   _COLORBLENDOP2_OVERRIDE
	color = Blend.rgb;
#elif _COLORBLENDOP2_MULTIPLY
	color = BelndMultiply( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_DARKEN
	color = BelndDarken( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_COLORBURN
	color = BelndColorBurn( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_LINEARBURN
	color = BelndLinearBurn( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_LIGHTEN
	color = BelndLighten( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_SCREEN
	color = BelndScreen( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_COLORDODGE
	color = BelndColorDodge( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_LINEARDODGE
	color = BelndLinearDodge( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_OVERLAY
	color = BelndOverlay( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_HARDLIGHT
	color = BelndHardLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_VIVIDLIGHT
	color = BelndVividLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_LINEARLIGHT
	color = BelndLinearLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_PINLIGHT
	color = BelndPinLight( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_HARDMIX
	color = BelndHardMix( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_DIFFERENCE
	color = BelndDifference( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_EXCLUSION
	color = BelndExclusion( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_SUBSTRACT
	color = BelndSubstract( Base.rgb, Blend.rgb);
#elif _COLORBLENDOP2_DIVISION
	color = BelndDivision( Base.rgb, Blend.rgb);
#endif
	return fixed4( clamp( lerp( Base.rgb, color, ColorRatio), 0.0, 4.0), alpha);
}
/**
Shader
{
	Properties
	{
		[KeywordEnum(None, Override, Multiply, Darken, ColorBurn, LinearBurn, Lighten, Screen, ColorDodge, LinearDodge, Overlay, HardLight, VividLight, LinearLight, PinLight, HardMix, Difference, Exclusion, Substract, Division)]
		_VERTEXCOLORBLENDOP( "Vertex Color Blend Op", float) = 2
		[KeywordEnum(Value, AlphaBlendOp, OneMinusAlphaBlendOp, BaseAlpha, OneMinusBaseAlpha, BlendAlpha, OneMinusBlendAlpha, BaseColorValue, OneMinusBaseColorValue, BlendColorValue, OneMinusBlendColorValue)]
		_VERTEXCOLORBLENDSRC( "Vertex Color Blend Ratop Source", float) = 1
		_VertexColorBlendRatio( "Vertex Color Blend Ratio Value", float) = 1.0
		[KeywordEnum(None, Override, Multiply, Add, Substract, ReverseSubstract, Maximum)]
		_VERTEXALPHABLENDOP( "Vertex Alpha Blend Op", float) = 2
		_VertexAlphaBlendRatio( "Vertex Alpha Blend Ratio Value", float) = 1.0
	}
	SubShader
	{
		Pass
		{
			#pragma shader_feature _VERTEXCOLORBLENDOP_NONE _VERTEXCOLORBLENDOP_OVERRIDE _VERTEXCOLORBLENDOP_MULTIPLY _VERTEXCOLORBLENDOP_DARKEN _VERTEXCOLORBLENDOP_COLORBURN _VERTEXCOLORBLENDOP_LINEARBURN _VERTEXCOLORBLENDOP_LIGHTEN _VERTEXCOLORBLENDOP_SCREEN _VERTEXCOLORBLENDOP_COLORDODGE _VERTEXCOLORBLENDOP_LINEARDODGE _VERTEXCOLORBLENDOP_OVERLAY _VERTEXCOLORBLENDOP_HARDLIGHT _VERTEXCOLORBLENDOP_VIVIDLIGHT _VERTEXCOLORBLENDOP_LINEARLIGHT _VERTEXCOLORBLENDOP_PINLIGHT _VERTEXCOLORBLENDOP_HARDMIX _VERTEXCOLORBLENDOP_DIFFERENCE _VERTEXCOLORBLENDOP_EXCLUSION _VERTEXCOLORBLENDOP_SUBSTRACT _VERTEXCOLORBLENDOP_DIVISION
			#pragma shader_feature _VERTEXCOLORBLENDSRC_VALUE _VERTEXCOLORBLENDSRC_ALPHABLENDOP _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP _VERTEXCOLORBLENDSRC_BASEALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA _VERTEXCOLORBLENDSRC_BLENDALPHA _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA _VERTEXCOLORBLENDSRC_BASECOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
			#pragma shader_feature _VERTEXALPHABLENDOP_NONE _VERTEXALPHABLENDOP_OVERRIDE _VERTEXALPHABLENDOP_MULTIPLY _VERTEXALPHABLENDOP_ADD _VERTEXALPHABLENDOP_SUBSTRACT _VERTEXALPHABLENDOP_REVERSESUBSTRACT _VERTEXALPHABLENDOP_MAXIMUM
		}
	}
}
*/
inline fixed4 VertexColorBlending( fixed4 Base, fixed4 Blend, float ColorRatio, float AlphaRatio)
{
	fixed alpha = Base.a;
#if   _VERTEXALPHABLENDOP_OVERRIDE
	alpha = Blend.a;
#elif _VERTEXALPHABLENDOP_MULTIPLY
	alpha = Base.a * Blend.a;
#elif _VERTEXALPHABLENDOP_ADD
	alpha = Base.a + Blend.a;
#elif _VERTEXALPHABLENDOP_SUBSTRACT
	alpha = Base.a - Blend.a;
#elif _VERTEXALPHABLENDOP_REVERSESUBSTRACT	
	alpha = Blend.a - Base.a;
#elif _VERTEXALPHABLENDOP_MAXIMUM
	alpha = max( Base.a, Blend.a);
#endif
	alpha = saturate( lerp( Base.a, alpha, AlphaRatio));

#if   _VERTEXCOLORBLENDSRC_VALUE
#elif _VERTEXCOLORBLENDSRC_ALPHABLENDOP
	ColorRatio *= alpha;
#elif _VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP
	ColorRatio *= 1.0 - alpha;
#elif _VERTEXCOLORBLENDSRC_BASEALPHA
	ColorRatio *= Base.a;
#elif _VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA
	ColorRatio *= 1.0 - Base.a;
#elif _VERTEXCOLORBLENDSRC_BLENDALPHA
	ColorRatio *= Blend.a;
#elif _VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA
	ColorRatio *= 1.0 - Blend.a;
#elif _VERTEXCOLORBLENDSRC_BASECOLORVALUE
	ColorRatio *= max( Base.r, max( Base.g, Base.b));
#elif _VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE
	ColorRatio *= 1.0 - max( Base.r, max( Base.g, Base.b));
#elif _VERTEXCOLORBLENDSRC_BLENDCOLORVALUE
	ColorRatio *= max( Blend.r, max( Blend.g, Blend.b));
#elif _VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
	ColorRatio *= 1.0 - max( Blend.r, max( Blend.g, Blend.b));
#endif

	fixed3 color = Base.rgb;
#if   _VERTEXCOLORBLENDOP_OVERRIDE
	color = Blend.rgb;
#elif _VERTEXCOLORBLENDOP_MULTIPLY
	color = BelndMultiply( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_DARKEN
	color = BelndDarken( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_COLORBURN
	color = BelndColorBurn( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_LINEARBURN
	color = BelndLinearBurn( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_LIGHTEN
	color = BelndLighten( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_SCREEN
	color = BelndScreen( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_COLORDODGE
	color = BelndColorDodge( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_LINEARDODGE
	color = BelndLinearDodge( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_OVERLAY
	color = BelndOverlay( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_HARDLIGHT
	color = BelndHardLight( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_VIVIDLIGHT
	color = BelndVividLight( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_LINEARLIGHT
	color = BelndLinearLight( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_PINLIGHT
	color = BelndPinLight( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_HARDMIX
	color = BelndHardMix( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_DIFFERENCE
	color = BelndDifference( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_EXCLUSION
	color = BelndExclusion( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_SUBSTRACT
	color = BelndSubstract( Base.rgb, Blend.rgb);
#elif _VERTEXCOLORBLENDOP_DIVISION
	color = BelndDivision( Base.rgb, Blend.rgb);
#endif
	return fixed4( clamp( lerp( Base.rgb, color, ColorRatio), 0.0, 4.0), alpha);
}

#endif /* __BLEND_CGINC__ */
