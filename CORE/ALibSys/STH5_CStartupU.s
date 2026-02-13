//-----------------------------------------------------------------------------------
// @file      startup_stm32h533xx.s
// @brief     STM32h533xx devices vector table GCC toolchain.
//            This module performs:
//                - Set the initial SP
//                - Set the initial PC == Reset_Handler,
//                - Set the vector table entries with the exceptions ISR address,
//                - Configure the clock system
//                - Branches to main in the C library (which eventually
//                  calls main()).
//            After Reset the Cortex-M33 processor is in Thread mode,
//            priority is Privileged, and the Stack is set to Main.
//-----------------------------------------------------------------------------------

	.syntax unified
	.cpu cortex-m33
	.fpu softvfp
	.thumb


		/* start address for the initialization values of the .data section */
	.word	_sidata
		/* start address for the .data section. defined in linker script	*/
	.word	_sdata
		/* end address for the .data section. defined in linker script		*/
	.word	_edata
		/* start address for the .bss section. defined in linker script		*/
	.word	_sbss
		/* end address for the .bss section. defined in linker script		*/
	.word	_ebss

.equ  BootRAM,        0xF1E0F85F


//-----------------------------------------------------------------------------------
// This code is called when the processor starts execution after a reset event. 
// Only the absolutely necessary set is performed, after which the application
//  supplied main() routine is called.
//-----------------------------------------------------------------------------------
    .section	.text.Reset_Handler
	.global		Reset_Handler
	.weak		Reset_Handler
	.type		Reset_Handler, %function

	.equ	SCB_BASE,	0xE000ED00
	.equ	SCB_VTOR,	0x08

//-------------------------------
Reset_Handler:
//-------------------------------
	ldr		sp, =_estack		/* Set stack pointer */

	ldr		r0, =SCB_BASE
	ldr		r1, =g_pfnVectors	// FLASH_BASE or RAM1_BASE
	str		r1, [r0, #SCB_VTOR]	// Init SCB_VTOR to isr_vector (exception Handler Table)

	bl		SystemInit			/* Call the clock system initialization function.*/

/* Copy the data segment initializers from flash to SRAM */
	ldr		r0, =_sdata
	ldr		r1, =_edata
	ldr		r2, =_sidata
	movs	r3, #0
	b		LoopCopyDataInit

CopyDataInit:
	ldr		r4, [r2, r3]
	str		r4, [r0, r3]
	adds	r3, r3, #4

LoopCopyDataInit:
	adds	r4, r0, r3
	cmp		r4, r1
	bcc		CopyDataInit
  
/* Zero fill the bss segment. */
	ldr		r2, =_sbss
	ldr		r4, =_ebss
	movs	r3, #0
	b		LoopFillZerobss

FillZerobss:
	str		r3, [r2]
	adds	r2, r2, #4

LoopFillZerobss:
	cmp		r2, r4
	bcc		FillZerobss

// Call static constructors

    bl		__libc_init_array

// Call the application entry point.
	nop
	bl		AppH533RE_Init
	Mov		R8, R0
	nop

	bl		Lecture_Bouton_2
	cmp		r0, #0
	bne		Reset_Suite			// continue USER prog 
	// Goto Master Test Prog
	ldr		r1, =0x08070004
	ldr		r0, [R1]
	bx		R0

Reset_Suite:
	mov		R0, R8
	bl		main

ExitLoop:
//-------------------------------
	nop
	nop
	b		ExitLoop

.size	Reset_Handler, .-Reset_Handler


//-----------------------------------------------------------------------------------
// This code is called when the processor receives an unexpected interrupt.
// This simply enters an infinite loop, preserving the system state for debugger.
//-----------------------------------------------------------------------------------
    .section	.text.Default_Handler,"ax",%progbits
	.global		Default_Handler

//-------------------------------
Default_Handler:
//-------------------------------
	nop
DefaultLoop:
	nop
	nop
	b		DefaultLoop

	.size	Default_Handler, .-Default_Handler


//void _exit(int status)
_exit:
	b		ExitLoop
//int _getpid(void) {return 1;}
//int _isatty(int file)
_getpid:
_isatty:
	mov		R0, #1
	Mov		PC, LR
//int _kill(int pid, int sig) {return -1;}
//int _fork(void)
//int _wait(int* status)
//int _open(char* path, int flags, ...)
//int _close(int file)
//int _link(char* old, char* new)
//int _unlink(char* name)
//int _execve(char* name, char** argv, char** env)
//int _times(struct tms *buf)
_fork:
_kill:
_wait:
_open:
_close:
_link:
_unlink:
_execve:
_times:
	mov		R0, #-1
	Mov		PC, LR
//int _stat(char* file, struct stat *st) {return 0;}
//int _fstat(int  file, struct stat *st)
//int _lseek(int  file, int ptr, int dir)
_stat:
_fstat:
_lseek:
	mov		R0, #0
	Mov		PC, LR


	.global		_exit, _fork,  _kill, _getpid, _wait,  _isatty, _times, _execve
	.global		_open, _close, _stat, _fstat,  _lseek, _unlink, _link

//char *__env[1] = { 0 };
//char **environ = __env;
			.global	__env, environ
__env:		.word	0
environ:	.word	__env


//-----------------------------------------------------------------------------------
// The STM32h533xx vector table.  Note that the proper constructs
// must be placed on this to ensure that it ends up at physical address 0x0000.0000.
//-----------------------------------------------------------------------------------
 	.section	.isr_vector,"a",%progbits
	.global		g_pfnVectors
	.type		g_pfnVectors, %object
	.size		g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
	.word	_estack
	.word	Reset_Handler
	.word	NMI_Handler
	.word	HardFault_Handler
	.word	MemManage_Handler
	.word	BusFault_Handler
	.word	UsageFault_Handler
	.word	SecureFault_Handler
	.word	0
	.word	0
	.word	0
	.word	SVC_Handler
	.word	DebugMon_Handler
	.word	0
	.word	PendSV_Handler
	.word	SysTick_Handler
	.word	WWDG_IRQHandler
	.word	PVD_AVD_IRQHandler
	.word	RTC_IRQHandler
	.word	RTC_S_IRQHandler
	.word	TAMP_IRQHandler
	.word	RAMCFG_IRQHandler
	.word	FLASH_IRQHandler
	.word	FLASH_S_IRQHandler
	.word	GTZC_IRQHandler
	.word	RCC_IRQHandler
	.word	RCC_S_IRQHandler
	.word	EXTI0_IRQHandler
	.word	EXTI1_IRQHandler
	.word	EXTI2_IRQHandler
	.word	EXTI3_IRQHandler
	.word	EXTI4_IRQHandler
	.word	EXTI5_IRQHandler
	.word	EXTI6_IRQHandler
	.word	EXTI7_IRQHandler
	.word	EXTI8_IRQHandler
	.word	EXTI9_IRQHandler
	.word	EXTI10_IRQHandler
	.word	EXTI11_IRQHandler
	.word	EXTI12_IRQHandler
	.word	EXTI13_IRQHandler
	.word	EXTI14_IRQHandler
	.word	EXTI15_IRQHandler
	.word	GPDMA1_Channel0_IRQHandler
	.word	GPDMA1_Channel1_IRQHandler
	.word	GPDMA1_Channel2_IRQHandler
	.word	GPDMA1_Channel3_IRQHandler
	.word	GPDMA1_Channel4_IRQHandler
	.word	GPDMA1_Channel5_IRQHandler
	.word	GPDMA1_Channel6_IRQHandler
	.word	GPDMA1_Channel7_IRQHandler
	.word	IWDG_IRQHandler
	.word	SAES_IRQHandler
	.word	ADC1_IRQHandler
	.word	DAC1_IRQHandler
	.word	FDCAN1_IT0_IRQHandler
	.word	FDCAN1_IT1_IRQHandler
	.word	TIM1_BRK_IRQHandler
	.word	TIM1_UP_IRQHandler
	.word	TIM1_TRG_COM_IRQHandler
	.word	TIM1_CC_IRQHandler
	.word	TIM2_IRQHandler
	.word	TIM3_IRQHandler
	.word	TIM4_IRQHandler
	.word	TIM5_IRQHandler
	.word	TIM6_IRQHandler
	.word	TIM7_IRQHandler
	.word	I2C1_EV_IRQHandler
	.word	I2C1_ER_IRQHandler
	.word	I2C2_EV_IRQHandler
	.word	I2C2_ER_IRQHandler
	.word	SPI1_IRQHandler
	.word	SPI2_IRQHandler
	.word	SPI3_IRQHandler
	.word	USART1_IRQHandler
	.word	USART2_IRQHandler
	.word	USART3_IRQHandler
	.word	UART4_IRQHandler
	.word	UART5_IRQHandler
	.word	LPUART1_IRQHandler
	.word	LPTIM1_IRQHandler
	.word	TIM8_BRK_IRQHandler
	.word	TIM8_UP_IRQHandler
	.word	TIM8_TRG_COM_IRQHandler
	.word	TIM8_CC_IRQHandler
	.word	ADC2_IRQHandler
	.word	LPTIM2_IRQHandler
	.word	TIM15_IRQHandler
	.word	0
	.word	0
	.word	USB_DRD_FS_IRQHandler
	.word	CRS_IRQHandler
	.word	UCPD1_IRQHandler
	.word	FMC_IRQHandler
	.word	OCTOSPI1_IRQHandler
	.word	SDMMC1_IRQHandler
	.word	I2C3_EV_IRQHandler
	.word	I2C3_ER_IRQHandler
	.word	SPI4_IRQHandler
	.word	0
	.word	0
	.word	USART6_IRQHandler
	.word	0
	.word	0
	.word	0
	.word	0
	.word	GPDMA2_Channel0_IRQHandler
	.word	GPDMA2_Channel1_IRQHandler
	.word	GPDMA2_Channel2_IRQHandler
	.word	GPDMA2_Channel3_IRQHandler
	.word	GPDMA2_Channel4_IRQHandler
	.word	GPDMA2_Channel5_IRQHandler
	.word	GPDMA2_Channel6_IRQHandler
	.word	GPDMA2_Channel7_IRQHandler
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	FPU_IRQHandler
	.word	ICACHE_IRQHandler
	.word	DCACHE1_IRQHandler
	.word	0
	.word	0
	.word	DCMI_PSSI_IRQHandler
	.word	FDCAN2_IT0_IRQHandler
	.word	FDCAN2_IT1_IRQHandler
	.word	0
	.word	0
	.word	DTS_IRQHandler
	.word	RNG_IRQHandler
	.word	OTFDEC1_IRQHandler
	.word	AES_IRQHandler
	.word	HASH_IRQHandler
	.word	PKA_IRQHandler
	.word	CEC_IRQHandler
	.word	TIM12_IRQHandler
	.word	0
	.word	0
	.word	I3C1_EV_IRQHandler
	.word	I3C1_ER_IRQHandler
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	I3C2_EV_IRQHandler
	.word	I3C2_ER_IRQHandler


//-----------------------------------------------------------------------------------
// Provide weak aliases for each Exception handler to the Default_Handler.
// As they are weak aliases, any function with the same name will override this definition.
//-----------------------------------------------------------------------------------

	.weak	NMI_Handler
	.thumb_set NMI_Handler,Default_Handler

	.weak	HardFault_Handler
	.thumb_set HardFault_Handler,Default_Handler

	.weak	MemManage_Handler
	.thumb_set MemManage_Handler,Default_Handler

	.weak	BusFault_Handler
	.thumb_set BusFault_Handler,Default_Handler

	.weak	UsageFault_Handler
	.thumb_set UsageFault_Handler,Default_Handler

	.weak	SecureFault_Handler
	.thumb_set SecureFault_Handler,Default_Handler

//	.weak	SVC_Handler
//	.thumb_set SVC_Handler,Default_Handler

//	.weak	DebugMon_Handler
//	.thumb_set DebugMon_Handler,Default_Handler

//	.weak	PendSV_Handler
//	.thumb_set PendSV_Handler,Default_Handler

//	.weak	SysTick_Handler
//	.thumb_set SysTick_Handler,Default_Handler

//	.weak	WWDG_IRQHandler
//	.thumb_set WWDG_IRQHandler,Default_Handler

	.weak	PVD_AVD_IRQHandler
	.thumb_set PVD_AVD_IRQHandler,Default_Handler

	.weak	RTC_IRQHandler
	.thumb_set RTC_IRQHandler,Default_Handler

	.weak	RTC_S_IRQHandler
	.thumb_set RTC_S_IRQHandler,Default_Handler

	.weak	TAMP_IRQHandler
	.thumb_set TAMP_IRQHandler,Default_Handler

	.weak	RAMCFG_IRQHandler
	.thumb_set RAMCFG_IRQHandler,Default_Handler

	.weak	FLASH_IRQHandler
	.thumb_set FLASH_IRQHandler,Default_Handler

	.weak	FLASH_S_IRQHandler
	.thumb_set FLASH_S_IRQHandler,Default_Handler

	.weak	GTZC_IRQHandler
	.thumb_set GTZC_IRQHandler,Default_Handler

	.weak	RCC_IRQHandler
	.thumb_set RCC_IRQHandler,Default_Handler

	.weak	RCC_S_IRQHandler
	.thumb_set RCC_S_IRQHandler,Default_Handler

	.weak	EXTI0_IRQHandler
	.thumb_set EXTI0_IRQHandler,Default_Handler

	.weak	EXTI1_IRQHandler
	.thumb_set EXTI1_IRQHandler,Default_Handler

	.weak	EXTI2_IRQHandler
	.thumb_set EXTI2_IRQHandler,Default_Handler

	.weak	EXTI3_IRQHandler
	.thumb_set EXTI3_IRQHandler,Default_Handler

	.weak	EXTI4_IRQHandler
	.thumb_set EXTI4_IRQHandler,Default_Handler

	.weak	EXTI5_IRQHandler
	.thumb_set EXTI5_IRQHandler,Default_Handler

	.weak	EXTI6_IRQHandler
	.thumb_set EXTI6_IRQHandler,Default_Handler

	.weak	EXTI7_IRQHandler
	.thumb_set EXTI7_IRQHandler,Default_Handler

	.weak	EXTI8_IRQHandler
	.thumb_set EXTI8_IRQHandler,Default_Handler

	.weak	EXTI9_IRQHandler
	.thumb_set EXTI9_IRQHandler,Default_Handler

	.weak	EXTI10_IRQHandler
	.thumb_set EXTI10_IRQHandler,Default_Handler

	.weak	EXTI11_IRQHandler
	.thumb_set EXTI11_IRQHandler,Default_Handler

	.weak	EXTI12_IRQHandler
	.thumb_set EXTI12_IRQHandler,Default_Handler

	.weak	EXTI13_IRQHandler
	.thumb_set EXTI13_IRQHandler,Default_Handler

	.weak	EXTI14_IRQHandler
	.thumb_set EXTI14_IRQHandler,Default_Handler

	.weak	EXTI15_IRQHandler
	.thumb_set EXTI15_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel0_IRQHandler
	.thumb_set GPDMA1_Channel0_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel1_IRQHandler
	.thumb_set GPDMA1_Channel1_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel2_IRQHandler
	.thumb_set GPDMA1_Channel2_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel3_IRQHandler
	.thumb_set GPDMA1_Channel3_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel4_IRQHandler
	.thumb_set GPDMA1_Channel4_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel5_IRQHandler
	.thumb_set GPDMA1_Channel5_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel6_IRQHandler
	.thumb_set GPDMA1_Channel6_IRQHandler,Default_Handler

	.weak	GPDMA1_Channel7_IRQHandler
	.thumb_set GPDMA1_Channel7_IRQHandler,Default_Handler

	.weak	IWDG_IRQHandler
	.thumb_set IWDG_IRQHandler,Default_Handler

	.weak	SAES_IRQHandler
	.thumb_set SAES_IRQHandler,Default_Handler

	.weak	ADC1_IRQHandler
	.thumb_set ADC1_IRQHandler,Default_Handler

	.weak	DAC1_IRQHandler
	.thumb_set DAC1_IRQHandler,Default_Handler

	.weak	FDCAN1_IT0_IRQHandler
	.thumb_set FDCAN1_IT0_IRQHandler,Default_Handler

	.weak	FDCAN1_IT1_IRQHandler
	.thumb_set FDCAN1_IT1_IRQHandler,Default_Handler

	.weak	TIM1_BRK_IRQHandler
	.thumb_set TIM1_BRK_IRQHandler,Default_Handler

	.weak	TIM1_UP_IRQHandler
	.thumb_set TIM1_UP_IRQHandler,Default_Handler

	.weak	TIM1_TRG_COM_IRQHandler
	.thumb_set TIM1_TRG_COM_IRQHandler,Default_Handler

	.weak	TIM1_CC_IRQHandler
	.thumb_set TIM1_CC_IRQHandler,Default_Handler

	.weak	TIM2_IRQHandler
	.thumb_set TIM2_IRQHandler,Default_Handler

	.weak	TIM3_IRQHandler
	.thumb_set TIM3_IRQHandler,Default_Handler

	.weak	TIM4_IRQHandler
	.thumb_set TIM4_IRQHandler,Default_Handler

	.weak	TIM5_IRQHandler
	.thumb_set TIM5_IRQHandler,Default_Handler

	.weak	TIM6_IRQHandler
	.thumb_set TIM6_IRQHandler,Default_Handler

//	.weak	TIM7_IRQHandler
//	.thumb_set TIM7_IRQHandler,Default_Handler

	.weak	I2C1_EV_IRQHandler
	.thumb_set I2C1_EV_IRQHandler,Default_Handler

	.weak	I2C1_ER_IRQHandler
	.thumb_set I2C1_ER_IRQHandler,Default_Handler

	.weak	I2C2_EV_IRQHandler
	.thumb_set I2C2_EV_IRQHandler,Default_Handler

	.weak	I2C2_ER_IRQHandler
	.thumb_set I2C2_ER_IRQHandler,Default_Handler

	.weak	SPI1_IRQHandler
	.thumb_set SPI1_IRQHandler,Default_Handler

	.weak	SPI2_IRQHandler
	.thumb_set SPI2_IRQHandler,Default_Handler

	.weak	SPI3_IRQHandler
	.thumb_set SPI3_IRQHandler,Default_Handler

//	.weak	USART1_IRQHandler
//	.thumb_set USART1_IRQHandler,Default_Handler

//	.weak	USART2_IRQHandler
//	.thumb_set USART2_IRQHandler,Default_Handler

//	.weak	USART3_IRQHandler
//	.thumb_set USART3_IRQHandler,Default_Handler

	.weak	UART4_IRQHandler
	.thumb_set UART4_IRQHandler,Default_Handler

	.weak	UART5_IRQHandler
	.thumb_set UART5_IRQHandler,Default_Handler

	.weak	LPUART1_IRQHandler
	.thumb_set LPUART1_IRQHandler,Default_Handler

	.weak	LPTIM1_IRQHandler
	.thumb_set LPTIM1_IRQHandler,Default_Handler

	.weak	TIM8_BRK_IRQHandler
	.thumb_set TIM8_BRK_IRQHandler,Default_Handler

	.weak	TIM8_UP_IRQHandler
	.thumb_set TIM8_UP_IRQHandler,Default_Handler

	.weak	TIM8_TRG_COM_IRQHandler
	.thumb_set TIM8_TRG_COM_IRQHandler,Default_Handler

	.weak	TIM8_CC_IRQHandler
	.thumb_set TIM8_CC_IRQHandler,Default_Handler

	.weak	ADC2_IRQHandler
	.thumb_set ADC2_IRQHandler,Default_Handler

	.weak	LPTIM2_IRQHandler
	.thumb_set LPTIM2_IRQHandler,Default_Handler

	.weak	TIM15_IRQHandler
	.thumb_set TIM15_IRQHandler,Default_Handler

	.weak	USB_DRD_FS_IRQHandler
	.thumb_set USB_DRD_FS_IRQHandler,Default_Handler

	.weak	CRS_IRQHandler
	.thumb_set CRS_IRQHandler,Default_Handler

	.weak	UCPD1_IRQHandler
	.thumb_set UCPD1_IRQHandler,Default_Handler

	.weak	FMC_IRQHandler
	.thumb_set FMC_IRQHandler,Default_Handler

	.weak	OCTOSPI1_IRQHandler
	.thumb_set OCTOSPI1_IRQHandler,Default_Handler

	.weak	SDMMC1_IRQHandler
	.thumb_set SDMMC1_IRQHandler,Default_Handler

	.weak	I2C3_EV_IRQHandler
	.thumb_set I2C3_EV_IRQHandler,Default_Handler

	.weak	I2C3_ER_IRQHandler
	.thumb_set I2C3_ER_IRQHandler,Default_Handler

	.weak	SPI4_IRQHandler
	.thumb_set SPI4_IRQHandler,Default_Handler

	.weak	USART6_IRQHandler
	.thumb_set USART6_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel0_IRQHandler
	.thumb_set GPDMA2_Channel0_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel1_IRQHandler
	.thumb_set GPDMA2_Channel1_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel2_IRQHandler
	.thumb_set GPDMA2_Channel2_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel3_IRQHandler
	.thumb_set GPDMA2_Channel3_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel4_IRQHandler
	.thumb_set GPDMA2_Channel4_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel5_IRQHandler
	.thumb_set GPDMA2_Channel5_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel6_IRQHandler
	.thumb_set GPDMA2_Channel6_IRQHandler,Default_Handler

	.weak	GPDMA2_Channel7_IRQHandler
	.thumb_set GPDMA2_Channel7_IRQHandler,Default_Handler

	.weak	FPU_IRQHandler
	.thumb_set FPU_IRQHandler,Default_Handler

	.weak	ICACHE_IRQHandler
	.thumb_set ICACHE_IRQHandler,Default_Handler

	.weak	DCACHE1_IRQHandler
	.thumb_set DCACHE1_IRQHandler,Default_Handler

	.weak	DCMI_PSSI_IRQHandler
	.thumb_set DCMI_PSSI_IRQHandler,Default_Handler

	.weak	FDCAN2_IT0_IRQHandler
	.thumb_set FDCAN2_IT0_IRQHandler,Default_Handler

	.weak	FDCAN2_IT1_IRQHandler
	.thumb_set FDCAN2_IT1_IRQHandler,Default_Handler

	.weak	DTS_IRQHandler
	.thumb_set DTS_IRQHandler,Default_Handler

	.weak	RNG_IRQHandler
	.thumb_set RNG_IRQHandler,Default_Handler

	.weak	OTFDEC1_IRQHandler
	.thumb_set OTFDEC1_IRQHandler,Default_Handler

	.weak	AES_IRQHandler
	.thumb_set AES_IRQHandler,Default_Handler

	.weak	HASH_IRQHandler
	.thumb_set HASH_IRQHandler,Default_Handler

	.weak	PKA_IRQHandler
	.thumb_set PKA_IRQHandler,Default_Handler

	.weak	CEC_IRQHandler
	.thumb_set CEC_IRQHandler,Default_Handler

	.weak	TIM12_IRQHandler
	.thumb_set TIM12_IRQHandler,Default_Handler

	.weak	I3C1_EV_IRQHandler
	.thumb_set I3C1_EV_IRQHandler,Default_Handler

	.weak	I3C1_ER_IRQHandler
	.thumb_set I3C1_ER_IRQHandler,Default_Handler

	.weak	I3C2_EV_IRQHandler
	.thumb_set I3C2_EV_IRQHandler,Default_Handler

	.weak	I3C2_ER_IRQHandler
	.thumb_set I3C2_ER_IRQHandler,Default_Handler
