// ------------------------------------------------------------------
// CONSTANTS --------------------------------------------------------
// ------------------------------------------------------------------

const vec3 PARTICLE_VERTICES[6] = vec3[](
    vec3(-1.0, -1.0, 0.0), // 0
    vec3(1.0, -1.0, 0.0),  // 1
    vec3(-1.0, 1.0, 0.0),  // 2
    vec3(-1.0, 1.0, 0.0),  // 3
    vec3(1.0, -1.0, 0.0),  // 4
    vec3(1.0, 1.0, 0.0)    // 5
);

// ------------------------------------------------------------------
// UNIFORMS ---------------------------------------------------------
// ------------------------------------------------------------------

uniform float u_Rotation;
uniform mat4  u_View;
uniform mat4  u_Proj;

struct Particle
{
    vec4 lifetime;
    vec4 velocity;
    vec4 position;
    vec4 color;
};

layout(std430, binding = 0) buffer ParticleData_t
{
    Particle particles[];
}
ParticleData;

layout(std430, binding = 1) buffer ParticleIndices_t
{
    uint count;
    uint indices[];
}
AliveIndicesPostSim;

// ------------------------------------------------------------------
// MAIN -------------------------------------------------------------
// ------------------------------------------------------------------

void main()
{
    vec3 quad_pos = PARTICLE_VERTICES[gl_VertexID];

    // rotate the billboard:
    mat2 rot = mat2(cos(u_Rotation), -sin(u_Rotation), sin(u_Rotation), cos(u_Rotation));

    quad_pos.xy = rot * quad_pos.xy;

    Particle particle = ParticleData.particles[AliveIndicesPostSim.indices[gl_InstanceID]];

    vec4 position = u_View * vec4(particle.position.xyz, 1.0);
    position.xyz += quad_pos;

    gl_Position = u_Proj * position;
}

// ------------------------------------------------------------------