
#ifndef INCLUDE_KERNEL_UTIL_H

#define INCLUDE_KERNEL_UTIL_H

#include "../cpu/type.h"

void memory_set(u8 val, u8 *dst, int length);
void memory_copy(const u8 *src, u8 *dst, int length);
void int_to_ascii(int n, char *str);
void reverse(char *s);
int	 strlen(const char *s);

#endif
