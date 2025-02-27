RESET="\033[0m"
YELLOW="\033[38;5;11m"
GREEN="\033[0;32m"
RED="\033[0;31m"
WHITE="\033[1;37m"
STRONG_BLUE='\033[38;5;32m'


prompt="${WHITE}(${STRONG_BLUE}encryptor${WHITE})${STRONG_BLUE} > ${RESET}"
declare -A lugares=( [FDS22]="Ciudad de México" [C9DXZ8]="Guadalajara" )
declare -A dispositivos=( [X5P1]="Servidor" [B8F7]="Computadora" [Q2M4]="Impresora" [H3J9]="Laptop" [D2K6]="Switch" [L7C3]="Otro" )
declare -A departamentos=( [W1Z3]="TI" [F4Q7]="RH" [T9B0]="Carrera" )
declare -A entornos=( [R0X4]="Desarrollo" [M2F9]="Producción" )

menu() {
    clear
    STRONG_BLUE='\033[38;5;32m'
    NC='\033[0m'
    
    echo -e "${STRONG_BLUE}
   _____                                  _    _               
  |  ___|                                | |  (_)              
  | |__  _ __    ___  _ __  _   _  _ __  | |_  _   ___   _ __  
  |  __|| '_ \  / __|| '__|| | | || '_ \ | __|| | / _ \ | '_ \ 
  | |___| | | || (__ | |   | |_| || |_) || |_ | || (_) || | | |
  \____/|_| |_| \___||_|    \__, || .__/  \__||_| \___/ |_| |_| 
                             __/ || |                          
                            |___/ |_|                          
${NC}"
    echo -e "${prompt} ${STRONG_BLUE}1. Encriptar${RESET}"
    echo -e "${prompt} ${STRONG_BLUE}2. Desencriptar${RESET}"
    echo -e "${prompt} ${STRONG_BLUE}3. Crear regla${RESET}"
    echo -e "${prompt} ${STRONG_BLUE}4. Descifrar regla${RESET}"
    echo -e "${prompt} ${STRONG_BLUE}5. Salir${RESET}"
    read -e -p "Paulina >" opcion
    case $opcion in
        1) clear; encriptar ;;
        2) clear; desencriptar ;;
        3) clear; crear_regla ;;
        4) clear; descifrar_regla ;;
        5) exit ;;
        *) clear; menu ;;
    esac
}

encriptar() {
    clear
    echo -e "${prompt} ${STRONG_BLUE}Ingrese el texto a encriptar:${RESET}"
    read -p "Texto > " texto
    read -sp "Password > " contrasena
    echo
    
    texto_encriptado=$(echo -n "$texto" | base64)
    
    echo "$texto_encriptado:$contrasena" >> encriptados.dat
    
    echo -e "${prompt} ${STRONG_BLUE}Texto encriptado: $texto_encriptado${RESET}"
    read -p ">"
    menu
}

desencriptar() {
    clear
    echo -e "${prompt} ${STRONG_BLUE}Ingrese el texto encriptado${RESET}"
    read -p ">" texto_encriptado
    correcto=false

    while [ "$correcto" = false ]; do
        read -sp "Password > " contrasena
        echo
        
        encontrado=false
        while IFS=":" read -r texto_guardado pass; do
            if [[ "$texto_guardado" == "$texto_encriptado" && "$pass" == "$contrasena" ]]; then
                encontrado=true
                texto_desencriptado=$(echo -n "$texto_encriptado" | base64 --decode)
                echo -e "${prompt} ${STRONG_BLUE}Texto desencriptado: $texto_desencriptado${RESET}"
                correcto=true
                break
            fi
        done < encriptados.dat

        if ! $encontrado; then
            echo -e "${RED}Texto o contraseña incorrectos. Intente de nuevo.${RESET}"
        fi
    done
    
    read -p ">"
    menu
}

crear_regla() {
    clear
    while true; do
        echo -e "${prompt} ${STRONG_BLUE}Seleccione un lugar:${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}1. Ciudad de México${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}2. Guadalajara${RESET}"
        read -p ">" lugar
        if [[ "$lugar" =~ ^[12]$ ]]; then
            break
        else
            echo -e "${RED}Opción no válida, por favor elige 1 o 2.${RESET}"
        fi
    done

    clear
    while true; do
        echo -e "${prompt} ${STRONG_BLUE}Seleccione un tipo de dispositivo:${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}1) Servidor${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}2) Computadora${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}3) Impresora${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}4) Laptop${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}5) Switch${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}6) Otro${RESET}"
        read -p ">" dispositivo
        if [[ "$dispositivo" =~ ^[1-6]$ ]]; then
            break
        else
            echo -e "${STRONG_BLUE}Opción no válida. Intente nuevamente.${RESET}"
        fi
    done

    clear
    while true; do
        echo -e "${prompt} ${STRONG_BLUE}Seleccione un departamento:${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}1) TI${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}2) RH${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}3) Carrera${RESET}"
        read -p ">" departamento
        if [[ "$departamento" =~ ^[1-3]$ ]]; then
            break
        else
            echo -e "${STRONG_BLUE}Opción no válida. Intente nuevamente.${RESET}"
        fi
    done

    clear
    while true; do
        echo -e "${prompt} ${STRONG_BLUE}Seleccione un entorno:${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}1) Desarrollo${RESET}"
        echo -e "${prompt} ${STRONG_BLUE}2) Producción${RESET}"
        read -p ">" entorno
        if [[ "$entorno" =~ ^[1-2]$ ]]; then
            break
        else
            echo -e "${STRONG_BLUE}Opción no válida. Intente nuevamente.${RESET}"
        fi
    done

    read -p "ID del dispositivo (número): " id
    read -sp "Password " contrasena
    echo

    lugar_code=(FDS22 C9DXZ8)
    dispositivo_code=(X5P1 B8F7 Q2M4 H3J9 D2K6 L7C3)
    departamento_code=(W1Z3 F4Q7 T9B0)
    entorno_code=(R0X4 M2F9)
    
    codigo="${lugar_code[$((lugar-1))]}-${dispositivo_code[$((dispositivo-1))]}-${departamento_code[$((departamento-1))]}-${entorno_code[$((entorno-1))]}-$id"
    
    echo "$codigo:$contrasena" >> reglas.dat
    
    echo -e "${prompt} ${STRONG_BLUE}Código generado: $codigo${RESET}"
    read -p ">"
    menu
}

descifrar_regla() {
    read -p "Ingrese el cifrado >" codigo
    read -sp "Ingrese la contraseña usada para crear la regla >" contrasena
    echo

    encontrado=false
    while IFS=":" read -r regla pass; do
        if [[ "$regla" == "$codigo" && "$pass" == "$contrasena" ]]; then
            encontrado=true
            IFS='-' read -r lugar dispositivo departamento entorno id <<< "$regla"
            clear
            
            echo -e "${prompt} ${STRONG_BLUE}Lugar: ${lugares[$lugar]}${RESET}"
            echo -e "${prompt} ${STRONG_BLUE}Dispositivo: ${dispositivos[$dispositivo]}${RESET}"
            echo -e "${prompt} ${STRONG_BLUE}Departamento: ${departamentos[$departamento]}${RESET}"
            echo -e "${prompt} ${STRONG_BLUE}Entorno: ${entornos[$entorno]}${RESET}"
            echo -e "${prompt} ${STRONG_BLUE}ID: $id${RESET}"
            break
        fi
    done < reglas.dat

    

    read -p ">"
    menu
}

menu
