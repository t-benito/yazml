const std = @import("std");

pub fn Vec2(comptime T: type) type {
    return struct {
        const Self = @This();

        x: T,
        y: T,

        pub const ZERO = Self.init(0, 0);
        pub const UP = Self.init(0, 1);

        pub fn init(x: T, y: T) Self {
            return .{
                .x = x,
                .y = y,
            };
        }

        pub fn length(self: *const Self) T {
            // TODO: this seems to crash for some reason with a larger size (on integers)
            // (i tested it only with 300k dont know the exact amount it does)
            const res = (self.x * self.x) + (self.y * self.y);
            return if (comptime @typeInfo(T) == .float)
                @sqrt(res)
            else
                @intCast(std.math.sqrt(@abs(res)));
        }

        /// Returns a new Vec2 with the positions of this vector, plus the added amount.
        pub fn add(self: *const Self, x: T, y: T) Self {
            return .{
                .x = self.x + x,
                .y = self.y + y,
            };
        }

        /// Same as add() but taking another Vec2
        pub fn addV(self: *const Self, vec: Self) Self {
            return .{
                .x = self.x + vec.x,
                .y = self.y + vec.y,
            };
        }

        /// Adds the given amounts to this Vec2.
        /// If you just want to get this Vec2 plus a position, use add().
        pub fn plusEq(self: *Self, x: T, y: T) void {
            self.x += x;
            self.y += y;
        }

        /// Same as plusEq() but taking another Vec2.
        pub fn plusEqV(self: *Self, vec: Self) void {
            self.x += vec.x;
            self.y += vec.y;
        }

        /// Returns a new Vec2 scaled to unit length (1)
        pub fn normalize(self: *const Self) Self {
            const scale = 1 / self.length();
            return .{
                .x = self.x * scale,
                .y = self.y * scale,
            };
        }

        /// Normalizes this Vec2 to unit length (1)
        pub fn normalizeEq(self: *Self) Self {
            const scale = 1 / self.length();
            self.x *= scale;
            self.y *= scale;
        }

        pub fn abs(self: *const Self) Self {
            return .{
                .x = @abs(self.x),
                .y = @abs(self.y),
            };
        }

        pub fn absEq(self: *Self) void {
            self.x = @abs(self.x);
            self.y = @abs(self.y);
        }
    };
}
