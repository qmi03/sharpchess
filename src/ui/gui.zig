const rl = @import("raylib");
const chess = @import("engine").chess;
const view = @import("view.zig");
const std = @import("std");

const screenWidth = 800;
const screenHeight = 500;
const square_side_length: i32 = 50;
const board_pixel_size = square_side_length * 8;
const color_palete: view.Color.Palette = .{};

var piece_textures: [12]rl.Texture2D = undefined;

fn loadPieceTextures() !void {
    // zig fmt: off
    const names = [_][]const u8{
        "bP", "wP",
        "bN", "wN",
        "bB", "wB",
        "bR", "wR",
        "bQ", "wQ",
        "bK", "wK",
    };
    // zig fmt: on

    var buf: [64]u8 = undefined;
    for (names, 0..) |name, i| {
        const path = try std.fmt.bufPrintZ(&buf, "resources/pieces/{s}.png", .{name});
        piece_textures[i] = try rl.loadTexture(path);
    }
}

fn unloadPieceTextures() void {
    for (piece_textures) |tex| {
        rl.unloadTexture(tex);
    }
}

fn pieceIndexToTextureIndex(p: chess.PieceIndex) usize {
    return @intFromEnum(p) - 2;
}
pub fn startGame(chessboard: chess.Chessboard) !void {
    rl.initWindow(screenWidth, screenHeight, "Sharpchess");
    defer rl.closeWindow();

    try loadPieceTextures();
    defer unloadPieceTextures();

    rl.setTargetFPS(30);

    const label_margin = square_side_length;
    const total_board_width = board_pixel_size + 2 * label_margin;
    const total_board_height = board_pixel_size + 2 * label_margin;
    const board_x = (screenWidth - total_board_width) / 2 + label_margin;
    const board_y = (screenHeight - total_board_height) / 2 + label_margin;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.{ .r = 181, .g = 136, .b = 99, .a = 255 }); // brown

        const board_view = view.BoardView.get(chessboard);
        drawChessboard(board_view, board_x, board_y, square_side_length, color_palete);

        rl.drawText("Sharpchess", 200, 10, 32, .black);
    }
}

fn drawChessboard(
    board_view: [64]?chess.PieceIndex,
    board_x: i32,
    board_y: i32,
    square_size: i32,
    palete: view.Color.Palette,
) void {
    const label_color = rl.Color{ .r = 0, .g = 0, .b = 0, .a = 255 };
    const label_font_size: i32 = @intFromFloat(0.6 * @as(f32, @floatFromInt(square_size)));

    for (0..8) |rank_idx| {
        for (0..8) |file| {
            const rank = 7 - rank_idx;
            const sq_index = rank * 8 + file;
            const piece_index = board_view[sq_index];

            const x = board_x + @as(i32, @intCast(file)) * square_size;
            const y = board_y + @as(i32, @intCast(rank_idx)) * square_size;

            const square_color = view.SQUARE_COLOR[sq_index];
            const square_color_code: u32 = switch (square_color) {
                .dark => palete.dark_square,
                .light => palete.light_square,
            };
            rl.drawRectangle(x, y, square_size, square_size, view.Color.hexToRaylibColor(square_color_code));

            // Draw Piece
            if (piece_index) |pi| {
                const tex = piece_textures[pieceIndexToTextureIndex(pi)];
                if (tex.id != 0) {
                    const draw_size = square_size;
                    const offset: f32 = @as(f32, @floatFromInt(square_size - draw_size)) / 2.0;

                    const dst = rl.Rectangle{
                        .x = @as(f32, @floatFromInt(x)) + offset,
                        .y = @as(f32, @floatFromInt(y)) + offset,
                        .width = @floatFromInt(draw_size),
                        .height = @floatFromInt(draw_size),
                    };
                    const src = rl.Rectangle{
                        .x = 0,
                        .y = 0,
                        .width = @floatFromInt(tex.width),
                        .height = @floatFromInt(tex.height),
                    };
                    rl.drawTexturePro(tex, src, dst, .{ .x = 0, .y = 0 }, 0, .white);
                }
            }
        }
    }

    // file labels
    const files = "abcdefgh";
    for (files, 0..) |ch, i| {
        const txt: [1:0]u8 = [1:0]u8{ch};
        const x = board_x + @as(i32, @intCast(i)) * square_size + @divFloor(square_size, 3);
        const y = board_y + 8 * square_size + @divFloor(label_font_size, 2);
        rl.drawText(&txt, x, y, label_font_size, label_color);
    }

    // rank labels
    for (0..8) |rank_idx| {
        const rank = 7 - rank_idx;
        const digit = @as(u8, @intCast(rank + 1)) + '0';
        const txt: [1:0]u8 = [1:0]u8{digit};
        const x = board_x - square_size;
        const y = board_y + @as(i32, @intCast(rank_idx)) * square_size + @divFloor(square_size, 4);
        rl.drawText(&txt, x, y, label_font_size, label_color);
    }
}
