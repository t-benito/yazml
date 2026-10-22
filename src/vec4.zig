const std = @import("std");

/// A generic 3D vector struct parameterized by numerical type `T`.
pub fn Vec4(comptime T: type) type {
    return struct {
        const Self = @This();

        /// X component of the vector.
        x: T,
        /// Y component of the vector.
        y: T,
        /// Z component of the vector.
        z: T,
        /// W component of the vector.
        w: T,

        /// `(1, 0, 0, 0)`
        pub const UNIT_X = Self.init(1, 0, 0, 0);
        /// `(0, 1, 0, 0)`
        pub const UNIT_Y = Self.init(0, 1, 0, 0);
        /// `(0, 0, 1, 0)`
        pub const UNIT_Z = Self.init(0, 0, 1, 0);
        /// `(0, 0, 0, 1)`
        pub const UNIT_W = Self.init(0, 0, 0, 1);
        /// Zero vector `(0, 0, 0, 0)`.
        pub const ZERO = Self.init(0, 0, 0, 0);
        /// One vector `(1, 1, 1, 1)`.
        pub const ONE = Self.init(1, 1, 1, 1);

        /// Initializes and returns a new 3D vector with the given `x`, `y`, and `z` coordinates.
        pub fn init(x: T, y: T, z: T, w: T) Self {
            return .{
                .x = x,
                .y = y,
                .z = z,
                .w = w,
            };
        }

        /// Calculates and returns the magnitude (length) of the vector.
        pub fn len(self: *const Self) T {
            const res = (self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w);
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Calculates and returns the squared magnitude (length) of the vector.
        pub fn lenSqr(self: *const Self) T {
            return (self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w);
        }

        /// Returns a new `Vec4` resulting from adding scalar components `x`, `y`, and `z` to this vector.
        pub fn add(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return .{
                .x = self.x + x,
                .y = self.y + y,
                .z = self.z + z,
                .w = self.w + w,
            };
        }

        /// Returns a new `Vec3` resulting from component-wise addition of another vector `vec`.
        pub fn addV(self: *const Self, vec: Self) Self {
            return self.add(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from subtracting scalar components `x`, `y`, and `z` from this vector.
        pub fn sub(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return .{
                .x = self.x - x,
                .y = self.y - y,
                .z = self.z - z,
                .w = self.w - w,
            };
        }

        /// Returns a new `Vec3` resulting from component-wise subtraction of another vector `vec`.
        pub fn subV(self: *const Self, vec: Self) Self {
            return self.sub(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from dividing this vector's components by scalar values `x`, `y`, and `z`.
        pub fn div(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return .{
                .x = self.x / x,
                .y = self.y / y,
                .z = self.z / z,
                .w = self.w / w,
            };
        }

        /// Returns a new `Vec3` resulting from component-wise division by another vector `vec`.
        pub fn divV(self: *const Self, vec: Self) Self {
            return self.div(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from multiplying this vector's components by scalar values `x`, `y`, and `z`.
        pub fn mul(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return .{
                .x = self.x * x,
                .y = self.y * y,
                .z = self.z * z,
                .w = self.w * w,
            };
        }

        /// Returns a new `Vec3` resulting from component-wise multiplication by another vector `vec`.
        pub fn mulV(self: *const Self, vec: Self) Self {
            return self.mul(vec.x, vec.y, vec.z);
        }
    };
}
