const std = @import("std");

pub fn sort(sliced: []const i32, allocator: std.mem.Allocator) ![]const i32 {
    if (sliced.len == 1) {
        const singleValue = try allocator.alloc(i32, 1);
        singleValue[0] = sliced[0];
        return singleValue;
    }
    const sortedSliceA = try sort(sliced[0 .. sliced.len / 2], allocator);
    const sortedSliceB = try sort(sliced[sliced.len / 2 .. sliced.len], allocator);

    defer allocator.free(sortedSliceA);
    defer allocator.free(sortedSliceB);

    return merge(sortedSliceA, sortedSliceB, allocator);
}
// doing allocating memory instead of in place to test zig memory allocator
pub fn merge(sideA: []const i32, sideB: []const i32, allocator: std.mem.Allocator) ![]const i32 {
    const final = try allocator.alloc(i32, sideA.len + sideB.len);

    var pointerFinal: usize = 0;
    var pointerA: usize = 0;
    var pointerB: usize = 0;
    var condA: bool = pointerA < sideA.len;
    var condB: bool = pointerB < sideB.len;
    while (condA or condB) {
        if (condA and condB and sideA[pointerA] < sideB[pointerB]) {
            final[pointerFinal] = sideA[pointerA];
            pointerFinal += 1;
            pointerA += 1;
        } else if (condA and condB and sideB[pointerB] < sideA[pointerA]) {
            final[pointerFinal] = sideB[pointerB];
            pointerFinal += 1;
            pointerB += 1;
        } else if (condA and !condB) {
            final[pointerFinal] = sideA[pointerA];
            pointerA += 1;
            pointerFinal += 1;
        } else {
            final[pointerFinal] = sideB[pointerB];
            pointerB += 1;
            pointerFinal += 1;
        }
        condA = pointerA < sideA.len;
        condB = pointerB < sideB.len;
    }
    return final;
}

pub fn allocBigArrayn(allocator: std.mem.Allocator, size: usize) ![]const i32 {
    const final = try allocator.alloc(i32, size);
    // defer allocator.free(final);
    return final;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer _ = gpa.deinit();
    // const newArray = try allocBigArrayn(allocator, 14);
    const arrayToSort = [_]i32{ -1, 10, 2, 15, 3, 0, 25 };
    // const arrayToSort2 = [_]i32{ 1, 4, 8 }; //-1, 10, 2, 15, 3, 0, 25 };

    // const merged = try merge(&arrayToSort, &arrayToSort2, allocator);
    // defer allocator.free(merged);

    const sorted = try sort(&arrayToSort, allocator);
    defer allocator.free(sorted);
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{any}\n", .{sorted});
    // try stdout.print("{any}\n", .{merged});
    // try stdout.print("{any}\n", .{newArray});
    // defer allocator.free(sorted);
}
