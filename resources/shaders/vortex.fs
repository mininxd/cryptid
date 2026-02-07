#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP float vortex_amt;
extern MY_HIGHP_OR_MEDIUMP float DPI;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    vertex_position = vertex_position*DPI;
    MY_HIGHP_OR_MEDIUMP vec2 uv = (vertex_position.xy - 0.5*love_ScreenSize.xy )/length(love_ScreenSize.xy);

    MY_HIGHP_OR_MEDIUMP float effectRadius = 1.6 - 0.05*vortex_amt;
    MY_HIGHP_OR_MEDIUMP float effectAngle = 0.5 + 0.15*vortex_amt;
    
    MY_HIGHP_OR_MEDIUMP float len = length(uv * vec2(love_ScreenSize.x / love_ScreenSize.y, 1.));
    MY_HIGHP_OR_MEDIUMP float angle = atan(uv.y, uv.x) + effectAngle * smoothstep(effectRadius, 0., len);
    MY_HIGHP_OR_MEDIUMP float radius = length(uv);

    MY_HIGHP_OR_MEDIUMP vec2 center = 0.5*love_ScreenSize.xy/length(love_ScreenSize.xy);

    vertex_position.x = (radius * cos(angle) + center.x)*length(love_ScreenSize.xy);
    vertex_position.y = (radius * sin(angle) + center.y)*length(love_ScreenSize.xy);
    return transform_projection * vertex_position;
}
#endif