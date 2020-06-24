
#include "../cpu/isr.h"
#include "../cpu/timer.h"
#include "../driver/keyboard.h"
#include "../driver/screen.h"

void main()
{
	clear();
	isr_install();

	asm volatile("sti");
	init_timer(50);
	init_keyboard();
}
