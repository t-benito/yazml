// Copyright (c) 2026 benito. Licensed under the MIT license.

pub fn VecB(comptime len: usize) type {
    return struct {
        const Self = @This();

        data: @Vector(len, bool),

        /// Returns true if all elements in the vector are true.
        pub fn all(self: *const Self) bool {
            return @reduce(.And, self.data);
        }

        /// Returns true if any element in the vector is true.
        pub fn any(self: *const Self) bool {
            return @reduce(.Or, self.data);
        }

        /// Returns true if all elements in the vectors are the same.
        pub fn sameAll(self: *const Self, other: Self) bool {
            return @reduce(.And, self.data == other.data);
        }

        /// Returns true if any elements in the vectors are the same.
        pub fn sameAny(self: *const Self, other: Self) bool {
            return @reduce(.Or, self.data == other.data);
        }
    };
}
