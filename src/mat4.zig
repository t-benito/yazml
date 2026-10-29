// Copyright (c) 2026 benito. Licensed under the MIT license.

const std = @import("std");
const m = @import("root.zig");

/// A generic 4 by 4 matrix parameterized by numerical type `T`.
pub fn Mat4(comptime T: type) type {
    const Vec4 = m.Vec4(T);
    const Vec3 = m.Vec3(T);
    return struct {
        const Self = @This();

        cols: [4]Vec4,

        // TODO: documntation
        pub const ZERO = Self.init(Vec4.ZERO, Vec4.ZERO, Vec4.ZERO, Vec4.ZERO);

        /// Returns a new `Mat4` with the given columns.
        pub fn init(col0: Vec4, col1: Vec4, col2: Vec4, col3: Vec4) Self {
            return .{
                .cols = [4]Vec4{ col0, col1, col2, col3 },
            };
        }

        /// Returns a copy of the first row of this matrix.
        pub fn row0(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].x,
                self.cols[1].x,
                self.cols[2].x,
                self.cols[3].x,
            );
        }

        /// Returns a copy of the second row of this matrix.
        pub fn row1(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].y,
                self.cols[1].y,
                self.cols[2].y,
                self.cols[3].y,
            );
        }

        /// Returns a copy of the third row of this matrix.
        pub fn row2(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].z,
                self.cols[1].z,
                self.cols[2].z,
                self.cols[3].z,
            );
        }

        /// Returns a copy of the fourth row of this matrix.
        pub fn row3(self: *const Self) Vec4 {
            return Vec4.init(
                self.cols[0].w,
                self.cols[1].w,
                self.cols[2].w,
                self.cols[3].w,
            );
        }

        /// Returns a perspective projection matrix.
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

        /// Returns an orthographic projection matrix.
        pub fn createOrthographic(width: f32, height: f32, depthNear: f32, depthFar: f32) Self {
            const left = -width / 2;
            const right = width / 2;
            const btm = -height / 2;
            const top = height / 2;

            const invRl = 1.0 / (right - left);
            const invTb = 1.0 / (top - btm);
            const invFn = 1.0 / (depthFar - depthNear);

            return Self.init(
                Vec4.init(2.0 * invRl, 0.0, 0.0, 0.0),
                Vec4.init(0.0, 2.0 * invTb, 0.0, 0.0),
                Vec4.init(0.0, 0.0, -2.0 * invFn, 0.0),
                Vec4.init(
                    -(right + left) * invRl,
                    -(top + btm) * invTb,
                    -(depthFar + depthNear) * invFn,
                    1.0,
                ),
            );
        }

        /// Returns a view matrix at `eye`, looking at `target`.
        /// If you are using OpenGL, you must set `transpose` to `false` for the result of this function to be correct.
        pub fn lookAt(eye: Vec3, target: Vec3, up: Vec3) Self {
            const z = eye.sub(target).normalize();
            const x = up.cross(z).normalize();
            const y = z.cross(x).normalize();

            return Self.init(
                Vec4.init(x.x, y.x, z.x, 0.0),
                Vec4.init(x.y, y.y, z.y, 0.0),
                Vec4.init(x.z, y.z, z.z, 0.0),
                Vec4.init(
                    -((x.x * eye.x) + (x.y * eye.y) + (x.z * eye.z)),
                    -((y.x * eye.x) + (y.y * eye.y) + (y.z * eye.z)),
                    -((z.x * eye.x) + (z.y * eye.y) + (z.z * eye.z)),
                    1.0,
                ),
            );
        }
    };
}
