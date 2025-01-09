const std = @import("std");

const stdout = std.io.getStdOut().writer();

pub fn binarySearch(list: []const i32, value: i32) !bool {
    const listSize: usize = @intCast(list.len);
    var begining: usize = 0;
    var end: usize = listSize - 1;
    var middle: usize = @divFloor(listSize + 1, 2);
    var counter: u8 = 0;
    while (counter < 10 and middle >= begining and middle < end) {
        try stdout.print("Middle: {X}\n", .{middle});
        try stdout.print("begining: {X}\n", .{begining});
        try stdout.print("end: {X}\n", .{end});
        if (list[middle] == value) {
            return true;
        } else if (value < list[middle]) {
            end = middle;
        } else {
            begining = middle + 1;
        }
        middle = (begining + end) / 2;
        counter += 1;
    }
    return false;
}

pub fn main() !void {
    const items = [_]i32{ -1, 10, 100, 232, 400, 523 };
    try stdout.print("{any}\n", .{binarySearch(&items, 10)});
    try stdout.print("{any}\n", .{binarySearch(&items, 222)});
    try stdout.print("{any}\n", .{binarySearch(&items, 232)});
}

test "simple test" {
    const items = [_]i32{ -1, 10, 100, 232, 400, 523 };
    try std.testing.expect(binarySearch(&items, 10) == true);
    try std.testing.expect(binarySearch(&items, 222) == true);
    try std.testing.expect(binarySearch(&items, 232) == true);
}
