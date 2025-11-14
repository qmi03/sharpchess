const rl = @import("raylib");
const utilities = @import("engine").utilities;
const chess = @import("engine").chess;
const screenWidth = 800;
const screenHeight = 500;
const square_side_length: i32 = 50;
const board_pixel_size = square_side_length * 8; // 400 px

pub fn startGame() !void {
    const chessboard = chess.Chessboard.init();
    // extra margin for labels (= one square width)
    const label_margin = square_side_length;
    const total_board_width = board_pixel_size + 2 * label_margin;
    const total_board_height = board_pixel_size + 2 * label_margin;

    // center offsets
    const board_x = (screenWidth - total_board_width) / 2 + label_margin;
    const board_y = (screenHeight - total_board_height) / 2 + label_margin;

    rl.initWindow(screenWidth, screenHeight, "Sharpchess");
    defer rl.closeWindow();
    rl.setTargetFPS(30);
    // ----------------------------------------------------------------------

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.brown);

        // draw the board + labels
        drawChessboard(
            .init(chessboard, .{}),
            board_x,
            board_y,
            square_side_length,
        );

        rl.drawText(
            "Sharpchess",
            200,
            10,
            32,
            .black,
        );
    }
}
fn drawChessboard(
    view: utilities.BoardView,
    board_x: i32,
    board_y: i32,
    square_size: i32,
) void {
    const label_color = rl.Color{ .r = 0, .g = 0, .b = 0, .a = 255 };

    const multiplier: f32 = 0.6;
    const label_font_size: i32 = @intFromFloat(multiplier * @as(f32, @floatFromInt(square_size)));

    for (0..8) |rank_idx| {
        for (0..8) |file| {
            const rank = 7 - rank_idx; // rank 8 at top
            const sq = rank * 8 + file;
            const square = view.squares[sq];

            const x = board_x + @as(i32, @intCast(file)) * square_size;
            const y = board_y + @as(i32, @intCast(rank_idx)) * square_size;

            rl.drawRectangle(x, y, square_size, square_size, hexToRaylibColor(square.bg));
        }
    }

    const files = "abcdefgh";
    for (files, 0..) |ch, i| {
        const txt: [1:0]u8 = [1:0]u8{ch}; // null-terminated!
        const x = board_x + @as(i32, @intCast(i)) * square_size + @divFloor(square_size, 3);
        const y = board_y + 8 * square_size + @divFloor(label_font_size, 2);
        rl.drawText(&txt, x, y, label_font_size, label_color);
    }

    for (0..8) |rank_idx| {
        const rank = 7 - rank_idx;
        const digit = @as(u8, @intCast(rank + 1)) + '0';
        const txt: [1:0]u8 = [1:0]u8{digit};
        const x = board_x - square_size;
        const y = board_y + @as(i32, @intCast(rank_idx)) * square_size + @divFloor(square_size, 4);
        rl.drawText(&txt, x, y, label_font_size, label_color);
    }
    // TODO: Draw chess pieces
}

fn hexToRaylibColor(hex: u32) rl.Color {
    return .{
        .r = @intCast((hex >> 16) & 0xFF),
        .g = @intCast((hex >> 8) & 0xFF),
        .b = @intCast(hex & 0xFF),
        .a = 255,
    };
}
