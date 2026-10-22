const std = @import("std");
const m = @import("root.zig");

pub fn Mat4(comptime T: type) type {
    const Vec4 = m.Vec4(T);
    return struct {
        const Self = @This();

        cols: [4]Vec4,

        pub const ZERO = Self.init(Vec4.ZERO, Vec4.ZERO, Vec4.ZERO, Vec4.ZERO);

        pub fn init(col0: Vec4, col1: Vec4, col2: Vec4, col3: Vec4) Self {
            return .{
                .cols = [4]Vec4{ col0, col1, col2, col3 },
            };
        }

        pub fn row0(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].x,
                self.cols[1].x,
                self.cols[2].x,
                self.cols[3].x,
            );
        }

        pub fn row1(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].y,
                self.cols[1].y,
                self.cols[2].y,
                self.cols[3].y,
            );
        }

        pub fn row2(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].z,
                self.cols[1].z,
                self.cols[2].z,
                self.cols[3].z,
            );
        }

        pub fn row3(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].w,
                self.cols[1].w,
                self.cols[2].w,
                self.cols[3].w,
            );
        }

        pub fn createPerspective(fovy: f32, aspect: f32, depthNear: f32, depthFar: f32) Self {
            std.debug.assert(fovy > 0 and fovy <= std.math.pi and aspect > 0 and depthNear > 0 and depthFar > 0);

            const top = depthNear * @tan(0.5 * fovy);
            const btm = -top;
            const left = btm * aspect;
            const right = top * aspect;

            const x = 2.0 * depthNear / (right - left);
            const y = 2.0 * depthNear / (top - btm);
            const a = (right + left) / (right - left);
            const b = (top + btm) / (top - btm);
            const c = -(depthFar + depthNear) / (depthFar - depthNear);
            const d = -(2.0 * depthFar * depthNear) / (depthFar - depthNear);

            return Self.init(
                Vec4.init(x, 0, a, 0), // x row
                Vec4.init(0, y, b, 0), // y row
                Vec4.init(0, 0, c, d), // z row
                Vec4.init(0, 0, -1, 0), // w row
            );
        }
    };
}
