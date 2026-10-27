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

        /// Initializes and returns a new 4D vector with the given `x`, `y`, `z` and `w` coordinates.
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

        /// Returns a new `Vec4` resulting from adding scalar components `x`, `y`, `z` and `w` to this vector.
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
            return self.add(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec3` resulting from subtracting scalar components `x`, `y`, `z` and `w` from this vector.
        pub fn sub(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return .{
                .x = self.x - x,
                .y = self.y - y,
                .z = self.z - z,
                .w = self.w - w,
            };
        }

        /// Returns a new `Vec4` resulting from component-wise subtraction of another vector `vec`.
        pub fn subV(self: *const Self, vec: Self) Self {
            return self.sub(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec4` resulting from dividing this vector's components by scalar values `x`, `y`, `z` and `w`.
        /// When the vector contains an integer type, this function truncating division.
        pub fn div(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return if (comptime @typeInfo(T) == .float) .{
                .x = self.x / x,
                .y = self.y / y,
                .z = self.z / z,
                .w = self.w / w,
            } else .{
                .x = @divTrunc(self.x, x),
                .y = @divTrunc(self.y, y),
                .z = @divTrunc(self.z, z),
                .w = @divTrunc(self.w, w),
            };
        }

        /// Returns a new `Vec4` resulting from component-wise division by another vector `vec`.
        /// When the vector contains an integer type, this function truncating division.
        pub fn divV(self: *const Self, vec: Self) Self {
            return self.div(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new `Vec4` resulting from multiplying this vector's components by scalar values `x`, `y`, `z` and `w`.
        pub fn mul(self: *const Self, x: T, y: T, z: T, w: T) Self {
            return .{
                .x = self.x * x,
                .y = self.y * y,
                .z = self.z * z,
                .w = self.w * w,
            };
        }

        /// Returns a new `Vec4` resulting from component-wise multiplication by another vector `vec`.
        pub fn mulV(self: *const Self, vec: Self) Self {
            return self.mul(vec.x, vec.y, vec.z, vec.w);
        }

        /// Returns a new normalized `Vec4` scaled to unit length (1).
        pub fn normalize(self: *const Self) Self {
            const scale = 1.0 / self.len();
            return .{
                .x = self.x * scale,
                .y = self.y * scale,
                .z = self.z * scale,
                .w = self.w * scale,
            };
        }

        /// Returns a new normalized `Vec4` scaled to unit length (1).
        pub fn normalizeEq(self: *Self) void {
            const scale = 1.0 / self.len();
            self.x *= scale;
            self.y *= scale;
            self.z *= scale;
            self.w *= scale;
        }

        /// Returns a new `Vec4` with the absolute values of each component.
        pub fn abs(self: *const Self) Self {
            return .{
                .x = @abs(self.x),
                .y = @abs(self.y),
                .z = @abs(self.z),
                .w = @abs(self.w),
            };
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
            return Self.init(
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
        
        // TODO: do i even need these?
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
            const res = ((vec.x - self.x) * (vec.x - self.x)) + 
                ((vec.y - self.y) * (vec.y - self.y)) + 
                ((vec.z - self.z) * (vec.z - self.z)) +
                ((vec.w - self.w) * (vec.w - self.w));
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }
    };
}
