Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _Speed("Speed", Range(0,100)) = 25.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"  "Queue"="Transparent"}
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        /*5. Ajouter la variable nécessaire pour avoir accès à la vitesse de déroulement dans le
            SubShader.*/
        float _Speed;
        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 scrolledUV = IN.uv_MainTex;

            fixed xScrollValue = _Speed * _Time;
            //fixed yScrollValue = _Speed * _Time;

            scrolledUV += fixed2(xScrollValue, 0);

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, scrolledUV) * _Color * tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.r + c.g + c.b;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
