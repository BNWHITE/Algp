//----------------------------------------------------------------------
//	StH5_LibDefc.h
// 
//----------------------------------------------------------------------

#ifndef __STMH5_LIB_DEFC_H__
#define __STMH5_LIB_DEFC_H__


// PIN DEFINITION  - debut
#define 	PA_0			0x01
#define 	PA_1			0x02
#define		PA_5			0x03
#define		PA_6			0x04
#define		PA_7			0x05
#define		PA_8			0x06
#define		PA_9			0x07
#define		PA_10			0x08
#define		PA_15			0x09

#define 	PB_0			0x0A
#define 	PB_1			0x0B
#define 	PB_2			0x0C
#define 	PB_3			0x0D
#define 	PB_4			0x0E
#define 	PB_5			0x0F
#define 	PB_6			0x10
#define 	PB_7			0x11
#define 	PB_13			0x12

#define		PC_0			0x14
#define		PC_1			0x15
#define		PC_2			0x16
#define		PC_3			0x17
#define		PC_4			0x18
#define		PC_5			0x19
#define		PC_7			0x1A
#define		PC_8			0x1B
#define		PC_10			0x1C
#define		PC_11			0x1D
#define		PC_12			0x1E
#define		PC_13			0x1F

#define		BP1				PA_15
#define		BP2				PB_13
#define		PT1				PC_5
#define		PT2				PC_3
#define		SW1				PA_8
#define		SW2				PC_7

#define		STM32_LED		PA_5
#define		STM32_BOUTON	PC_13
// PIN DEFINITION  - fin

// PIN MODE  - debut
#define		OUTPUT			0x01
#define		OUTPUT_OPEND	0x03
#define		INPUT			0x04
#define		INPUT_PULLUP	0x05
#define		INPUT_PULLDOWN	0x06
#define		ANALOG_INPUT	0x08
#define		ANALOG_OUTPUT	0x0C
// PIN MODE  - fin

// INTERRUPT DEFINITION  - debut
#define		IRQ_BP1			0x01F
#define		IRQ_BP2			0x02D
#define		IRQ_SW1			0x018
#define		IRQ_SW2			0x037
#define		IRQ_IOPC2		0x032
#define		IRQ_IOPC8		0x038
#define		IRQ_IOPA7		0x017
#define		IRQ_IOPA9		0x019
#define		IRQ_IOPA10		0x01A

#define		IRQ_FALLING		0x01
#define		IRQ_RISING		0x02
// INTERRUPT DEFINITION  - fin

#define		HIGH			0x1
#define		LOW				0x0

#define		DATA_SHORT		0
#define		DATA_FLOAT		1

// TAILLE DE LA FFT
#define		FFT_1K			0
#define		FFT_2K			1
#define		FFT_4K			2
#define		FFT_8K			3

// VITESSE DU BUS I2C
#define		I2C_VIT_100K	100
#define		I2C_VIT_400K	400


// ---- DIVERS ----
#define		PI				 3.1415926535897932384626433832795
#define		HALF_PI			 1.5707963267948966192313216916398
#define		TWO_PI			 6.283185307179586476925286766559
#define		DEG_TO_RAD		 0.017453292519943295769236907684886
#define		RAD_TO_DEG		57.295779513082320876798154814105

#define		min(a,b)		( (a) < (b)? (a):(b) )
#define		max(a,b)		( (a) > (b)? (a):(b) )
#define		round(x)		( (x) >=  0? (long)((x)+0.5):(long)((x)-0.5) )
#define		radians(deg)	( (deg)*DEG_TO_RAD )
#define		degrees(rad)	( (rad)*RAD_TO_DEG )
#define		sq(x)			( (x)*(x) )

#define		lowByte(w)		( (unsigned char) ( (w)       & 0x0FF) )
#define		highByte(w)		( (unsigned char) (((w) >> 8) & 0x0FF) )


#endif
