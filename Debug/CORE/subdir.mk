################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../CORE/BH5_Amain.c 

OBJS += \
./CORE/BH5_Amain.o 

C_DEPS += \
./CORE/BH5_Amain.d 


# Each subdirectory must supply rules for building sources it contributes
CORE/%.o CORE/%.su CORE/%.cyclo: ../CORE/%.c CORE/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m33 -std=gnu11 -g3 -c -I"/Users/s.sy/Downloads/Test_APP_Leds/CORE/ALibSys" -Og -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@"  -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-CORE

clean-CORE:
	-$(RM) ./CORE/BH5_Amain.cyclo ./CORE/BH5_Amain.d ./CORE/BH5_Amain.o ./CORE/BH5_Amain.su

.PHONY: clean-CORE

