################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../CORE/ALibSys/STH5_CStartupU.s 

OBJS += \
./CORE/ALibSys/STH5_CStartupU.o 

S_DEPS += \
./CORE/ALibSys/STH5_CStartupU.d 


# Each subdirectory must supply rules for building sources it contributes
CORE/ALibSys/%.o: ../CORE/ALibSys/%.s CORE/ALibSys/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m33 -g3 -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@"  -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-CORE-2f-ALibSys

clean-CORE-2f-ALibSys:
	-$(RM) ./CORE/ALibSys/STH5_CStartupU.d ./CORE/ALibSys/STH5_CStartupU.o

.PHONY: clean-CORE-2f-ALibSys

