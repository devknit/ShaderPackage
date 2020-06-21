
namespace ZanShader.Editor
{
	class DepthStencilStatus : MaterialPropertyGroup
	{
		public DepthStencilStatus() : base( "Depth Stencil Status", kPropertyNames)
		{
		}
		protected override bool GroupFoldout
		{
			get{ return foldoutFlag; }
			set{ foldoutFlag = value; }
		}
		static readonly string[] kPropertyNames = new string[]
		{
			"_StencilRef",
			"_StencilReadMask",
			"_StencilWriteMask",
			"_StencilComp",
			"_StencilPass",
			"_StencilFail",
			"_StencilZFail",
		};
		static bool foldoutFlag = false;
	}
}
