;MAGALI ANAHI MEZA CHAVEZ
.model small
ORG 100h
;---------------------
;Segmento de datos
.data 
    ;Impresiones en pantalla
    menuOpc db '-----------MENU-----------',13,10
                db '1. Suma',13,10
                db '2. Resta',13,10
                db '3. Division',13,10
                db '4. Multiplicacion',13,10
                db '5. Potencia',13,10  
                db '6. Salir',13,10,13,10
				db 'Opcion seleccionada: $',13,10
	sumaMsg db 10,13,10,13, 'Suma','$'
	restaMsg db 10,13,10,13, 'Resta','$'
	diviMsg db 10,13,10,13, 'Division','$'
	multiMsg db 10,13,10,13, 'Multiplicacion','$'
	potMsg db 10,13,10,13, 'Potencia','$'
    ingresa db 10,13,'Ingresa un digito: ', 	'$'  
    resSuma db 10,13,10,13,'El resultado de la suma es= ',				'$'
	resResta db 10,13,10,13,'El resultado de la resta es= ',				'$'
    resDiv db 10,13,10,13,'El resultado de la Division es= ',			'$'
    resMulti db 10,13,10,13,'El resultado de la Multiplicacion es= ',	'$'
    resPotencia db 10,13,10,13,'El resultado de la potencia es= ',	'$'
    
    ;Almacena los dos digitos
    num1 db ?
	num2 db ?
	
	;Guarda unidades y decenas
    decenas db ?
    unidades db ?   
    
    potenciaVar db 1    ;Ayuda a potencia
    
;---------------------
;Macros

;Macro que imprime
imprimir macro msg
    MOV AH,09h
    LEA DX,msg      ;Cargar el parametro a imprimir
	INT 21h     
endm

;Macro que pide los digitos
pideNum macro numero
	imprimir ingresa    ;Imprime la variable para pedir un numero
	
	MOV AH,01h          ;Entrada de caracter
	INT 21h 
	
	SUB AL,30h          ;Convertir caracter decimal
	MOV numero,AL       ;Pone AL en el la variable parametro
endm

;Macro que recibe el resultado y lo imprime
resul macro AX
    MOV decenas,AH      ;Mueve AH a decenas
    MOV unidades,AL     ;Mueve AL a unidades
    
    ADD decenas,30h     ;Convertir a caracter
	ADD unidades,30h    ;Convertir a caracter
	
	;Imprime decenas y unidades
    MOV AH,02h
    MOV DL,decenas
    INT 21h 
    
    MOV AH,02h
    MOV DL,unidades
    INT 21h	  
    
	MOV AH,01           ;Entrada de carcacter
	INT 21h
endm 

;---------------------
;Segemento de codigo
.code
Inicio:
	;Carga el segemnto de datos en ds
    MOV AX, @data
	MOV DS,AX
Menu:
    ;Activa modo de video
    MOV AH,00h  
	MOV AL,03h
 	INT 10h  
 	
	MOV CX,02h   

	imprimir menuOpc ;Imprime el menu
	
	MOV AH,01h       ;Entrada de caracter
	INT 21h  
	
	XOR AH,AH        ;Limpia AH
	SUB AL,30h       ;Convertir caracter decimal
	
	;Salto a la opcion que haya en AL
	CMP AL,1
	JE Suma
	CMP AL,2
	JE Resta
	CMP AL,3
	JE Division
	CMP AL,4
	JE Multiplicacion
	CMP AL,5
	JE Potencia 
	CMP AL,6
	JE Salir
	JMP Menu ;Si no es ninguna opcion salta de nuevo al menu

Salir:
    ;Termina el programa y retorna el control al sistema
	MOV AX,4C00h
	INT 21h
	
Suma:
	imprimir sumaMsg  ;Imprime mensaje
	
	;Pide los dos numeros
	pideNum num1
	pideNum num2
	
    imprimir resSuma 
    
    ;Suma
    MOV AL,num1
    ADD AL,num2
    AAM                ;Ajuste
    
    ;Muestra el resultado
    resul AX
	
	;Salta a Menu
	JMP Menu 
	
Resta:
	imprimir restaMsg   ;Imprime mensaje  
	
	;Pide los dos numeros
	pideNum num1
	pideNum num2   
	
	imprimir resResta
    
    ;Resta
    XOR AX,AX
    MOV AL, num1
    SUB AL, num2
    AAS                 ;Ajuste en resta
    
    ;Imprime el resultado    
    resul AX
    
    ;Salta a menu
    JMP Menu 
    
Division:
	imprimir diviMsg    ;Imprime mensaje
	
	;Pide los dos numeros
	pideNum num1
	pideNum num2  
	
	imprimir resDiv 
	
	;Division
    XOR AX,AX           ;Limpia AX
    MOV AL, num1
    MOV BL,num2
    DIV BL
    AAD                 ;Ajuste en Division
    
    ;Imprime el resultado   
    resul AX
    
    ;Salta a menu
    JMP Menu 
    
Multiplicacion:
	imprimir multiMsg   ;Imprime mensaje
	
	;Pide los dos numeros
	pideNum num1
	pideNum num2   
	
	imprimir resmulti
	
	;Multiplicacion
    MOV AL,num1
    MOV BL,num2
    MUL BL
    AAM                 ;Ajuste en Multiplicacion
    
    ;Imprime resultado   
    resul AX
    
    ;Salta a menu
    JMP Menu 

Potencia:
	imprimir potMsg         ;Imprime mensaje
	
	;Pide los dos numeros
	pideNum num1
	pideNum num2   
	
	imprimir resPotencia
	
	;Potencia
	MOV cl, num2            ;Numero de ciclos
    producto:
        MOV AL, num1 
        MOV BL, potenciaVar
        MUL BL
        MOV potenciaVar, AL 
        LOOP producto 
    
    MOV AL, potenciaVar    ;Pone el valor final en AL
    AAM                    ;Ajuste en Multiplicacion 
    MOV num1, AL
    MOV num2, AH
    
    ;Imprime el resultado    
    resul AX 
    
    MOV potenciaVar, 0001h ;Vuelve a poner el valor
    
    ;Salta a menu
    JMP Menu
       
end Inicio