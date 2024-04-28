

# shell_lock.sh

Linux Shell Script, um die Shell mit einemPasswort zu sperren.


    
        Linux Shell Script, um die Shell mit einemPasswort zu sperren.

  Sperrt das Terminal mit einen Passwort - Standard Passwort: "0000"
- Das Passwort befindet sich oben im Quelltext. (Achtung #chmod 700 Shell_Lock.sh)
  Und dort kann es auch geändert werden. Das Passwort selber ist md5sum Verschlüsselt,
  da solltet ihr drauch achten, damit es nicht im Klartext steht..
  Passwort ändern,über die konsole. example = $echo PASSWORT| md5sum
  Passwort kann auch mit,  ./Shell_Lock -p   geändert werden.
- Bei jeder falschen Eingabe verdoppelt sich die Zeit um Pass wieder
  ein geben zu können.  
- Mit ESpeak Sprachausgabe  -
- Signale strg+c u. strg+z werden abgefangen -
- Auch bei Abruch mit strg +c verdoppelt sich die Zeit -
- Mit Uhrzeit und sek anzeige. verbesserte v1.7.2
- Neue Version 1.8.0 mit Kill Switch, falls Passwort vergessen
  einfach den KillSwitch ausführen. Standard: "Killer"
  (kann eine Tasten Kombi sein o. zweites Passwort etc.)
- Unbefugte Zugriffe,und auch Autorisierte Zugriffen,werden in einer 
  Versteckten Datei geloggt/gespeichert.
- Die Prozeß id wird ebenfalls,in eineer versteckten Datei gespeichert.
