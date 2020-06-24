
#include "screen.h"

#include "../kernel/util.h"
#include "port.h"

void clear(void)
{
	char *screen	  = (char *)VIDEO_ADDRESS;
	int	  screen_size = MAX_COLS * MAX_ROWS;

	for (int index = 0; index < screen_size; ++index) {
		screen[index * 2]	  = ' ';
		screen[index * 2 + 1] = WHITE_ON_BLACK;
	}

	set_cursor_offset(calc_offset(0, 0));
}

void kprint(const char *message)
{
	kprint_at(message, -1, -1);
}

void kprint_at(const char *message, int col, int row)
{
	int offset;
	if (0 <= col && 0 <= row) offset = calc_offset(col, row);
	else {
		offset = get_cursor_offset();
		row	   = calc_row_from_offset(offset);
		col	   = calc_col_from_offset(offset);
	}

	for (int index = 0; message[index]; ++index) {
		offset = print_char(message[index], col, row, WHITE_ON_BLACK);
		row	   = calc_row_from_offset(offset);
		col	   = calc_col_from_offset(offset);
	}
}

int print_char(char ch, int col, int row, char attr)
{
	if (!attr) attr = WHITE_ON_BLACK;

	int offset;
	if (0 <= col && 0 <= row) offset = calc_offset(col, row);
	else
		offset = get_cursor_offset();

	if (ch == '\n') {
		row	   = calc_row_from_offset(offset);
		offset = calc_offset(0, row + 1);
	}
	else {
		char *video		  = (char *)VIDEO_ADDRESS;
		video[offset]	  = ch;
		video[offset + 1] = attr;
		offset += 2;
	}

	if (offset >= MAX_ROWS * MAX_COLS * 2) {
		for (int i = 1; i < MAX_ROWS; i++)
			memory_copy(
				(const u8 *)(calc_offset(0, i) + VIDEO_ADDRESS),
				(u8 *)(calc_offset(0, i - 1) + VIDEO_ADDRESS),
				MAX_COLS * 2);

		/* Blank last line */
		char *last_line = (char *)(calc_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
		for (int i = 0; i < MAX_COLS * 2; i++) last_line[i] = 0;

		offset -= 2 * MAX_COLS;
	}

	set_cursor_offset(offset);

	return offset;
}

int calc_offset(int col, int row)
{
	return 2 * (row * MAX_COLS + col);
}

int calc_row_from_offset(int offset)
{
	return offset / (2 * MAX_COLS);
}

int calc_col_from_offset(int offset)
{
	return (offset - (calc_row_from_offset(offset) * 2 * MAX_COLS)) / 2;
}

int get_cursor_offset(void)
{
	u8_to_port(REG_SCREEN_CTRL, 14);
	int offset = u8_from_port(REG_SCREEN_DATA) << 8;

	u8_to_port(REG_SCREEN_CTRL, 15);
	offset += u8_from_port(REG_SCREEN_DATA);

	return offset * 2;
}

void set_cursor_offset(int offset)
{
	offset /= 2;

	u8_to_port(REG_SCREEN_CTRL, 14);
	u8_to_port(REG_SCREEN_DATA, (unsigned char)(offset >> 8));

	u8_to_port(REG_SCREEN_CTRL, 15);
	u8_to_port(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}
