
#include "util.h"

void memory_set(u8 val, u8 *dst, int length)
{
	for (int index = 0; index < length; ++index) *dst++ = val;
}

void memory_copy(const u8 *src, u8 *dst, int length)
{
	for (int index = 0; index < length; ++index) *dst++ = *src++;
}

void int_to_ascii(int n, char *str)
{
	int i, sign;
	if ((sign = n) < 0) n = -n;
	i = 0;
	do {
		str[i++] = n % 10 + '0';
	} while ((n /= 10) > 0);

	if (sign < 0) str[i++] = '-';
	str[i] = '\0';

	reverse(str);
}

void reverse(char *s)
{
	int c, i, j;
	for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
		c	 = s[i];
		s[i] = s[j];
		s[j] = c;
	}
}

int strlen(const char *s)
{
	int i = 0;
	while (s[i] != '\0') ++i;
	return i;
}
