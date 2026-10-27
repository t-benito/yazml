const std = @import("std");

/// A generic 3D vector struct parameterized by numerical type `T`.
pub fn Vec3(comptime T: type) type {
    return struct {
        const Self = @This();

        /// X component of the vector.
        x: T,
        /// Y component of the vector.
        y: T,
        /// Z component of the vector.
        z: T,

        /// Zero vector `(0, 0, 0)`.
        pub const ZERO = Self.init(0, 0, 0);
        /// One vector `(1, 1, 1)`.
        pub const ONE = Self.init(1, 1, 1);
        /// Up unit vector `(0, 1, 0)`.
        pub const UP = Self.init(0, 1, 0);

        /// Returns a new 3D vector with the given `x`, `y`, and `z` coordinates.
        pub fn init(x: T, y: T, z: T) Self {
            return .{
                .x = x,
                .y = y,
                .z = z,
            };
        }

        /// Returns the magnitude (length) of the vector.
        pub fn len(self: *const Self) T {
            const res = (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the squared magnitude (length) of the vector.
        /// This is typically faster than the `len()` function, as it doesnt use `@sqrt`.
        pub fn lenSqr(self: *const Self) T {
            return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
        }

        /// Returns a new `Vec3` resulting from adding `x`, `y`, and `z` to this vector.
        pub fn add(self: *const Self, x: T, y: T, z: T) Self {
            return Self.init(
                self.x + x,
                self.y + y,
                self.z + z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise addition of `vec`.
        pub fn addV(self: *const Self, vec: Self) Self {
            return self.add(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from subtracting `x`, `y`, and `z` from this vector.
        pub fn sub(self: *const Self, x: T, y: T, z: T) Self {
            return Self.init(
                self.x - x,
                self.y - y,
                self.z - z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise subtraction of `vec`.
        pub fn subV(self: *const Self, vec: Self) Self {
            return self.sub(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from dividing this vector's components by `x`, `y`, and `z`.
        pub fn div(self: *const Self, x: T, y: T, z: T) Self {
            return Self.init(
                self.x / x,
                self.y / y,
                self.z / z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise division by `vec`.
        pub fn divV(self: *const Self, vec: Self) Self {
            return self.div(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from multiplying this vector's components by `x`, `y`, and `z`.
        pub fn mul(self: *const Self, x: T, y: T, z: T) Self {
            return Self.init(
                self.x * x,
                self.y * y,
                self.z * z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise multiplication by `vec`.
        pub fn mulV(self: *const Self, vec: Self) Self {
            return self.mul(vec.x, vec.y, vec.z);
        }

        /// Adds `x`, `y` and `z` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `add()` instead.
        pub fn plusEq(self: *Self, x: T, y: T, z: T) void {
            self.x += x;
            self.y += y;
            self.z += z;
        }

        /// Adds `vec` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `addV()` instead.
        pub fn plusEqV(self: *Self, vec: Self) void {
            self.plusEq(vec.x, vec.y, vec.z);
        }

        /// Adds `x`, `y` and `z` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `sub()` instead.
        pub fn subEq(self: *Self, x: T, y: T, z: T) void {
            self.x -= x;
            self.y -= y;
            self.z -= z;
        }

        /// Subtracts `vec` from this vector in-place.
        /// If you want to get a new vector without modifying the original, use `subV()` instead.
        pub fn subEqV(self: *Self, vec: Self) void {
            self.subEq(vec.x, vec.y, vec.z);
        }

        /// Divides this vector's components by `x`, `y` and `z` in-place.
        /// If you want to get a new vector without modifying this one, use `div()` instead.
        pub fn divEq(self: *Self, x: T, y: T, z: T) void {
            if (comptime @typeInfo(T) == .float) {
                self.x /= x;
                self.y /= y;
                self.z /= z;
            } else {
                self.x = @divTrunc(self.x, x);
                self.y = @divTrunc(self.y, y);
                self.z = @divTrunc(self.z, z);
            }
        }

        /// Divides this vector by `vec` component-wise in-place.
        /// If you want to get a new vector without modifying this one, use `divV()` instead.
        pub fn divEqV(self: *Self, vec: Self) void {
            self.divEq(vec.x, vec.y, vec.z);
        }

        /// Multiplies this vector by `x`, `y` and `z` in-place.
        /// If you want to get a new vector without modifying this one, use `mul()` instead.
        pub fn mulEq(self: *Self, x: T, y: T, z: T) void {
            self.x *= x;
            self.y *= y;
            self.z *= z;
        }

        /// Multiplies this vector by `vec` component-wise in-place.
        /// If you want to get a new vector without modifying this one, use `mulV()` instead.
        pub fn mulEqV(self: *Self, vec: Self) void {
            self.mulEq(vec.x, vec.y, vec.z);
        }

        /// Returns a new normalized `Vec3` scaled to unit length (1).
        pub fn normalize(self: *const Self) Self {
            const scale = 1 / self.len();
            return Self.init(
                self.x * scale,
                self.y * scale,
                self.z * scale,
            );
        }

        /// Normalizes this `Vec3` to unit length (1) in-place.
        /// If you want to get a new vector without modifying this one, use `normalize()` instead.
        pub fn normalizeEq(self: *Self) void {
            const scale = 1 / self.len();
            self.x *= scale;
            self.y *= scale;
            self.z *= scale;
        }

        /// Returns a new `Vec3` with the rounded values of each component.
        /// Use this only if the vector type is a float.
        pub fn round(self: *const Self) Self {
            comptime std.debug.assert(@typeInfo(T) == .float);
            return Self.init(
                @round(self.x),
                @round(self.y),
                @round(self.z),
            );
        }

        /// Replaces each component of this vector with its rounded value in-place.
        /// Use this only if the type of this vector is a float.
        /// If you want to get a new vector without modifying this one, use `round()` instead.
        pub fn roundEq(self: *Self) Self {
            comptime std.debug.assert(@typeInfo(T) == .float);
            self.x = @round(self.x);
            self.y = @round(self.y);
            self.z = @round(self.z);
        }

        /// Returns the cross product of this vector and `right`.
        pub fn cross(self: *const Self, right: Self) Self {
            return Self.init(
                self.y * right.z - self.z * right.y,
                self.z * right.x - self.x * right.z,
                self.x * right.y - self.y * right.x,
            );
        }

        /// Returns the Euclidian distance between this point and `x`, `y` and `z`.
        pub fn dist(self: *const Self, x: T, y: T, z: T) T {
            const res = ((x - self.x) * (x - self.x)) + ((y - self.y) * (y - self.y)) + ((z - self.z) * (z - self.z));
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the Euclidean distance between this point and `vec`.
        pub fn distV(self: *const Self, vec: Self) T {
            const res = ((vec.x - self.x) * (vec.x - self.x)) + ((vec.y - self.y) * (vec.y - self.y)) + ((vec.z - self.z) * (vec.z - self.z));
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the dot (scalar) product between this vector and `vec`.
        pub fn dot(self: *const Self, left: Self) Self {
            return (self.x * left.x) + (self.y * left.y) + (self.z * left.z);
        }
    };
}
