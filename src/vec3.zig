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
        pub const ZERO = init(0, 0, 0);
        /// One vector `(1, 1, 1)`.
        pub const ONE = init(1, 1, 1);
        /// Up unit vector `(0, 1, 0)`.
        pub const UP = init(0, 1, 0);

        /// Returns a new 3D vector with the given `x`, `y`, and `z` coordinates.
        pub fn init(x: T, y: T, z: T) Self {
            return .{
                .x = x,
                .y = y,
                .z = z,
            };
        }

        /// Returns the magnitude (length) of the vector.
        pub fn len(self: Self) T {
            const res = (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the squared magnitude (length) of the vector.
        /// This is typically faster than the `len()` function, as it doesnt use `@sqrt`.
        pub fn lenSqr(self: Self) T {
            return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
        }

        /// Returns the perpendicular right of this vector relative to `up`.
        pub fn perpRight(self: Self, up: Self) Self {
            return self.crossV(up).normalize();
        }

        /// Returns the perpendicular left of this vector relative to `up`.
        pub fn perpLeft(self: Self, up: Self) Self {
            return up.crossV(self).normalize();
        }

        /// Returns a copy of this vectors components as an array of `T`.
        pub fn toArray(self: Self) [3]T {
            return [3]T{ self.x, self.y, self.z };
        }

        /// Returns pointers to this vectors components as an array of `T`.
        pub fn ptrArray(self: Self) [3]*T {
            return [3]T{ &self.x, &self.y, &self.z };
        }

        /// Returns a new `Vec3` resulting from component-wise addition of `x`, `y`, and `z`.
        pub fn add(self: Self, x: T, y: T, z: T) Self {
            return init(
                self.x + x,
                self.y + y,
                self.z + z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise addition of `vec`.
        pub fn addV(self: Self, vec: Self) Self {
            return self.add(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from component-wise addition of `scalar`.
        pub fn addS(self: Self, scalar: T) Self {
            return self.add(scalar, scalar, scalar);
        }

        /// Returns a new `Vec3` resulting from component-wise subtraction of `x`, `y`, and `z`.
        pub fn sub(self: Self, x: T, y: T, z: T) Self {
            return init(
                self.x - x,
                self.y - y,
                self.z - z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise subtraction of `vec`.
        pub fn subV(self: Self, vec: Self) Self {
            return self.sub(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from component-wise subtraction of `scalar`.
        pub fn subS(self: Self, scalar: T) Self {
            return self.sub(scalar, scalar, scalar);
        }

        /// Returns a new `Vec3` resulting from dividing this vector's components by `x`, `y`, and `z`.
        pub fn div(self: Self, x: T, y: T, z: T) Self {
            return init(
                self.x / x,
                self.y / y,
                self.z / z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise division by `vec`.
        pub fn divV(self: Self, vec: Self) Self {
            return self.div(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from component-wise division by `scalar`.
        pub fn divS(self: Self, scalar: T) Self {
            return self.div(scalar, scalar, scalar);
        }

        /// Returns a new `Vec3` resulting from multiplying this vector's components by `x`, `y`, and `z`.
        pub fn mul(self: Self, x: T, y: T, z: T) Self {
            return init(
                self.x * x,
                self.y * y,
                self.z * z,
            );
        }

        /// Returns a new `Vec3` resulting from component-wise multiplication by `vec`.
        pub fn mulV(self: Self, vec: Self) Self {
            return self.mul(vec.x, vec.y, vec.z);
        }

        /// Returns a new `Vec3` resulting from component-wise multiplication by `scalar`.
        pub fn mulS(self: Self, scalar: T) Self {
            return self.mul(scalar, scalar, scalar);
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

        /// Adds `scalar` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `addS()` instead.
        pub fn plusEqS(self: *Self, scalar: T) void {
            self.plusEq(scalar, scalar, scalar);
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

        /// Subtracts `scalar` from this vector in-place.
        /// If you want to get a new vector without modifying the original, use `subS()` instead.
        pub fn subEqS(self: *Self, scalar: T) void {
            self.subEq(scalar, scalar, scalar);
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

        /// Divides this vector by `scalar` component-wise in-place.
        /// If you want to get a new vector without modifying this one, use `divS()` instead.
        pub fn divEqS(self: *Self, scalar: T) void {
            self.divEq(scalar, scalar, scalar);
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

        /// Multiplies this vector by `scalar` component-wise in-place.
        /// If you want to get a new vector without modifying this one, use `mulS()` instead.
        pub fn mulEqS(self: *Self, scalar: T) void {
            self.mulEq(scalar, scalar, scalar);
        }

        /// Returns a new normalized `Vec3` scaled to unit length (1).
        pub fn normalize(self: Self) Self {
            const scale = 1 / self.len();
            return init(
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
        pub fn round(self: Self) Self {
            comptime std.debug.assert(@typeInfo(T) == .float);
            return init(
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

        /// Returns the cross product of this vector and `x`, `y` and `z`.
        pub fn cross(self: Self, x: T, y: T, z: T) Self {
            return init(
                self.y * z - self.z * y,
                self.z * x - self.x * z,
                self.x * y - self.y * x,
            );
        }

        /// Returns the cross product of this vector and `right`.
        pub fn crossV(self: Self, right: Self) Self {
            return self.cross(right.x, right.y, right.z);
        }

        /// Returns the Euclidian distance between this point and `x`, `y` and `z`.
        pub fn dist(self: Self, x: T, y: T, z: T) T {
            const res = ((x - self.x) * (x - self.x)) + ((y - self.y) * (y - self.y)) + ((z - self.z) * (z - self.z));
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the Euclidean distance between this point and `vec`.
        pub fn distV(self: Self, vec: Self) T {
            return self.dist(vec.x, vec.y, vec.z);
        }

        /// Returns the squared Euclidian distance between this point and `x`, `y` and `z`.
        /// This is typically faster than `dst()` as it does not use `@sqrt()`.
        pub fn distSqr(self: Self, x: T, y: T, z: T) T {
            return ((x - self.x) * (x - self.x)) + ((y - self.y) * (y - self.y)) + ((z - self.z) * (z - self.z));
        }

        /// Returns the squared Euclidian distance between this point and `vec`.
        /// This is typically faster than `dst()` as it does not use `@sqrt()`.
        pub fn distSqrV(self: Self, vec: Self) T {
            return self.distSqr(vec.x, vec.y, vec.z);
        }

        /// Returns the dot (scalar) product between this vector and `x`, `y` and `z`.
        pub fn dot(self: Self, x: T, y: T, z: T) T {
            return (self.x * x) + (self.y * y) + (self.z * z);
        }

        /// Returns the dot (scalar) product between this vector and `vec`.
        pub fn dotV(self: Self, left: Self) T {
            return self.dot(left.x, left.y, left.z);
        }
    };
}
