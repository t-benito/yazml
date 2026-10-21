const vec2 = @import("vec2.zig");

pub const Vec2 = vec2.Vec2;

/// 32-bit integer vector2
pub const Vec2i = Vec2(i32);

/// 32-bit floating vector2
pub const Vec2f = Vec2(f32);

/// 64-bit floating vector2
pub const Vec2d = Vec2(f64);
