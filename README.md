# Yet Another Zig Math Library (yazml)
### What you think it would be.

> [!NOTE]
> Still WIP and has not yet been tested in actual use.
> Most of this library will stay very lightweight though, as i made this for the sole reason of other math libraries being
too heavyweight or overly complex to use for my personal liking.

## Status
- [X] Vectors (Vec2, Vec3, Vec4)
- [ ] Mat4 (IN PROGRESS)
- [ ] Quaternions
- [ ] AABBs and Rays

## Installation
Run this command:
```bash
# This automatically puts it inside of your build.zig.zon and installs it
zig fetch --save git+https://github.com/t-benito/yazml
```
Add it to your build.zig:
```zig
const yazml_dep = b.dependency("yazml", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("yazml", yazml_dep.module("yazml"));
```

## Usage Example
```zig
const math = @import("yazml");
const Vec3f = math.Vec3f;
const Mat4f = math.Mat4f;

pub fn main() void {
  const eye = Vec3f.init(2.0, 0.0, 2.0);
  const target = Vec3f.init(5.0, 0.0, 5.0);

  const projection = Mat4f.lookAt(
      eye,
      target,
      Vec3f.UP,
  );
}
```
