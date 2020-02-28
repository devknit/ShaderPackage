# Zan Shaders

ココでは汎用で使用することができるシェーダを用意しています。

# シェーダの命名規則

汎用で使用することができるシェーダは  
必ず `ZanLib/` というプレフィックスが付きます。

続いてシェーダの系統毎にディレクトリを指定した後  
固有の名称をつけるようにしてください。

現在想定している系統は以下になります。

| 系統       | 内容                                   |
|:-----------|:---------------------------------------|
| Unlit      | ライティングを使用しない               |
| Procedural | テクスチャを使用せずに模様を生成します |


# プロパティ

汎用シェーダでは共通のプロパティが用意されています。

![](.Docs/inspector.png)

## Blending Presets

以下の[Blend Status](#blending-status)のプリセットを選択することが出来ます。  


| 定義名                | ブレンディング       | BlendOp          | Src Factor       | Dst Factor       | Use Blend Factor | Blend Factor      |
| --------------------- | -------------------- | ---------------- | ---------------- | ---------------- | ---------------- | ----------------- |
| <b>None</b>           | 無効                 | Add              | One              | Zero             | Off              | (  0,  0,  0,  0) |
| <b>SrcAlpha</b>       | 出力結果のアルファ値 | Add              | SrcAlpha         | OneMinusSrcColor | Off              | (  0,  0,  0,  0) |
| <b>DstAlpha</b>       | バッファのアルファ値 | Add              | DstAlpha         | OneMinusDstColor | Off              | (  0,  0,  0,  0) |
| <b>Add</b>            | 加算                 | Add              | SrcAlpha         | One              | Off              | (  0,  0,  0,  0) |
| <b>Substract</b>      | 減算                 | ReverseSubstract | SrcAlpha         | One              | Off              | (  0,  0,  0,  0) |
| <b>Multiply</b>       | 乗算                 | Add              | Zero             | SrcColor         | On               | (255,255,255,255) |
| <b>Screen</b>         | スクリーン           | Add              | OneMinusDstColor | One              | On               | (  0,  0,  0,255) |
| <b>Exclude</b>        | 除外                 | Add              | OneMinusDstColor | OneMinusSrcColor | On               | (  0,  0,  0,255) |
| <b>CompareBright</b>  | 比較(明)             | Max              | One              | One              | On               | (  0,  0,  0,255) |
| <b>CompareDark</b>    | 比較(暗)             | Min              | One              | One              | On               | (255,255,255,255) |
| <b>ColorDouble</b>    | カラー２倍           | Add              | DstColor         | One              | On               | (  0,  0,  0,255) |
| <b>MultiplyDouble</b> | 乗算２倍             | Add              | DstColor         | SrcColor         | On               | (128,128,128,255) |

## Shader Variants

シェーダバリアントと呼ばれる一部の処理を変更することが出来る機能です。
現在組み込まれている機能は以下になります。 

| Setting | 説明 |
| ------- | ---- |
| <b>Vertex Color Blend Op</b> | 頂点カラーをブレンドする方法を指定<br>詳細は[こちら](#color-blend-op)を参照してください。 |
| <b>Use Blend Factor</b> | Blend Factor の設定を有効にします。<br>オンにすることでCPU、GPUの使用メモリと処理が増加します。 |

## Rendering Status

レンダリングステータスを設定します。

### Cull

ポリゴンのどちら側をカリングする（描画しない）か制御 

| Setting | 説明 |
| ------- | ---- |
| <b>Off</b>   | カリングを無効にして、すべての面を描画します。(デフォルト) |
| <b>Front</b> | 視点と同じ側のポリゴンをレンダリングしない。               |
| <b>Back</b>  | 視点と反対側のポリゴンをレンダリングしない。               |

### ZWrite

深度バッファに書き込みするか制御  

| Setting | 説明 |
| ------- | ---- |
| <b>Off</b> | 深度バッファへの書き込みを行わない。(デフォルト) |
| <b>On</b>  | 深度バッファへの書き込みを行う。                 |

### ZTest

深度テストの実行方法

| Setting | 説明 |
| ------- | ---- |
| <b>Disabled</b>     | テストを無効                         |
| <b>Never</b>        | 常にパスしない                       |
| <b>Less</b>         | 新しい値が古い値より小さいときにパス |
| <b>Equal</b>        | 新しい値が古い値と等しいときにパス   |
| <b>LessEqual</b>    | 新しい値が古い値以下ときにパス       |
| <b>Greater</b>      | 新しい値が古い値より大きいときにパス |
| <b>NotEqual</b>     | 新しい値が古い値と異なるときにパス   |
| <b>GreaterEqual</b> | 新しい値が古い値以上ときにパス       |
| <b>Always</b>       | 常にパス(デフォルト)                 |

### Color Mask

レンダリングターゲットに書き込む成分を指定

| Setting | 説明 |
| ------- | ---- |
| <b>Off</b>   | 書き込みを行いません。                   |
| <b>R</b>     | 赤成分のみ書き込みを行います。           |
| <b>G</b>     | 緑成分のみ書き込みを行います。           |
| <b>B</b>     | 青成分のみ書き込みを行います。           |
| <b>A</b>     | アルファ成分のみ書き込みを行います。     |
| <b>RGB</b>   | アルファ成分以外を書き込みます。         |
| <b>RGBA</b>  | すべての成分を書き込みます。(デフォルト) |

Android、iPhone 等の PowerVR 系の GPU を搭載している場合  
特定のカラーチャンネルを書き込まないための処理は高コストになるため  
基本的に RGBA を使用するようにしてください。

## Blending Status

レンダリングターゲットへ書き込む際に行われるブレンドを指定します。

ココではシェーダから出力された色情報(Source)と  
現在描画対象になっているターゲットバッファ(Destination)を使って  
最終的に出力される結果を求めるための式を設定しています。

式は以下のようになっています。

`= (Source) * [Src Factor] [BlendOp] (Destination) * [Dst Factor]`

アルファブレンドを行いたい場合では以下のようになります。

`= (Source) * [(Source).a] [+] (Destination) * [1.0 - (Source).a]`

ブレンドを行わない場合では以下のようになります。

`= (Source) * [1] [+] (Destination) * [0]`

各要素はカラー(RGB)とアルファそれぞれ設定することが出来ます。

### Color Blend Op, Alpha Blend Op

ブレンドオペレータ  

| Setting                | 説明                                                       |
| ---------------------- | ---------------------------------------------------------- |
| <b>Add</b>             | ソースとターゲットを指定されたブレンドモードで加算します。 |
| <b>Substract</b>       | ターゲットからソースを減算します。                         |
| <b>ReverseSubtract</b> | ソースからターゲットを減算します。                         |
| <b>Min</b>             | ソースとターゲットのうち小さい値を選択します。             |
| <b>Max</b>             | ソースとターゲットのうち大きい値を選択します。             |
| etc.                   | 他のオペレータは使用しないでください。                     |

### Color Src Factor, Color Dst Factor, Alpha Src Factor, Alpha Dst Factor

カラー成分、またはアルファ成分のSource、Destinationファクター

| Setting                  | 説明                                      |
| ------------------------ | ----------------------------------------- |
| <b>Zero</b>             | (0, 0, 0, 0)                               |
| <b>One</b>              | (1, 1, 1, 1)                               |
| <b>DstColor</b>         | (Rd, Gd, Bd, Ad)                           |
| <b>SrcColor</b>         | (Rs, Gs, Bs, As)                           |
| <b>OneMinusDstColor</b> | (1 - Rd, 1 - Gd, 1 - Bd, 1 - Ad)           |
| <b>SrcAlpha</b>         | (As, As, As, As)                           |
| <b>OneMinusSrcColor</b> | (1 - Rs, 1 - Gs, 1 - Bs, 1 - As)           |
| <b>DstAlpha</b>         | (Ad, Ad, Ad, Ad)                           |
| <b>OneMinusDstAlpha</b> | (1 - Ad, 1 - Ad, 1 - Ad, 1 - Ad)           |
| <b>SrcAlphaSaturate</b> | f = min(As, 1 - Ad) の場合に (f, f, f, 1)  |
| <b>OneMinusSrcAlpha</b> | (1 - As, 1 - As, 1 - As, 1 - As)           |

設定は [Blending Presets](#blending-presets) を参照ください。  

### Blend Factor

ピクセルシェーダからの出力直前に RGB 成分に対してアルファブレンドを行います。  
乗算やスクリーン等でアルファ値を正しく反映させるために利用されます。  
[Use Blend Factor](#blending-presets) が無効な場合設定は反映されません。  
	
## Depth Stencil Status

デプスステンシルバッファの読み書きに関する設定を行います。
- <b>Stencil Reference</b> - 基準値  
  バッファの内容との比較、または比較の結果値を書き込む場合に用いられます。  
- <b>Stencil Read Mask</b> - 読み込みマスク  
  バッファの内容と基準値を比較する場合に指定の値を用いて 8 ビットマスクを行います。  
- <b>Stencil Write Mask</b> - 書き込みマスク  
  バッファへの書き込みを行う際に指定の値を用いて 8 ビットマスクを行います。  
- <b>Stencil Comparison Function</b> - 比較方法  
  バッファの現在の内容と基準値の比較する方法を指定します。  
- <b>Stencil Pass Operation</b> - パスした場合の動作  
  ステンシルテスト(及びデプステスト)をパスした場合、バッファの内容をどうするか決めます。  
- <b>Stencil Fail Operation</b> - 失敗した場合の動作  
  ステンシルテストが失敗した場合、バッファの内容をどうするか決めます。  
- <b>Stencil ZFail Operation</b> - 失敗した場合の動作  
  ステンシルテストにパスし、デプステストを失敗した場合、バッファの内容をどうするか決めます。  

## System Status

Unity からデフォルトで提供されているステータスを設定します。  

### Render Queue

Unity のシステムとして用意されているレンダリング順を基底にした値を入力します。  
UnityZanLib で用意しているシェーダはすべて Transparent (3000) を基底としています。  

| Unityの基底定義 | 基底値 | 説明 |
| --------------- | ------ | ---- |
| <b>Background</b> | 1000 | 一般的には、背景にのみに使用します。 |
| <b>Geometry</b> | 2000 | 不透明なジオメトリはこのキューを使用します。 |
| <b>AlphaTest</b> | 2450 | アルファテストする形状でこのキューを使用します。 |
| <b>Transparent</b> | 3000 | アルファブレンディングする場合はこのキューを使用します。 |
| <b>Overlay</b> | 4000 | 最後にレンダリングする場合はこのキューを使用します。 |

## Color Blend Op

２つの色を [Adobe AfterEffects/Photoshop](https://helpx.adobe.com/jp/photoshop/using/blending-modes.html) の方法でブレンドします。

| Setting | ブレンド名 |
| ------- | ---------- |
| <b>None</b> | ブレンドしません |
| <b>Darken</b> | 比較(暗) |
| <b>Multiply</b> | 乗算 |
| <b>ColorBurn</b> | 焼き込みカラー |
| <b>LinearBurn</b> | 焼き込みリニア |
| <b>Lighten</b> | 比較(明) |
| <b>Screen</b> | スクリーン |
| <b>ColorDodge</b> | 覆い焼きカラー |
| <b>LinearDodge</b> | 覆い焼きリニア |
| <b>Overlay</b> | オーバーレイ |
| <b>HardLight</b> | ハードライト |
| <b>VividLight</b> | ビビッドライト |
| <b>LinearLight</b> | リニアライト |
| <b>PinLight</b> | ピンライト |
| <b>HardMix</b> | ハードミックス |
| <b>Difference</b> | 差 |
| <b>Exclusion</b> | 除外 |
| <b>Substract</b> | 減算 |
| <b>Division</b> | 除算 |

Shader Uniform に存在するプロパティになっており、  
全てのシェーダに存在するわけではありません。  

## Alpha Blend Op

２つのアルファ値をブレンドします。

| Setting | ブレンド名 |
| ------- | ---------- |
| <b>None</b> | ブレンドしません |
| <b>Multiply</b> | 乗算 |
| <b>Minimum</b> | 低い値を使用します |
| <b>Maximum</b> | 高い値を使用します |

Shader Uniform に存在するプロパティになっており、  
全てのシェーダに存在するわけではありません。  
