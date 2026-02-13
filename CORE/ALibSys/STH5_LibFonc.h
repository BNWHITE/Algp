//----------------------------------------------------------------------
//	StH5_LibFonc.h
// 
//----------------------------------------------------------------------

#ifndef __STM_SYS_FONC_H__
#define __STM_SYS_FONC_H__


#define	ulong	unsigned long
#define	uint	unsigned int
#define	uchar	unsigned char


const char* AppH533RE_Init(void);

void	HAL_DelayMillis( ulong Delay);
void	HAL_DelayMicros( ulong nbmicsec);
void	HAL_DelaySeconds(ulong nbsec);
ulong	HAL_GetTickMilli(void);
ulong	HAL_GetTickMicro(void);

#define	sleepSeconds(nb_sec)		HAL_DelaySeconds(nb_sec)
#define	sleepMicroseconds(nb_us)	HAL_DelayMicros(nb_us)
#define	sleep(nb_ms)				HAL_DelayMillis(nb_ms)
#define	delaySeconds(nb_sec)		HAL_DelaySeconds(nb_sec)
#define	delayMicroseconds(nb_us)	HAL_DelayMicros(nb_us)
#define	delay(nb_ms)				HAL_DelayMillis(nb_ms)
#define millis()					HAL_GetTickMilli()
#define micros()					HAL_GetTickMicro()


short	pinMode(uchar numpin, uchar selmode);
short	pinModeAnalogDuo(uchar numpin1, uchar numpin2);
short	digitalWrite(uchar numpin, uchar etat);
short	digitalRead( uchar numpin);

void	analogSetParam(float freqEch, short typData);
short	analogReadData(uchar npin);
short	analogReadBuff(uchar npin, void *pBuff, short NbrEch);
short	analogReadDuoB(uchar npin1, uchar npin2, void *pBuf1, void *pBuf2, short NbrEch);

void    AudioInp_Init(short freqEch, short typData);
short	AudioInp_ReadBuff(void *pBuff, short NbrEch);
short	AudioInp_ReadData(void);

void    AudioOut_Init(short VmaxBits, short freqEch, short typData);
short	AudioOut_WriteBuff(void *pBuff, short NbrEch);
short	AudioOut_WriteData(short value);

void	BarGraphLeds_Init(void);
void	BarGraphLeds_Affi(short valeur);

void    Buzzer_Init(void);
void    Buzzer_Stop(void);
void    Buzzer_Active(short freq);

short	FFT_Init(  short  lenFft,  short  lenSignal);
void	FFT_Module(float* SigVect, float* FftVect);

short	AttachInterrupt(short numIrq, void funcIrq(void), short mode);
short	DetachInterrupt(short numIrq);
short	EnableInterrupt(short numIrq);
short	DisableInterrupt(short numIrq);


void    AOLED_InitScreen(short speed);
void    AOLED_InvertDisplay(short invert);
void    AOLED_AffiLogoIsep(void);
void    AOLED_ClearScreen(void);
void    AOLED_ClearLine(short numlin);
void    AOLED_FillScreen(char value);
void    AOLED_FillLine(short numlin, char value);
void    AOLED_WriteColonne(char value, short nbcol);
void    AOLED_DisplayImage(const char* pBuff);
void    AOLED_DisplayCarac(short numcol, short numlin, char car);
void    AOLED_DisplayTexte(short numcol, short numlin, char* texte);

void    Motor_Init(void);
void    Motor_Stop(void);
void    Motor_Avance( short vitesse);
void    Motor_Recule( short vitesse);
void    Motor_TournGL(short vitesse);
void    Motor_TournDR(short vitesse);

void	Serial_Init(int baudRate);
void	Serial_Flush(void);
short	Serial_Available(void);
short	Serial_WriteCar( char carac);
short	Serial_WriteBuff(char *pBuff);
short	Serial_ReadCar( char *pCar, short timeOut);
short	Serial_ReadBuff(char *pBuff, short maxlen, short timeOut);

void	SerialBT_Init(int baudRate);
void	SerialBT_Flush(void);
short	SerialBT_Available(void);
short	SerialBT_WriteCar(char carac);
short	SerialBT_WriteBuff(char *pBuff);
short	SerialBT_ReadCar(char *pCarac, short timeOut);
short	SerialBT_ReadBuff(char *pBuff, short maxlen, short timeOut);

char	Conv_digitAscii(short digit);
short	Conv_deciToHexa(short value);
void	Conv_val8bAscii(short value, char *pBuff);
void	Conv_val16bAscii(short value, char *pBuff);


#endif
