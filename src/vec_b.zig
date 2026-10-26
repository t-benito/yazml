pub fn VecB(comptime len: usize) type {
    return struct {
        const Self = @This();

        data: @Vector(len, bool),

        /// Returns true if all elements in the vector are true.
        pub fn all(self: Self) bool {
            return @reduce(.And, self.data);
        }

        /// Returns true if any element in the vector is true.
        pub fn any(self: Self) bool {
            return @reduce(.Or, self.data);
        }
    };
}
