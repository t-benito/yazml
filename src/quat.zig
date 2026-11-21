const std = @import("std");
const math = std.math;
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

        pub fn len(self: Self) T {
            return @sqrt((self.w * self.w) + self.xyz.lenSqr());
        }

        pub fn lenSqr(self: Self) T {
            return (self.w * self.w) + self.xyz.lenSqr();
        }

        /// Returns this `Quat` as an axis-angle representation.
        pub fn axisAngle(self: Self) Vec4 {
            if (@abs(self.w) > 1.0)
                self.normalizeEq();

            var res = Vec4.ZERO;
            res.w = 2.0 * math.acos(self.w);

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

        /// Returns this `Quat` as an euler angle representation.
        pub fn toEuler(self: Self) Vec3 {
            const res = Vec3.ZERO;

            const threshold = 0.4999995;

            const sqw = self.w * self.w;
            const sqx = self.xyz.x * self.xyz.x;
            const sqy = self.xyz.y * self.xyz.y;
            const sqz = self.xyz.z * self.xyz.z;
            const unit = sqx * sqy + sqz + sqw;

            const thresTest = (self.xyz.x * self.xyz.z) + (self.w * self.xyz.y);
            if (thresTest > threshold * unit) {
                res.z = 2 * math.atan2(self.xyz.x, self.w);
                res.y = math.pi / 2;
                res.x = 0;
            } else if (thresTest < -threshold * unit) {
                res.z = -2 * math.atan2(self.xyz.x, self.xyz.w);
                res.y = -math.pi / 2;
                res.x = 0;
            } else {
                res.z = math.atan2(2 * ((self.w * self.xyz.z) - (self.xyz.x * self.xyz.y)), sqw + sqx - sqy - sqz);
                res.y = math.asin(2 * thresTest / unit);
                res.x = math.atan2(2 * ((self.w * self.xyz.x) - (self.xyz.y * self.xyz.z)), sqw - sqx - sqy + sqz);
            }

            return res;
        }

        /// Returns a new `Quat` containing the normalized values of this.
        pub fn normalize(self: Self) Self {
            const scale = 1.0 / self.len();
            return init(
                self.xyz.mulS(scale),
                self.w * scale,
            );
        }

        /// Normalizes this `Quat` to unit length (1) in-place.
        /// If you want to get a new one without modifying this one, use `normalize` instead.
        pub fn normalizeEq(self: *Self) void {
            const scale = 1.0 / self.len();
            self.xyz.mulEqS(scale);
            self.w *= scale;
        }

        /// Returns the inverse of this `Quat`.
        pub fn invert(self: Self) Self {
            const lensq = self.lenSqr();
            if (lensq != 0.0) {
                const i = 1.0 / lensq;
                return init(
                    self.xyz.mulS(-i),
                    self.w * i,
                );
            }
            return self.*;
        }
    };
}
