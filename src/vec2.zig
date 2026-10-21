const std = @import("std");

/// A generic 2D vector struct parameterized by numerical type `T`.
pub fn Vec2(comptime T: type) type {
    return struct {
        const Self = @This();

        /// X component of the vector.
        x: T,
        /// Y component of the vector.
        y: T,

        /// Zero vector `(0, 0)`.
        pub const ZERO = Self.init(0, 0);
        /// Up unit vector `(0, 1)`.
        pub const UP = Self.init(0, 1);

        /// Initializes and returns a new 2D vector with the given `x` and `y` coordinates.
        pub fn init(x: T, y: T) Self {
            return .{
                .x = x,
                .y = y,
            };
        }

        /// Calculates and returns the magnitude (length) of the vector.
        pub fn length(self: *const Self) T {
            // TODO: this seems to crash for some reason with a larger size (on integers)
            // (i tested it only with 300k dont know the exact amount it does)
            const res = (self.x * self.x) + (self.y * self.y);
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns a new `Vec2` resulting from adding scalar components `x` and `y` to this vector.
        pub fn add(self: *const Self, x: T, y: T) Self {
            return .{
                .x = self.x + x,
                .y = self.y + y,
            };
        }

        /// Returns a new `Vec2` resulting from component-wise addition of another vector `vec`.
        pub fn addV(self: *const Self, vec: Self) Self {
            return self.add(vec.x, vec.y);
        }

        /// Returns a new `Vec2` resulting from dividing this vector's components by scalar values `x` and `y`.
        pub fn div(self: *const Self, x: T, y: T) Self {
            return .{
                .x = self.x / x,
                .y = self.y / y,
            };
        }

        /// Returns a new `Vec2` resulting from component-wise division by another vector `vec`.
        pub fn divV(self: *const Self, vec: Self) Self {
            return self.div(vec.x, vec.y);
        }

        /// Adds scalar amounts `x` and `y` to this vector in-place.
        /// If you want to return a new vector without modifying the original, use `add()` instead.
        pub fn plusEq(self: *Self, x: T, y: T) void {
            self.x += x;
            self.y += y;
        }

        /// Adds another vector `vec` to this vector in-place.
        /// If you want to return a new vector without modifying the original, use `addV()` instead.
        pub fn plusEqV(self: *Self, vec: Self) void {
            self.plusEq(vec.x, vec.y);
        }

        /// Divides this vector's components by scalar values `x` and `y` in-place.
        /// If you want to return a new vector without modifying the original, use `div()` instead.
        pub fn divEq(self: *Self, x: T, y: T) void {
            self.x /= x;
            self.y /= y;
        }

        /// Divides this vector by another vector `vec` component-wise in-place.
        /// If you want to return a new vector without modifying the original, use `divV()` instead.
        pub fn divEqV(self: *Self, vec: Self) void {
            self.divEq(vec.x, vec.y);
        }

        /// Returns a new normalized `Vec2` scaled to unit length (1).
        pub fn normalize(self: *const Self) Self {
            const scale = 1 / self.length();
            return .{
                .x = self.x * scale,
                .y = self.y * scale,
            };
        }

        /// Normalizes this `Vec2` to unit length (1) in-place.
        pub fn normalizeEq(self: *Self) Self {
            const scale = 1 / self.length();
            self.x *= scale;
            self.y *= scale;
        }

        /// Returns a new `Vec2` with the absolute values of each component.
        pub fn abs(self: *const Self) Self {
            return .{
                .x = @abs(self.x),
                .y = @abs(self.y),
            };
        }

        /// Replaces each component of this vector with its absolute value in-place.
        pub fn absEq(self: *Self) void {
            self.x = @abs(self.x);
            self.y = @abs(self.y);
        }

        /// Returns the Euclidean distance between this point and another point `vec`.
        pub fn dist(self: *const Self, vec: Self) T {
            const res = ((vec.x - self.x) * (vec.x - self.x)) + ((vec.y - self.y) * (vec.y - self.y));
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns the dot (scalar) product of this vector and another vector `left`.
        pub fn dot(self: *const Self, left: Self) T {
            return (self.x * left.x) + (self.y * left.y);
        }
    };
}
