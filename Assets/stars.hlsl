void sdStar_float(in float2 p, in float r, in float n, in float m, out float Out)
{
    // next 4 lines can be precomputed for a given shape
    float an = 3.141593/float(n);
    float en = 3.141593/m;  // m is between 2 and n
    float2  acs = float2(cos(an),sin(an));
    float2  ecs = float2(cos(en),sin(en)); // ecs=vec2(0,1) for regular polygon

    float bn = fmod(atan2(p.x,p.y),2.0*an) - an;
    p = length(p)*float2(cos(bn),abs(sin(bn)));
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    Out = length(p)*sign(p.x);
}