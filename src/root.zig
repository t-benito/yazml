pub const Vec2 = @import("vec2.zig").Vec2;

/// 32-bit integer `Vec2`
pub const Vec2i = Vec2(i32);

/// 64-bit integer `Vec2`
pub const Vec2l = Vec2(i64);

/// 32-bit floating `Vec2`
pub const Vec2f = Vec2(f32);

/// 64-bit floating `Vec2`
pub const Vec2d = Vec2(f64);

pub const Vec3 = @import("vec3.zig").Vec3;

/// 32-bit integer `Vec3`
pub const Vec3i = Vec3(i32);

/// 64-bit integer `Vec3`
pub const Vec3l = Vec3(i64);

/// 32-bit floating `Vec3`
pub const Vec3f = Vec3(f32);

/// 64-bit floating `Vec3`
pub const Vec3d = Vec3(f64);

pub const Vec4 = @import("vec4.zig").Vec4;

/// 32-bit integer `Vec4`
pub const Vec4i = Vec4(i32);

/// 64-bit integer `Vec4`
pub const Vec4l = Vec4(i64);

/// 32-bit floating `Vec4`
pub const Vec4f = Vec4(f32);

/// 64-bit floating `Vec4`
pub const Vec4d = Vec4(f64);

pub const Mat4 = @import("mat4.zig").Mat4;

/// 32-bit floating `Mat4`
pub const Mat4f = Mat4(f32);

/// 64-bit floating `Mat4`
pub const Mat4d = Mat4(f64);

const VecB = @import("vec_b.zig").VecB;

pub const Vec2b = VecB(2);
pub const Vec3b = VecB(3);
pub const Vec4b = VecB(4);
