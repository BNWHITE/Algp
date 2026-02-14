# Test_APP_Leds – Mission 1 STM32

Ce projet contient les tests demandés dans le cahier de mission (GPIO, OLED, bouton, potentiomètre, Bluetooth, température).

## ✅ Prérequis
- STM32CubeIDE (Windows)
- Carte NUCLEO-STM32H533

## 🛠️ Compilation (STM32CubeIDE)
1. **File → Import → Existing Projects into Workspace**
2. Sélectionner le dossier du projet
3. **Project → Clean…**
4. **Project → Build All**

> Remarque : les fichiers du dossier `Debug/` peuvent contenir des chemins Windows et ne sont pas fiables sur macOS.

## ✅ Activer les tests
Ouvrir `CORE/BH5_Amain.c` et décommenter le test voulu dans `loop()` :
- `Test_BoutonPoussoir();`
- `Test_Potentiometre();`
- `Test_BlueTooth();`
- `Test_Temperature();`

Pour le test GPIO PC_10 :
- Niveau 0 : déjà configuré dans `setup()`
- Niveau 1 : décommenter `digitalWrite(GPIO_TEST_PIN, HIGH);`

## 🖼️ Logo OLED
Remplacer le buffer dans `CORE/CH5_GnxLogo.h`, puis décommenter :
```c
// AOLED_DisplayImage(Gnx_Logo);
```

## 🔵 Bluetooth
Dans `setup()` :
```c
// SerialBT_WriteBuff("AT+NAMEG02B");
```
Décommenter une fois en remplaçant `G02B` par votre équipe, flasher, puis re-commenter.
