
#include "port.h"

u8 u8_from_port(port_t port)
{
	u8 result;
	__asm__("in %%dx, %%al" : "=a"(result) : "d"(port));
	return result;
}

void u8_to_port(port_t port, u8 data)
{
	__asm__("out %%al, %%dx" : : "a"(data), "d"(port));
}

u16 u16_from_port(port_t port)
{
	u16 result;
	__asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
	return result;
}

void u16_to_port(port_t port, u16 data)
{
	__asm__("out %%ax, %%dx" : : "a"(data), "d"(port));
}
