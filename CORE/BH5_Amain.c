//-----------------------------------------------------------------------------
// main.c
//  Potentiomètre -> LED progressives (PB_0 à PB_13)
//-----------------------------------------------------------------------------

#include <stdint.h>
#include <stdio.h>
#include "STH5_LibDefc.h"
#include "STH5_LibFonc.h"
#define DO   523
#define RE   587
#define MI   659
#define FA   698
#define SOL  784
#define LA   880
#define SI   988

#define DO_B  262
#define RE_B  294
#define MI_B  330
#define FA_B  349
#define SOL_B 392
#define LA_B  440
#define SI_B  494

#define LA_DIESE 932


#define POTENTIOMETRE PT1
#define NB_LED 14

// --- Mission 1 : ajouts (ne rien supprimer du code d'origine) ---
#define VREF_VOLTS           3.3f
#define ADC_MAX_VALUE        4095.0f
#define LM35_VOLT_PER_C      0.01f

#define BARGRAPH_LED_COUNT   8
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

// Tableau des LEDs
uint8_t led_pins[NB_LED] = {
    PB_0, PB_1, PB_2, PB_3, PB_4, PB_5, PB_6,
    PB_7, PB_13
};

// Bargraphe 8 LED (PB_0 à PB_7)
static const uint8_t bargraph_pins[BARGRAPH_LED_COUNT] = {
    PB_0, PB_1, PB_2, PB_3, PB_4, PB_5, PB_6, PB_7
};

// Exemple : un simple smiley 16x16
uint8_t image_smiley[32] = {
    0x3C,0x42,0xA5,0x81,0xA5,0x81,0x81,0x81,
    0x81,0x81,0xA5,0x81,0xA5,0x81,0x42,0x3C,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};


// Mémorisation état précédent du switch
uint8_t sw1_old_state = HIGH;

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
    for (int i = 0; i < NB_LED; i++) {
        pinMode(led_pins[i], OUTPUT);
        digitalWrite(led_pins[i], LOW);
    }

    // Ajouts Mission 1 (ne rien supprimer):
    Bargraph_Init();
    pinMode(GPIO_TEST_PIN, OUTPUT);
    digitalWrite(GPIO_TEST_PIN, LOW); // PC_10 niveau logique 0 pour mesure
    pinMode(TEMP_SENSOR, ANALOG_INPUT);
    Serial_Init(115200);
    SerialBT_Init(9600);

    pinMode(SW1, INPUT);
    pinMode(SW2, INPUT);
    pinMode(BP2, INPUT);

    pinMode(POTENTIOMETRE, ANALOG_INPUT);

    AOLED_InitScreen(I2C_VIT_400K);
    AOLED_FillScreen(0x00);
    AOLED_ClearScreen();
    AOLED_DisplayTexte(0, 0, "SW1 : OFF");

    Buzzer_Init();
}

//-----------------------------------------------------------------------------
void loop(void)
{
    uint8_t sw1_state = digitalRead(SW1);
    uint8_t BP1_state = digitalRead(BP1);

    if (sw1_state != sw1_old_state)
    {
        AOLED_ClearScreen();

        if (sw1_state == LOW)   // SW1 ON
        {
        	AOLED_FillScreen(0x00);
        }
        else                    // SW1 OFF
        {
        	AOLED_FillScreen(0x00);
        }

        sw1_old_state = sw1_state;
    }

    if (sw1_state == LOW)
    {
    	jouer_mario();
    }

    else
    {
        digitalWrite(PB_0, LOW);
    }

    if (digitalRead(BP2) == LOW)
    {

    	Buzzer_Stop();
    }

    uint16_t adc_val = analogReadData(POTENTIOMETRE);
    if (adc_val > 4095) adc_val = 4095;

    uint8_t niveau = (adc_val * NB_LED) / 4096;

    for (int i = 0; i < NB_LED; i++) {
        digitalWrite(led_pins[i], (i < niveau) ? HIGH : LOW);
    }

    // Ajouts Mission 1 (décommenter au besoin)
    // digitalWrite(GPIO_TEST_PIN, HIGH); // niveau logique 1 pour mesure
    // Test_BoutonPoussoir();
    // Test_Potentiometre();
    // Test_BlueTooth();
    // Test_Temperature();

}

// -----------------------------------------------------------------------------
// Mission 1 - fonctions ajoutées (sans suppression du code d'origine)
// -----------------------------------------------------------------------------
short Test_BoutonPoussoir(void)
{
    uint8_t state = digitalRead(BP1);
    const char *etat = (state == LOW) ? "appuye" : "non appuye";

    printf("Valeur lue = %d / Etat du bouton = %s\r\n", state, etat);
    delay(200);
    return state;
}

void Test_Potentiometre(void)
{
    uint16_t adc_val = analogReadData(POTENTIOMETRE);
    if (adc_val > ADC_MAX_VALUE) adc_val = (uint16_t)ADC_MAX_VALUE;

    float voltage = (adc_val / ADC_MAX_VALUE) * VREF_VOLTS;
    uint8_t level = (uint8_t)((adc_val * BARGRAPH_LED_COUNT) / ADC_MAX_VALUE);

    printf("Valeur numerique lue = %u / Tension correspondante = %.2f Volts\r\n",
           adc_val, voltage);

    Bargraph_SetLevel(level);
    delay(200);
}

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

void Test_Temperature(void)
{
    uint16_t adc_val = analogReadData(TEMP_SENSOR);
    if (adc_val > ADC_MAX_VALUE) adc_val = (uint16_t)ADC_MAX_VALUE;

    float voltage = (adc_val / ADC_MAX_VALUE) * VREF_VOLTS;
    float temperature = voltage / LM35_VOLT_PER_C;

    int temp_int = (int)temperature;
    int temp_dec = (int)((temperature - temp_int) * 10.0f + 0.5f);

    printf("Valeur numerique lue = %u / Temperature = %d,%d C\r\n",
           adc_val, temp_int, temp_dec);
    delay(300);
}

static void Bargraph_Init(void)
{
    for (int i = 0; i < BARGRAPH_LED_COUNT; i++) {
        pinMode(bargraph_pins[i], OUTPUT);
        digitalWrite(bargraph_pins[i], LOW);
    }
}

static void Bargraph_SetLevel(uint8_t level)
{
    if (level > BARGRAPH_LED_COUNT) level = BARGRAPH_LED_COUNT;

    for (int i = 0; i < BARGRAPH_LED_COUNT; i++) {
        digitalWrite(bargraph_pins[i], (i < level) ? HIGH : LOW);
    }
}

void jouer_note(uint16_t freq, uint16_t duree)
{
    Buzzer_Active(freq);
    delay(duree);
    Buzzer_Stop();
    delay(50);  // petite pause entre les notes
}

void jouer_mario(void)
{
    digitalWrite(PB_0, HIGH);

    // ===== INTRO =====
    jouer_note(MI, 150);
    jouer_note(MI, 150);
    delay(150);
    jouer_note(MI, 150);
    delay(150);
    jouer_note(DO, 150);
    jouer_note(MI, 150);
    delay(150);
    jouer_note(SOL, 300);
    delay(300);
    jouer_note(SOL_B, 300);
    delay(300);

    // ===== PARTIE A =====
    jouer_note(DO, 200);
    delay(200);
    jouer_note(SOL_B, 200);
    delay(200);
    jouer_note(MI_B, 200);
    delay(200);

    jouer_note(LA, 150);
    delay(100);
    jouer_note(SI, 150);
    delay(100);
    jouer_note(LA_DIESE, 150);
    jouer_note(LA, 150);
    delay(150);

    jouer_note(SOL, 200);
    jouer_note(MI, 200);
    jouer_note(SOL, 200);
    jouer_note(LA, 200);
    delay(150);
    jouer_note(FA, 150);
    jouer_note(SOL, 150);
    delay(150);

    jouer_note(MI, 150);
    delay(150);
    jouer_note(DO, 150);
    jouer_note(RE, 150);
    jouer_note(SI_B, 300);
    delay(300);

    // ===== PARTIE B =====
    jouer_note(DO, 200);
    delay(200);
    jouer_note(SOL_B, 200);
    delay(200);
    jouer_note(MI_B, 200);
    delay(200);

    jouer_note(LA, 150);
    delay(100);
    jouer_note(SI, 150);
    delay(100);
    jouer_note(LA_DIESE, 150);
    jouer_note(LA, 150);
    delay(150);

    jouer_note(SOL, 200);
    jouer_note(MI, 200);
    jouer_note(SOL, 200);
    jouer_note(LA, 200);
    delay(150);
    jouer_note(FA, 150);
    jouer_note(SOL, 150);
    delay(150);

    jouer_note(MI, 150);
    delay(150);
    jouer_note(DO, 150);
    jouer_note(RE, 150);
    jouer_note(SI_B, 300);
    delay(300);

    // ===== FIN =====
    jouer_note(SOL, 200);
    jouer_note(FA, 200);
    jouer_note(MI, 200);
    jouer_note(RE, 200);
    jouer_note(DO, 400);

    digitalWrite(PB_0, LOW);
}

