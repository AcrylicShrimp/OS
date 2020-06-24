
#include "timer.h"

#include "../driver/port.h"
#include "../driver/screen.h"
#include "../kernel/util.h"
#include "isr.h"

u32 tick = 0;

static void timer_callback(registers_t regs)
{
	tick++;
	kprint("Tick: ");

	char tick_ascii[256];
	int_to_ascii(tick, tick_ascii);
	kprint(tick_ascii);
	kprint("\n");
}

void init_timer(u32 freq)
{
	/* Install the function we just wrote */
	register_interrupt_handler(IRQ0, timer_callback);

	/* Get the PIT value: hardware clock at 1193180 Hz */
	u32 divisor = 1193180 / freq;
	u8	low		= (u8)(divisor & 0xFF);
	u8	high	= (u8)((divisor >> 8) & 0xFF);
	/* Send the command */
	u8_to_port(0x43, 0x36); /* Command port */
	u8_to_port(0x40, low);
	u8_to_port(0x40, high);
}
