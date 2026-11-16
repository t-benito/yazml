const std = @import("std");
const m = @import("root.zig");

pub fn Quat(comptime T: type) type {
    const Vec3 = m.Vec3(T);
    const Vec4 = m.Vec4(T);
    return struct {
        const Self = @This();

        xyz: Vec3,
        w: T,

        pub fn init(xyz: Vec3, w: T) Self {
            return .{
                .xyz = xyz,
                .w = w,
            };
        }

        pub fn fromRot(x: T, y: T, z: T) Self {
            x *= 0.5;
            y *= 0.5;
            z *= 0.5;

            const c1 = @cos(x);
            const c2 = @cos(y);
            const c3 = @cos(z);
            const s1 = @sin(x);
            const s2 = @sin(y);
            const s3 = @sin(z);

            return init(
                .init(
                    (s1 * c2 * c3) + (c1 * s2 * s3),
                    (c1 * s2 * c3) - (s1 * c2 * s3),
                    (c1 * c2 * s3) + (s1 * s2 * c3),
                ),
                (c1 * c2 * c3) - (c1 * s2 * s3),
            );
        }

        pub fn len(self: Quat) T {
            return @sqrt((self.w * self.w) + self.xyz.lenSqr());
        }

        /// Returns this `Quat` as an axis-angle representation.
        pub fn axisAngle(self: Quat) Vec4 {
            if (@abs(self.w) > 1.0)
                self.normalizeEq();

            var res = Vec4.ZERO;
            res.w = 2.0 * std.math.acos(self.w);

            const den = @sqrt(1.0 - (self.w * self.w));
            if (den > 0.0001) {
                res.x = self.xyz.x / den;
                res.y = self.xyz.y / den;
                res.z = self.xyz.z / den;
            } else {
                res.x = Vec3.UNIT_X.x;
                res.y = Vec3.UNIT_X.y;
                res.z = Vec3.UNIT_X.z;
            }

            return res;
        }

        /// Returns a new `Quat` containing the normalized values of this.
        pub fn normalize(self: Quat) Quat {
            const scale = 1.0 / self.len();
            return init(
                self.xyz.mulS(scale),
                self.w * scale,
            );
        }

        /// Normalizes this `Quat` to unit length (1) in-place.
        /// If you want to get a new one without modifying this one, use `normalize` instead.
        pub fn normalizeEq(self: *Quat) Quat {
            const scale = 1.0 / self.len();
            self.xyz.mulEqS(scale);
            self.w *= scale;
        }
    };
}
