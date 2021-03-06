# Shader Package

汎用的に使用することができるシェーダを用意しています。  
※シェーダの内容は予告なく変更される場合があります。

# インストール方法

Windows の場合はコマンドプロンプト、Mac、Linux の場合はターミナルで `git` のコマンドが実行可能な状態か事前に確認してから以下の手順を行ってください。

パッケージをインストールしたい Unity プロジェクトを開いている状態で、メニューの `Window` から `PackageManager` を開きます。

![](.Docs/WindowOpen.png)

開かれた PackageManager のウィンドウの左上にある `+` ボタンから
`Add package from git URL...` を選択します。

![](.Docs/Install.png)

URL の入力フォームに以下のアドレスを入力してから Add のボタンを押すとインストールが行われます。
```
https://github.com/devknit/ShaderPackage.git
```

# アンインストール方法

アンインストールする場合は PackageManager から `ZanShader` を選択した状態で `Remove` ボタンを押してください。

![](.Docs/Uninstall.png)

# 導入する際の注意

### グローバルキーワード 

このシェーダパッケージでは以下のグローバルキーワード、計 38 個を宣言します。  

Unity では合計 256 個までグローバルキーワードを宣言できます。  
Unity 内部で約 60 個宣言しているため、シェーダパッケージを追加すると  
宣言できるグローバルキーワードは残り 160 個弱になります。  
[Making multiple shader program variants](https://docs.unity3d.com/Manual/SL-MultipleProgramVariants.html)


```
_VERTEXCOLORBLENDOP_NONE
_VERTEXCOLORBLENDOP_OVERRIDE
_VERTEXCOLORBLENDOP_MULTIPLY
_VERTEXCOLORBLENDOP_DARKEN
_VERTEXCOLORBLENDOP_COLORBURN
_VERTEXCOLORBLENDOP_LINEARBURN
_VERTEXCOLORBLENDOP_LIGHTEN
_VERTEXCOLORBLENDOP_SCREEN
_VERTEXCOLORBLENDOP_COLORDODGE
_VERTEXCOLORBLENDOP_LINEARDODGE
_VERTEXCOLORBLENDOP_OVERLAY
_VERTEXCOLORBLENDOP_HARDLIGHT
_VERTEXCOLORBLENDOP_VIVIDLIGHT
_VERTEXCOLORBLENDOP_LINEARLIGHT
_VERTEXCOLORBLENDOP_PINLIGHT
_VERTEXCOLORBLENDOP_HARDMIX
_VERTEXCOLORBLENDOP_DIFFERENCE
_VERTEXCOLORBLENDOP_EXCLUSION
_VERTEXCOLORBLENDOP_SUBSTRACT
_VERTEXCOLORBLENDOP_DIVISION
_VERTEXCOLORBLENDSRC_VALUE
_VERTEXCOLORBLENDSRC_ALPHABLENDOP
_VERTEXCOLORBLENDSRC_ONEMINUSALPHABLENDOP
_VERTEXCOLORBLENDSRC_BASEALPHA
_VERTEXCOLORBLENDSRC_ONEMINUSBASEALPHA
_VERTEXCOLORBLENDSRC_BLENDALPHA
_VERTEXCOLORBLENDSRC_ONEMINUSBLENDALPHA
_VERTEXCOLORBLENDSRC_BASECOLORVALUE
_VERTEXCOLORBLENDSRC_ONEMINUSBASECOLORVALUE
_VERTEXCOLORBLENDSRC_BLENDCOLORVALUE
_VERTEXCOLORBLENDSRC_ONEMINUSBLENDCOLORVALUE
_VERTEXALPHABLENDOP_NONE
_VERTEXALPHABLENDOP_OVERRIDE
_VERTEXALPHABLENDOP_MULTIPLY
_VERTEXALPHABLENDOP_ADD
_VERTEXALPHABLENDOP_SUBSTRACT
_VERTEXALPHABLENDOP_REVERSESUBSTRACT
_VERTEXALPHABLENDOP_MAXIMUM
```

### シェーダバリアント

提供しているシェーダには複数のキーワードが定義されます。  

このキーワードは `shader_feature` で宣言されているため  
マテリアルで設定したキーワードをプログラムから  
切り替えることができない状態となります。  

また１つのシェーダファイルに含まれるバリアント数が非常に多いため  
異なるキーワードのマテリアルを複数種用意した場合、  
初回レンダリング時にコンパイルによるスパイクが発生する恐れがあります。  

その場合は [Shader.WarmupAllShaders](https://docs.unity3d.com/ScriptReference/Shader.WarmupAllShaders.html) や [ShaderVariantCollection.WarmUp](https://docs.unity3d.com/ScriptReference/ShaderVariantCollection.WarmUp.html) で  
予めコンパイルするようにしてください。

