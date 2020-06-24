
#ifndef INCLUDE_DRIVER_PORT_H

#define INCLUDE_DRIVER_PORT_H

#include "../cpu/type.h"

typedef u16 port_t;

u8	 u8_from_port(port_t port);
void u8_to_port(port_t port, u8 data);

u16	 u16_from_port(port_t port);
void u16_to_port(port_t port, u16 data);

#endif
