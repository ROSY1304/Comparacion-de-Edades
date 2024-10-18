.MODEL SMALL
.STACK 100H

.DATA
    promptName1 DB 'Ingrese el nombre de la primera persona: $'
    name1 DB 21            ; El primer byte es la longitud m?xima (20 caracteres + 1 para la longitud real)
    DB 20 DUP('$')         ; Espacio para el nombre de la primera persona
    promptAge1 DB 0DH,0AH,'Ingrese la edad de la primera persona: $'
    age1 DB 0              ; Almacenar la edad de la primera persona
    
    promptName2 DB 0DH,0AH,'Ingrese el nombre de la segunda persona: $'
    name2 DB 21            ; El primer byte es la longitud m?xima (20 caracteres + 1 para la longitud real)
    DB 20 DUP('$')         ; Espacio para el nombre de la segunda persona
    promptAge2 DB 0DH,0AH,'Ingrese la edad de la segunda persona: $'
    age2 DB 0              ; Almacenar la edad de la segunda persona

    ; Ajuste para imprimir el mensaje en un rengl?n aparte
    msgOlder DB 0DH, 0AH, 0DH, 0AH, ' es mayor.$', 0DH, 0AH, '$'

.CODE
MAIN PROC
    ; Inicializar segmento de datos
    MOV AX, SEG promptName1  ; Inicializamos el segmento de datos correctamente
    MOV DS, AX

    ; Solicitar nombre de la primera persona
    LEA DX, promptName1
    MOV AH, 09H
    INT 21H

    ; Leer nombre 1
    LEA DX, name1
    MOV AH, 0AH
    INT 21H

    ; Solicitar edad de la primera persona
    LEA DX, promptAge1
    MOV AH, 09H
    INT 21H

    ; Leer edad de 2 d?gitos para la primera persona
    CALL LEER_EDAD
    MOV age1, AL           ; Guardar la edad de la primera persona

    ; Solicitar nombre de la segunda persona
    LEA DX, promptName2
    MOV AH, 09H
    INT 21H

    ; Leer nombre 2
    LEA DX, name2
    MOV AH, 0AH
    INT 21H

    ; Solicitar edad de la segunda persona
    LEA DX, promptAge2
    MOV AH, 09H
    INT 21H

    ; Leer edad de 2 d?gitos para la segunda persona
    CALL LEER_EDAD
    MOV age2, AL           ; Guardar la edad de la segunda persona

    ; Comparar las edades
    MOV AL, age1
    CMP AL, age2
    JG  PERSONA1_MAYOR   ; Si la edad1 es mayor
    JL  PERSONA2_MAYOR   ; Si la edad2 es mayor

    ; Si las edades son iguales
    LEA DX, name1 + 1   ; Saltamos el primer byte (longitud)
    MOV AH, 09H
    INT 21H
    LEA DX, name2 + 1   ; Saltamos el primer byte (longitud)
    MOV AH, 09H
    INT 21H
    MOV DX, OFFSET msgOlder
    MOV AH, 09H
    INT 21H
    JMP FIN

PERSONA1_MAYOR:
    ; Imprimir nombre 1
    LEA DX, name1 + 1   ; Saltamos el primer byte (longitud)
    MOV AH, 09H
    INT 21H
    JMP MOSTRAR_RESULTADO

PERSONA2_MAYOR:
    ; Imprimir nombre 2
    LEA DX, name2 + 1   ; Saltamos el primer byte (longitud)
    MOV AH, 09H
    INT 21H

MOSTRAR_RESULTADO:
    ; Mostrar qui?n es mayor
    MOV DX, OFFSET msgOlder
    MOV AH, 09H
    INT 21H

FIN:
    ; Terminar el programa
    MOV AH, 4CH
    INT 21H

; Subrutina para leer una edad de 2 d?gitos
LEER_EDAD PROC
    ; Leer primer d?gito
    MOV AH, 01H
    INT 21H
    SUB AL, '0'          ; Convertir el car?cter ASCII a n?mero
    MOV BL, AL           ; Guardar el primer d?gito en BL

    ; Leer segundo d?gito
    MOV AH, 01H
    INT 21H
    SUB AL, '0'          ; Convertir el car?cter ASCII a n?mero

    ; Calcular la edad: (primer d?gito * 10) + segundo d?gito
    MOV BH, 0            ; Limpiar BH para la multiplicaci?n
    MOV AL, BL
    MOV CL, 10
    MUL CL               ; AL = primer d?gito * 10
    ADD AL, BL           ; AL = AL + segundo d?gito
    RET
LEER_EDAD ENDP

MAIN ENDP
END MAIN
