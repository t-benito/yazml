const vec2 = @import("vec2.zig");

pub const Vec2 = vec2.Vec2;

/// 32-bit integer vector2
pub const Vec2i = Vec2(i32);

/// 64-bit integer vector2
pub const Vec2l = Vec2(i64);

/// 32-bit floating vector2
pub const Vec2f = Vec2(f32);

/// 64-bit floating vector2
pub const Vec2d = Vec2(f64);

const vec3 = @import("vec3.zig");

pub const Vec3 = vec3.Vec3;

pub const Vec3i = Vec3(i32);
pub const Vec3l = Vec3(i64);
pub const Vec3f = Vec3(f32);
pub const Vec3d = Vec3(f64);

const vec4 = @import("vec4.zig");

pub const Vec4 = vec4.Vec4;

pub const Vec4i = Vec4(i32);
pub const Vec4l = Vec4(i64);
pub const Vec4f = Vec4(f32);
pub const Vec4d = Vec4(f64);

const mat4 = @import("mat4.zig");

pub const Mat4 = mat4.Mat4;

pub const Mat4f = Mat4(f32);
pub const Mat4d = Mat4(f64);
