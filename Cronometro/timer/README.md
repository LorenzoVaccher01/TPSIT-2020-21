# Cronometro & Timer
Questo esercizio verte sulla realizzazione di un Timer e un Cronometro mediante l'utilizzo di uno Stream per la gestione dei Tick (segnali di tempo prestabiliti).

## Struttura del progetto
```
+---ios
|
+---android
|
+---build
|
+---ios
|
+---lib                     //Cartella principale del progetto
|   |   main.dart           //File principale, eseguibile.
|   |
|   +---utils               //Utilità e classi
|   |       clock.dart      //Classe per la gestione dell'orologio (estende ticker)
|   |       laps.dart       //Classe per la gestione dei giri (laps)
|   |       ticker.dart     //Classe per la gestione dei tick
|   |
|   \---views               //Visualizzazioni della pagina
|           stopwatch.dart  //Visualizzazione della sezione stopwatch
|           timer.dart      //Visualizzazione della sezione timer
|
\---test                    //Cartella di test
        widget_test.dart
```

Come illustrato nel diagramma qui sopra mostrato, il progetto, contenuto nalla cartella principale (`lib`), è stato suddiviso nei seguenti files:
- `main` → Classe principale del progetto
- `clock` → Classe che gestisce le ore, i secondi e i minuti. Tale classe estende la classe `Ticker`, **ereditando i metodi presenti in quest'ultima**. 
- `laps` → File suddiviso nelle seguenti classi:
  - `Laps` → Classe che estende 
  - `Lap` → 
- `ticker` → 
- `stopwatch` →
- `timer` → 