
#ifndef INCLUDE_CPU_TYPE_H

#define INCLUDE_CPU_TYPE_H

typedef char		  i8;
typedef short		  i16;
typedef int			  i32;
typedef long long int i64;

typedef unsigned char		   u8;
typedef unsigned short		   u16;
typedef unsigned int		   u32;
typedef unsigned long long int u64;

typedef float  f32;
typedef double f64;

#define LOW16(value)  (u16)((u32)(value) & (0xFFFF))
#define HIGH16(value) (u16)(((u32)(value) >> 16) & (0xFFFF))

#endif
