const std = @import("std");

/// A generic 4D vector struct parameterized by numerical type `T`.
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
        pub const UNIT_X = init(1, 0, 0, 0);
        /// `(0, 1, 0, 0)`
        pub const UNIT_Y = init(0, 1, 0, 0);
        /// `(0, 0, 1, 0)`
        pub const UNIT_Z = init(0, 0, 1, 0);
        /// `(0, 0, 0, 1)`
        pub const UNIT_W = init(0, 0, 0, 1);
        /// Zero vector `(0, 0, 0, 0)`.
        pub const ZERO = init(0, 0, 0, 0);
        /// One vector `(1, 1, 1, 1)`.
        pub const ONE = init(1, 1, 1, 1);

        /// Returns a new 4D vector with the given `x`, `y`, `z` and `w` coordinates.
        pub fn init(x: T, y: T, z: T, w: T) Self {
            return .{
                .x = x,
                .y = y,
                .z = z,
                .w = w,
            };
        }

        /// Returns the magnitude (length) of the vector.
        pub fn len(self: *const Self) T {
            const res = (self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w);
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the squared magnitude (length) of the vector.
        pub fn lenSqr(self: *const Self) T {
            return (self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w);
        }

        /// Returns this vectors components as an array of `T`.
        pub fn toArray(self: *const Self) [4]T {
            return [4]T{ self.x, self.y, self.z, self.w };
        }

        pub fn ptrArray(self: *const Self) [4]*T {
            return [4]*T{ &self.x, &self.y, &self.z, &self.w };
        }

        /// Returns a new `Vec4` resulting from component-wise addition of `x`, `y`, `z` and `w`.
        pub fn add(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return init(
                self.x + x,
                self.y + y,
                self.z + z,
                self.w + w,
            );
        }

        /// Returns a new `Vec4` resulting from component-wise addition of `vec`.
        pub fn addV(self: *const Self, vec: Self) Self {
            return self.add(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec4` resulting from component-wise addition of `scalar`.
        pub fn addS(self: *const Self, scalar: T) Self {
            return self.add(scalar, scalar, scalar, scalar);
        }

        /// Returns a new `Vec4` resulting from component-wise subtraction of `x`, `y`, `z` and `w`.
        pub fn sub(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return init(
                self.x - x,
                self.y - y,
                self.z - z,
                self.w - w,
            );
        }

        /// Returns a new `Vec4` resulting from component-wise subtraction of `vec`.
        pub fn subV(self: *const Self, vec: Self) Self {
            return self.sub(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec4` resulting from component-wise subtraction of `scalar`.
        /// When the vector contains an integer type, this function truncating division.
        pub fn subS(self: *const Self, scalar: T) Self {
            return self.sub(scalar, scalar, scalar, scalar);
        }

        /// Returns a new `Vec4` resulting from component-wise division by `x`, `y`, `z` and `w`.
        /// When the vector contains an integer type, this function truncating division.
        pub fn div(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return if (comptime @typeInfo(T) == .float) init(
                self.x / x,
                self.y / y,
                self.z / z,
                self.w / w,
            ) else init(
                @divTrunc(self.x, x),
                @divTrunc(self.y, y),
                @divTrunc(self.z, z),
                @divTrunc(self.w, w),
            );
        }

        /// Returns a new `Vec4` resulting from component-wise division by another vector `vec`.
        /// When the vector contains an integer type, this function truncating division.
        pub fn divV(self: *const Self, vec: Self) Self {
            return self.div(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec4` resulting from component-wise division by `scalar`.
        /// When the vector contains an integer type, this function truncating division.
        pub fn divS(self: *const Self, scalar: T) Self {
            return self.div(scalar, scalar, scalar, scalar);
        }

        /// Returns a new `Vec4` resulting from component-wise multiplication by `x`, `y`, `z` and `w`.
        pub fn mul(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return init(
                self.x * x,
                self.y * y,
                self.z * z,
                self.w * w,
            );
        }

        /// Returns a new `Vec4` resulting from component-wise multiplication by another vector `vec`.
        pub fn mulV(self: *const Self, vec: Self) Self {
            return self.mul(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec4` resulting from component-wise multiplication by `scalar`.
        pub fn mulS(self: *const Self, scalar: T) Self {
            return self.mul(scalar, scalar, scalar, scalar);
        }

        /// Adds `x`, `y`, `z` and `w` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `add()` instead.
        pub fn plusEq(self: *Self, x: T, y: T, z: T, w: T) void {
            self.x += x;
            self.y += y;
            self.z += z;
            self.w += w;
        }

        /// Adds `vec` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `addV()` instead.
        pub fn plusEqV(self: *Self, vec: Self) void {
            self.plusEq(vec.x, vec.y, vec.z, vec.w);
        }

        /// Adds `scalar` to this vector in-place.
        /// If you want to get a new vector without modifying the original, use `addS()` instead.
        pub fn plusEqS(self: *Self, scalar: T) void {
            self.plusEq(scalar, scalar, scalar, scalar);
        }

        /// Subtracts `x`, `y`, `z` and `w` from this vector in-place.
        /// If you want to get a new vector without modifying the original, use `sub()` instead.
        pub fn subEq(self: *Self, x: T, y: T, z: T, w: T) void {
            self.x -= x;
            self.y -= y;
            self.z -= z;
            self.w -= w;
        }

        /// Subtracts `vec` from this vector in-place.
        /// If you want to get a new vector without modifying the original, use `sub()` instead.
        pub fn subEqV(self: *Self, vec: Self) void {
            self.subEq(vec.x, vec.y, vec.z, vec.w);
        }

        /// Subtracts `scalar` from this vector in-place.
        /// If you want to get a new vector without modifying the original, use `sub()` instead.
        pub fn subEqS(self: *Self, scalar: T) void {
            self.subEq(scalar, scalar, scalar, scalar);
        }

        /// Multiplies this vector by `x`, `y`, `z` and `w` in-place.
        /// If you want to get a new vector without modifying the original, use `mul()` instead.
        pub fn mulEq(self: *Self, x: T, y: T, z: T, w: T) void {
            self.x *= x;
            self.y *= y;
            self.z *= z;
            self.w *= w;
        }

        /// Multiplies this vector by `vec` in-place.
        /// If you want to get a new vector without modifying the original, use `mulV()` instead.
        pub fn mulEqV(self: *Self, vec: Self) void {
            self.mulEq(vec.x, vec.y, vec.z, vec.w);
        }

        /// Multiplies this vector by `scalar` in-place.
        /// If you want to get a new vector without modifying the original, use `mulS()` instead.
        pub fn mulEqS(self: *Self, scalar: T) void {
            self.mulEq(scalar, scalar, scalar, scalar);
        }

        /// Divides this vector by `x`, `y`, `z` and `w` in-place.
        /// When the vector contains an integer type, this performs truncating division.
        /// If you want to get a new vector without modifying this one, use `div()` instead.
        pub fn divEq(self: *Self, x: T, y: T, z: T, w: T) void {
            if (comptime @typeInfo(T) == .float) {
                self.x /= x;
                self.y /= y;
                self.z /= z;
                self.w /= w;
            } else {
                self.x = @divTrunc(self.x, x);
                self.y = @divTrunc(self.y, y);
                self.z = @divTrunc(self.z, z);
                self.w = @divTrunc(self.w, w);
            }
        }

        /// Divides this vector by `vec` in-place.
        /// When the vector contains an integer type, this performs truncating division.
        /// If you want to get a new vector without modifying this one, use `div()` instead.
        pub fn divEqV(self: *Self, vec: Self) void {
            self.divEq(vec.x, vec.y, vec.z, vec.w);
        }

        /// Divides this vector by `scalar` in-place.
        /// When the vector contains an integer type, this performs truncating division.
        /// If you want to get a new vector without modifying this one, use `div()` instead.
        pub fn divEqS(self: *Self, scalar: T) void {
            self.divEq(scalar, scalar, scalar, scalar);
        }

        /// Returns a new normalized `Vec4` scaled to unit length (1).
        pub fn normalize(self: *const Self) Self {
            const scalee = 1.0 / self.len();
            return init(
                self.x * scalee,
                self.y * scalee,
                self.z * scalee,
                self.w * scalee,
            );
        }

        /// Returns a new normalized `Vec4` scaled to unit length (1).
        pub fn normalizeEq(self: *Self) void {
            const scalee = 1.0 / self.len();
            self.x *= scalee;
            self.y *= scalee;
            self.z *= scalee;
            self.w *= scalee;
        }

        /// Returns a new `Vec4` with the absolute values of each component.
        pub fn abs(self: *const Self) Self {
            return init(
                @abs(self.x),
                @abs(self.y),
                @abs(self.z),
                @abs(self.w),
            );
        }

        /// Replaces each component of this vector with its absolute value in-place.
        pub fn absEq(self: *Self) void {
            self.x = @abs(self.x);
            self.y = @abs(self.y);
            self.z = @abs(self.z);
            self.w = @abs(self.w);
        }

        /// Returns a new `Vec4` with the rounded values of each component.
        /// Use this only if the type of this vector is a float.
        pub fn round(self: *const Self) Self {
            comptime std.debug.assert(@typeInfo(T) == .float);
            return init(
                @round(self.x),
                @round(self.y),
                @round(self.z),
                @round(self.w),
            );
        }

        /// Replaces each component of this vector with its rounded value in-place.
        /// Use this only if the type of this vector is a float.
        /// If you want to get a new vector without modifying this one, use `round()` instead.
        pub fn roundEq(self: *Self) void {
            comptime std.debug.assert(@typeInfo(T) == .float);
            self.x = @round(self.x);
            self.y = @round(self.y);
            self.z = @round(self.z);
            self.w = @round(self.w);
        }

        /// Returns the cross product of this vector and `x`, `y` and `z`.
        /// The w scalar of the resulting `Vec4` is always 0.
        pub fn cross(self: *const Self, x: T, y: T, z: T) Self {
            return init(
                self.y * z - self.z * y,
                self.z * x - self.x * z,
                self.x * y - self.y * x,
                0,
            );
        }

        /// Returns the cross product of this vector and `right`.
        /// The w scalar of the resulting `Vec4` is always 0.
        pub fn crossV(self: *const Self, right: Self) Self {
            return self.cross(right.x, right.y, right.z);
        }

        /// Returns the Euclidian distance between this point and `x`, `y`, `z` and `w`.
        pub fn dist(self: *const Self, x: T, y: T, z: T, w: T) T {
            const res = ((x - self.x) * (x - self.x)) +
                ((y - self.y) * (y - self.y)) +
                ((z - self.z) * (z - self.z)) +
                ((w - self.w) * (w - self.w));
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the Euclidian distance between this point and `vec`.
        pub fn distV(self: *const Self, vec: Self) T {
            return self.dist(vec.x, vec.y);
        }

        /// Returns the squared Euclidian distance between this point and `x`, `y`, `z` and `w`.
        /// This is typically faster than `dist()` as it does not use `@sqrt()`.
        pub fn distSqr(self: *const Self, x: T, y: T, z: T, w: T) T {
            return ((x - self.x) * (x - self.x)) +
                ((y - self.y) * (y - self.y)) +
                ((z - self.z) * (z - self.z)) +
                ((w - self.w) * (w - self.w));
        }

        /// Returns the squared Euclidian distance between this point and `vec`.
        /// This is typically faster than `dist()` as it does not use `@sqrt()`.
        pub fn distSqrV(self: *const Self, vec: Self) T {
            return self.distSqr(vec.x, vec.y, vec.z, vec.w);
        }
    };
}
