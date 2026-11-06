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

        /// `Mat4` with all components set to `(0, 0, 0, 0)`.
        pub const ZERO = init(.ZERO, .ZERO, .ZERO, .ZERO);

        // TODO: This comment is a placeholder... i dont have an idea.
        /// The boring matrix.
        pub const IDENTITY = init(
            .init(1, 0, 0, 0),
            .init(0, 1, 0, 0),
            .init(0, 0, 1, 0),
            .init(0, 0, 0, 1),
        );

        /// Returns a new `Mat4` with the given columns.
        pub fn init(col0: Vec4, col1: Vec4, col2: Vec4, col3: Vec4) Self {
            return .{
                .cols = [4]Vec4{ col0, col1, col2, col3 },
            };
        }

        // comment TODO
        pub fn fromDiag(vec: Vec4) Self {
            return init(
                .init(vec.x, 0, 0, 0),
                .init(0, vec.y, 0, 0),
                .init(0, 0, vec.z, 0),
                .init(0, 0, 0, vec.w),
            );
        }

        /// Returns a copy of the first row of this matrix.
        pub fn row0(self: *const Self) Vec4 {
            return .init(
                self.cols[0].x,
                self.cols[1].x,
                self.cols[2].x,
                self.cols[3].x,
            );
        }

        /// Returns a copy of the second row of this matrix.
        pub fn row1(self: *const Self) Vec4 {
            return .init(
                self.cols[0].y,
                self.cols[1].y,
                self.cols[2].y,
                self.cols[3].y,
            );
        }

        /// Returns a copy of the third row of this matrix.
        pub fn row2(self: *const Self) Vec4 {
            return .init(
                self.cols[0].z,
                self.cols[1].z,
                self.cols[2].z,
                self.cols[3].z,
            );
        }

        /// Returns a copy of the fourth row of this matrix.
        pub fn row3(self: *const Self) Vec4 {
            return .init(
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

            return init(
                .init(x, 0, a, 0), // x row
                .init(0, y, b, 0), // y row
                .init(0, 0, c, d), // z row
                .init(0, 0, -1, 0), // w row
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

            return init(
                .init(2.0 * invRl, 0.0, 0.0, 0.0),
                .init(0.0, 2.0 * invTb, 0.0, 0.0),
                .init(0.0, 0.0, -2.0 * invFn, 0.0),
                .init(
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

            return init(
                .init(x.x, y.x, z.x, 0.0),
                .init(x.y, y.y, z.y, 0.0),
                .init(x.z, y.z, z.z, 0.0),
                .init(
                    -((x.x * eye.x) + (x.y * eye.y) + (x.z * eye.z)),
                    -((y.x * eye.x) + (y.y * eye.y) + (y.z * eye.z)),
                    -((z.x * eye.x) + (z.y * eye.y) + (z.z * eye.z)),
                    1.0,
                ),
            );
        }

        /// Returns this matrix as an array of arrays of `T`.
        pub fn toArray(self: *const Self) [4][4]T {
            const arr = [4][4]T{};
            inline for (0..4) |i| {
                arr[i] = self.cols[i].toArray();
            }
            return arr;
        }

        /// Returns a new matrix resulting from 4x4 matrix multiplication with `other`.
        pub fn mul(self: *const Self, other: Self) Self {
            var res = ZERO;
            inline for (0..4) |i| {
                res.cols[i] = self.cols[0].mulS(other.cols[i].x)
                    .addV(self.cols[1].mulS(other.cols[i].y))
                    .addV(self.cols[2].mulS(other.cols[i].z))
                    .addV(self.cols[3].mulS(other.cols[i].w));
            }
            return res;
        }

        /// Multiplies this matrix by `other` in-place.
        /// If you want to get a new matrix without modifying this one, use `mul` instead.
        pub fn mulEq(self: *const Self, other: Self) void {
            inline for (0..4) |i| {
                const c = self.cols[0].mulS(other.cols[i].x)
                    .addV(self.cols[1].mulS(other.cols[i].y))
                    .addV(self.cols[2].mulS(other.cols[i].z))
                    .addV(self.cols[3].mulS(other.cols[i].w));
                self.cols[i] = c;
            }
        }

        /// Returns the inverse of this matrix, or `null` if
        /// the matrix is singular.
        pub fn invert(self: *const Self) ?Self {
            const c0 = self.cols[0];
            const c1 = self.cols[1];
            const c2 = self.cols[2];
            const c3 = self.cols[3];

            const s0 = c0.x * c1.y - c0.y * c1.x;
            const s1 = c0.x * c1.z - c0.z * c1.x;
            const s2 = c0.x * c1.w - c0.w * c1.x;
            const s3 = c0.y * c1.z - c0.z * c1.y;
            const s4 = c0.y * c1.w - c0.w * c1.y;
            const s5 = c0.z * c1.w - c0.w * c1.z;

            const cc0 = c2.x * c3.y - c2.y * c3.x;
            const cc1 = c2.x * c3.z - c2.z * c3.x;
            const cc2 = c2.x * c3.w - c2.w * c3.x;
            const cc3 = c2.y * c3.z - c2.z * c3.y;
            const cc4 = c2.y * c3.w - c2.w * c3.y;
            const cc5 = c2.z * c3.w - c2.w * c3.z;

            const det = s0 * cc5 - s1 * cc4 + s2 * cc3 + s3 * cc2 - s4 * cc1 + s5 * cc0;
            if (@abs(det) < 1e-6)
                return null;
            const invDet = 1.0 / det;

            return init(
                .init(
                    ( c1.y * cc5 - c1.z * cc4 + c1.w * cc3) * invDet,
                    (-c0.y * cc5 + c0.z * cc4 - c0.w * cc3) * invDet,
                    ( c3.y * s5  - c3.z * s4  + c3.w * s3 ) * invDet,
                    (-c2.y * s5  + c2.z * s4  - c2.w * s3 ) * invDet,
                ),
                .init(
                    (-c1.x * cc5 + c1.z * cc2 - c1.w * cc1) * invDet,
                    ( c0.x * cc5 - c0.z * cc2 + c0.w * cc1) * invDet,
                    (-c3.x * s5  + c3.z * s2  - c3.w * s1 ) * invDet,
                    ( c2.x * s5  - c2.z * s2  + c2.w * s1 ) * invDet,
                ),
                .init(
                    ( c1.x * cc4 - c1.y * cc2 + c1.w * cc0) * invDet,
                    (-c0.x * cc4 + c0.y * cc2 - c0.w * cc0) * invDet,
                    ( c3.x * s4  - c3.y * s2  + c3.w * s0 ) * invDet,
                    (-c2.x * s4  + c2.y * s2  - c2.w * s0 ) * invDet,
                ),
                .init(
                    (-c1.x * cc3 + c1.y * cc1 - c1.z * cc0) * invDet,
                    ( c0.x * cc3 - c0.y * cc1 + c0.z * cc0) * invDet,
                    (-c3.x * s3  + c3.y * s2  - c3.z * s0 ) * invDet,
                    ( c2.x * s3  - c2.y * s2  + c2.z * s0 ) * invDet,
                ),
            );
        }
    };
}
