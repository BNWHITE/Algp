//-----------------------------------------------------------------------------
// BH5_Amain.c
// Mission 1 - STM32 H5 : tests GPIO, OLED, bouton, potentiomètre, Bluetooth, température
//-----------------------------------------------------------------------------

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "STH5_LibDefc.h"
#include "STH5_LibFonc.h"
#include "CH5_GnxLogo.h"

#define VREF_VOLTS           3.3f
#define ADC_MAX_VALUE        4095.0f
#define LM35_VOLT_PER_C      0.01f

#define BARGRAPH_LED_COUNT   8
#define POTENTIOMETRE        PT1
#define TEMP_SENSOR          PT2
#define GPIO_TEST_PIN        PC_10

void setup(void);
void loop(void);

short Test_BoutonPoussoir(void);
void Test_Potentiometre(void);
void Test_BlueTooth(void);
void Test_Temperature(void);

static void Bargraph_Init(void);
static void Bargraph_SetLevel(uint8_t level);

static const uint8_t bargraph_pins[BARGRAPH_LED_COUNT] = {
    PB_0, PB_1, PB_2, PB_3, PB_4, PB_5, PB_6, PB_7
};

//-----------------------------------------------------------------------------
int main(void)
{
    setup();
    while (1) {
        loop();
    }
}

//-----------------------------------------------------------------------------
void setup(void)
{
    Serial_Init(115200);
    SerialBT_Init(9600);

    Bargraph_Init();

    pinMode(BP1, INPUT);
    pinMode(BP2, INPUT);
    pinMode(SW1, INPUT);
    pinMode(SW2, INPUT);

    pinMode(POTENTIOMETRE, ANALOG_INPUT);
    pinMode(TEMP_SENSOR, ANALOG_INPUT);

    pinMode(GPIO_TEST_PIN, OUTPUT);
    digitalWrite(GPIO_TEST_PIN, LOW); // GPIO PC_10 niveau logique 0 (pour la mesure)

    AOLED_InitScreen(I2C_VIT_400K);
    AOLED_ClearScreen();
    AOLED_AffiLogoIsep();
    // AOLED_DisplayImage(Gnx_Logo); // Décommenter pour afficher le logo de l'équipe

    // SerialBT_WriteBuff("AT+NAMEG02B"); // Décommenter et remplacer G02B par votre équipe

    printf("Mission 1 - Tests STM32 H5\r\n");
}

//-----------------------------------------------------------------------------
void loop(void)
{
    // digitalWrite(GPIO_TEST_PIN, HIGH); // GPIO PC_10 niveau logique 1 (pour la mesure)

    // Test_BoutonPoussoir();
    // Test_Potentiometre();
    // Test_BlueTooth();
    // Test_Temperature();

    delay(200);
}

//-----------------------------------------------------------------------------
short Test_BoutonPoussoir(void)
{
    uint8_t state = digitalRead(BP1);
    const char *etat = (state == LOW) ? "appuye" : "non appuye";

    printf("Valeur lue = %d / Etat du bouton = %s\r\n", state, etat);
    delay(200);
    return state;
}

//-----------------------------------------------------------------------------
void Test_Potentiometre(void)
{
    uint16_t adc_val = analogReadData(POTENTIOMETRE);
    if (adc_val > ADC_MAX_VALUE) {
        adc_val = (uint16_t)ADC_MAX_VALUE;
    }

    float voltage = (adc_val / ADC_MAX_VALUE) * VREF_VOLTS;
    uint8_t level = (uint8_t)((adc_val * BARGRAPH_LED_COUNT) / ADC_MAX_VALUE);

    printf("Valeur numerique lue = %u / Tension correspondante = %.2f Volts\r\n",
           adc_val, voltage);

    Bargraph_SetLevel(level);
    delay(200);
}

//-----------------------------------------------------------------------------
void Test_BlueTooth(void)
{
    char rxBuff[64];
    short len = 0;

    if (SerialBT_Available() > 0) {
        len = SerialBT_ReadBuff(rxBuff, (short)(sizeof(rxBuff) - 1), 50);
    }

    if (len > 0) {
        rxBuff[len] = '\0';
        printf("BT recu : %s\r\n", rxBuff);

        SerialBT_WriteBuff("Echo: ");
        SerialBT_WriteBuff(rxBuff);
        SerialBT_WriteBuff("\r\n");
    }
}

//-----------------------------------------------------------------------------
void Test_Temperature(void)
{
    uint16_t adc_val = analogReadData(TEMP_SENSOR);
    if (adc_val > ADC_MAX_VALUE) {
        adc_val = (uint16_t)ADC_MAX_VALUE;
    }

    float voltage = (adc_val / ADC_MAX_VALUE) * VREF_VOLTS;
    float temperature = voltage / LM35_VOLT_PER_C;

    int temp_int = (int)temperature;
    int temp_dec = (int)((temperature - temp_int) * 10.0f + 0.5f);

    printf("Valeur numerique lue = %u / Temperature = %d,%d C\r\n",
           adc_val, temp_int, temp_dec);
    delay(300);
}

//-----------------------------------------------------------------------------
static void Bargraph_Init(void)
{
    for (int i = 0; i < BARGRAPH_LED_COUNT; i++) {
        pinMode(bargraph_pins[i], OUTPUT);
        digitalWrite(bargraph_pins[i], LOW);
    }
}

//-----------------------------------------------------------------------------
static void Bargraph_SetLevel(uint8_t level)
{
    if (level > BARGRAPH_LED_COUNT) {
        level = BARGRAPH_LED_COUNT;
    }

    for (int i = 0; i < BARGRAPH_LED_COUNT; i++) {
        digitalWrite(bargraph_pins[i], (i < level) ? HIGH : LOW);
    }
}

