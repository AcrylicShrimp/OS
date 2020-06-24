
#ifndef INCLUDE_DRIVER_SCREEN_H

#define INCLUDE_DRIVER_SCREEN_H

#define VIDEO_ADDRESS  0xb8000
#define MAX_ROWS	   25
#define MAX_COLS	   80
#define WHITE_ON_BLACK 0x0f

#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void clear(void);
void kprint(const char *message);
void kprint_at(const char *message, int col, int row);

int	 print_char(char ch, int col, int row, char attr);
int	 calc_offset(int col, int row);
int	 calc_row_from_offset(int offset);
int	 calc_col_from_offset(int offset);
int	 get_cursor_offset(void);
void set_cursor_offset(int offset);

#endif
