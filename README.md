# WH.SH

WHSH es una versión en shell linux del script escrito en python ["Wifi-Hack" de R3LI4NT](https://github.com/R3LI4NT/Wifi-Hack) al que me he tomado la libertad de "traducir" y reconfigurar a mi gusto. 

- Reducción de 200 a 145 lineas de código.
- Eliminación e integración de scripts auxiliares en uno solo.
- Añadidos accesos a programas útiles (wifite, wireshark).
- Elimino cabeceras por comodidad.
- Los inputs piden el dato señalándolo en MAYÚSCULAS, lo que resulta más claro.
- Elimino los sleeps para acelerar el programa. 
- Añado rutas absolutas a los comandos para asegurar la ejecución.
- Detecta si tienes las dependencias y las instala en caso negativo.

## Instalar
git clone https://github.com/disketteomelette/WHSH.git
sudo sh hackwifi.sh

## Ejecutar ya desde la consola
curl -o /tmp/hw.sh https://raw.githubusercontent.com/disketteomelette/WHSH/main/hackwifi.sh; sudo sh /tmp/hw.sh
