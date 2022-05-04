;macros 
;mensajes 
;prints 
getPrint macro buffer 
    MOV AX,@data
    MOV DS, AX
    MOV AH,09H
    MOV DX, OFFSET buffer
    INT 21h
endm 
; capturardor de teclado 
 getInput macro
 MOV AH, 01H
 int 21h
 endm 

 getKeyboard macro
 mov ax , 0h 
 mov ah,0h 
 int 16h 
 endm

 getClean macro 
 mov ah , 00h
 mov al , 03h
 int 10h
 endm 

 ; capturar entrada de documento 
 print macro texto 
    mov dx, offset texto
    mov ah, 09h 
    int 21h
endm 

getInputM macro _results 
    mov ah, 3fh
    mov bx , 00
    mov cx, 20
    mod dx , offset[_results]
    int 21h 
endm 

getCleanVariable macro tam,variable
    local Linicio, Lfinal
    xor SI,SI
    Linicio:
        mov variable[SI], 24H 
        inc SI 
        cmp SI , tam 
        je Lfinal 
        jmp Linicio
    Lfinal:
endm  
 ;manejo de contraseñas 
 getPasswordAnalitic macro 
    local e1,e2 
    e1: 
        mov ax,00h 
        mov ah,08h
        int 21h 
        cmp al, 0dh 
        je e2 
        cmp al, 1bh
        je Lmenu
        mov _contrasenia[SI], al 
        inc si 
        mov _contrasenia[SI], '$'
        mov ah,2h 
        mov dl , '*'
        int 21h
        jmp e1 
    e2:
 endm

 AbrirArchivo macro buffer, handler
    mov ah,3dh
    mov al, 02h
    lea dx, buffer 
    int 21h 
    jc Lerror1 
    mov handler,ax 
endm 

; metodo de ordenamiento 

COMMENT #
print macro cadena
    local etiqueta
    etiqueta:
        mov ah, 09h
        mov dx, @data
        mov ds, dx
        mov dx, offset cadena
        int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

abrirA macro ruta, handle
    mov ah,3dh
    mov al,0h
    lea dx, offset ruta
    int 21h
    mov handle,ax
endm

leerA macro buffer, handle
    mov ah, 3fh
    mov bx, handle
    lea dx, buffer
    mov cx, 100h
    int 21h
endm

cerrarA macro handle
    mov ah, 3eh
    mov handle, bx
    int 21h
endm

GuardarNumeros macro buffer,cantidad,arreglo,numero
	LOCAL INICIO,RECONOCER,GUARDAR,FIN,SALIR
	xor bx,bx
	xor si,si
	xor di,di
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo palabras reservadas o caracteres especiales
	;hasta que encuentra un caracter de un numero, y poder iniciar a guardarlo. 
	INICIO:
		mov bl,buffer[si] ; lectura de archivo
		
		cmp bl,36   ; $
		je FIN      ; terminar
		cmp bl,48   ; 0
		jl SALIR    ; salta si es menor que 0
		cmp bl,57   ; 9
		jg SALIR    ; salta si es mayor que 9
		jmp RECONOCER	
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo el numero, hasta que encuentra un caracter de finalizaci�n. 
	;Al encontrarlo procede a guardar dicho numero
	RECONOCER:
		mov bl,buffer[si]
		cmp bl,48
		jl GUARDAR
		cmp bl,57
		jg GUARDAR
		inc si
		mov numero[di],bl
		inc di
		jmp RECONOCER
;--------------------------------------------------------------------------------------------
	; metodo que guarda el numero reconocido en el arreglo
	GUARDAR:
		push si
		ConvertirDec numero
		xor bx,bx
		mov bl,cantidad
		mov arreglo[bx],al
		getChar
		xor ax,ax
		mov al,arreglo[bx]
		ConvertirString numero
		print numero
		Limpiarbuffer numero
		inc cantidad
		pop si
		xor bx,bx
		xor ax,ax
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	SALIR:
		
		inc si
		xor di,di
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	FIN: 
		xor ax,ax
		mov al,cantidad
		mov cantidad2,ax
endm

ConvertirDec macro numero
  LOCAL INICIO,FIN
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
endm

ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
endm

Limpiarbuffer macro buffer
    LOCAL INICIO, FIN
    xor bx, bx
    INICIO:
        mov buffer[bx], 36
        inc bx
        cmp bx, 20
        je FIN
        jmp INICIO
    FIN:
endm

Limpiarbuffer2 macro buffer
    LOCAL INICIO, FIN
    xor bx, bx
    INICIO:
        mov buffer[bx], 36
        inc bx
        cmp bx, 60
        je FIN
        jmp INICIO
    FIN:
endm

copiarArreglo macro fuente, destino
    LOCAL INICIO, FIN

    xor si, si
    xor bx, bx
    INICIO:
        mov bl, cantidad
        cmp si, bx
        je FIN
        mov al, fuente[si]
        mov destino[si], al
        inc si
        jmp INICIO
    FIN:
endm

DeterminarMayor macro 
    LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
    xor si, si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov dx, cantidad2
    dec dx
    BURBUJA:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl MENOR
        inc si
        inc cx
        cmp cx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    MENOR:
        mov arreglo[si], bl
        mov arreglo[si + 1], al
        cmp al, bl
        inc si
        inc cx
        cmp dx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    VERIFICARMENOR:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl RESETEAR
        inc si
        inc cx
        cmp cx, dx
        jne VERIFICARMENOR
        jmp FIN
    RESETEAR:
        mov si, 0
        mov cx, 0
        jmp BURBUJA
    FIN:
        xor ax, ax
        mov al, arreglo[0]
        mov maximo, ax
endm

Burbuja macro
    ;Convertir velocidad en Hz
    mov cl, 16
    sub cl, velocidad1
    inc cl
    mov ax, 500
    mov bl, cl
    mul bl
    mov tiempo, ax
    BurbujaAsc
endm

BurbujaAsc macro
    LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
    xor si, si
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    mov dl, cantidad
    dec dx
    Graficar arreglo
    BURBUJA:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl MENOR
        inc si
        inc cx
        cmp cx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    MENOR:
        mov arreglo[si], bl
        mov arreglo[si + 1], al
        Graficar arreglo
        inc si
        inc cx
        cmp cx, dx
        jne BURBUJA
        mov cx, 0
        mov si, 0
        jmp VERIFICARMENOR
    VERIFICARMENOR:
        mov al, arreglo[si]
        mov bl, arreglo[si + 1]
        cmp al, bl
        jl RESETEAR
        inc si
        inc cx
        cmp cx, dx
        jne VERIFICARMENOR
        jmp FIN
    RESETEAR:
        mov si, 0
        mov cx, 0
        jmp BURBUJA
    FIN:
        GraficarFinal arreglo
endm

Graficar macro arreglo
    pushear
    obtenerNumeros
    DeterminarTamano tamanoX, espacio, cantidad2, espaciador
    pushearVideo arreglo
    ModoGrafico
    imprimirVN numerosMos, 16h, 02h
    poppearVideo arreglo
    graBar cantidad2, espacio2, arreglo
    ModoTexto
    poppear
endm

GraficarFinal macro arreglo
    pushear
    obtenerNumeros
    DeterminarTamano tamanoX, espacio, cantidad2, espaciador
    pushearVideo arreglo
    ModoGrafico
    imprimirVN numerosMos, 16h, 02h
    poppearVideo arreglo
    graBar cantidad2, espacio2, arreglo
    getChar
    getChar
    ModoTexto
    poppear
endm

ModoGrafico macro
    mov ax, 013h
    int 10h
    mov ax, 0A000h
    mov ds, ax
endm

obtenerNumeros macro
    LOCAL INICIO, FIN
    xor si, si
    xor dx, dx
    mov dl, cantidad
    Limpiarbuffer2 numerosMos
    INICIO:
        Limpiarbuffer resultado
        cmp si, dx
        je FIN
        push si
        push dx
        xor ax, ax
        mov al, arreglo[si]
        ConvertirString resultado
        insertarNumero resultado
        Limpiarbuffer resultado
        pop dx
        pop si
        inc si
        jmp INICIO
    FIN:
endm

insertarNumero macro cadena
    LOCAL INICIO, FIN, SIGUIENTE
    xor si, si
    xor di, di
    INICIO: 
        cmp si, 60
        je FIN
        mov al, numerosMos[si]
        cmp al, 36
        je SIGUIENTE
        inc si
        jmp INICIO
    SIGUIENTE:
        mov al, cadena[di]
        cmp al, 36
        je FIN
        mov numerosMos[si], al
        inc di
        inc si
        jmp SIGUIENTE
    FIN:
        mov numerosMos[si], 32
endm

DeterminarTamano macro tamanoX, espacio, cantidad, espaciador
    mov ax, 260  ; tamaño para dibujar de largo o en x
    mov bx, cantidad
    xor bh, bh
    div bl
    xor dx, dx
    mov dl, al
    mov espaciador, dx
    xor ah, ah
    mov bl, 25
    mul bl
    mov bl, 100
    div bl

    mov espacio, al
    mov bx, espaciador
    sub bl, espacio
    mov tamanoX, bx
endm

imprimirVN macro cadena, fila, columna
    push ds
    push dx
    xor dx, dx
    mov ah, 02h
    mov bx, 0
    mov dh, fila
    mov dl, columna
    int 10h

    mov ax, @data
    mov ds, ax
    mov ah, 09
    mov dx, offset cadena
    int 21h
    pop dx
    pop ds
endm

graBar macro cantidad, espacio, arreglo
    LOCAL INICIO, FIN
    xor cx, cx
    INICIO:
        cmp cx, cantidad
        je FIN
        push cx
        mov si, cx
        xor ax, ax
        mov al, arreglo[si]
        mov valor, al
        push ax
        DeterminarColor
        xor ax, ax
        mov ax, maximo
        mov max, al
        dibujarBarra espacio, valor, max
        pop ax
        mov valor, al
        DetSon
        pop cx
        inc cx
        jmp INICIO
    FIN:
endm

DeterminarColor macro 
    LOCAL SEGUNDO, TERCERO, CUARTO, QUINTO, FIN
    cmp valor, 1
    jb FIN
    cmp valor, 20
    ja SEGUNDO
    mov dl, 4
    jmp FIN
    SEGUNDO:
        cmp valor, 40
        ja TERCERO
        mov dl, 1
        jmp FIN
    TERCERO:
        cmp valor, 60
        ja CUARTO
        mov dl, 44
        jmp FIN
    CUARTO:
        cmp valor, 80
        ja QUINTO
        mov dl, 2
        jmp FIN
    QUINTO:
        cmp valor, 99
        ja FIN
        mov dl, 15
        jmp FIN
    FIN:
endm

dibujarBarra macro espacio, valor, max
    LOCAL INICIO, FIN 
    xor cx, cx
    DeterminarTamanoY valor, max
    INICIO:
        cmp cx, tamanoX
        je FIN
        push cx
        mov ax, 170
        mov bx, ax
        sub bl, valor
        xor bh, bh
        mov si, bx
        mov bx, 30
        add bx, espacio
        add bx, cx
        PintarY
        pop cx
        inc cl
        jmp INICIO
    FIN:
        mov ax, espaciador
        add espacio, ax
endm

DeterminarTamanoY macro valor, max
    xor ax, ax
    mov al, valor
    mov bl, 130
    mul bl
    mov bl, max
    div bl
    mov valor, al
endm

PintarY macro
    LOCAL ejey, FIN
    mov cx, si
    ejey:
        cmp cx, ax
        je FIN
        mov di, cx
        push ax
        push dx
        mov ax, 320
        mul di
        mov di, ax
        pop dx
        pop ax
        mov [di + bx], dl
        inc cx
        jmp ejey
    FIN:
endm

DetSon macro
    LOCAL SEGUNDO, TERCERO, CUARTO, QUINTO, FIN
    cmp valor, 1
    jb FIN
    cmp valor, 20
    ja SEGUNDO
    delay 500
    jmp FIN
    SEGUNDO:
        cmp valor, 40
        ja TERCERO
        delay 750
        jmp FIN
    TERCERO:
        cmp valor, 60
        ja CUARTO
        delay 1000
        jmp FIN
    CUARTO:
        cmp valor, 80
        ja QUINTO
        delay 1250
        jmp FIN
    QUINTO:
        cmp valor, 99
        ja FIN
        delay 1500
        jmp FIN
    FIN:
endm
delay macro constante
    LOCAL D1, D2, FIN
    push si
    push di

    mov si, constante
    D1:
        dec si
        jz FIN
        mov di, constante
    D2:
        dec di
        jnz D2
        jmp D1
    FIN:
        pop di
        pop si
endm

limpiarpantalla macro
    mov ah, 0
    mov al, 13h
    int 10h
endm

ModoTexto macro
    mov dx, @data
    mov ds, dx
    mov ax, 0003h
    int 10h
endm

pushear macro
    push ax
    push bx
    push cx
    push dx
    push si
    push di
endm

poppear macro
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm

pushearVideo macro arreglo
    pushArreglo arreglo
    push maximo
    push tamanoX
    push espaciador
    push cantidad2
    push tiempo
endm

poppearVideo macro arreglo
    pop tiempo
    pop cantidad2
    pop espaciador
    pop tamanoX
    pop maximo
    popArreglo arreglo
endm

pushArreglo macro arreglo
    LOCAL INICIO, FIN
    xor si, si
    INICIO:
        xor ax, ax
        cmp si, cantidad2
        je FIN
        mov al, arreglo[si]
        push ax
        inc si
        jmp INICIO
    FIN:
endm

popArreglo macro arreglo
    LOCAL INICIO, FIN
    xor si, si
    mov si, cantidad2
    dec si
    INICIO:
        cmp si, 0
        jl FIN
        pop ax
        mov arreglo[si], al
        dec si
        jmp INICIO
    FIN:
endm
#

;cerrar paths for files in sistem stacks  

Cerrar_Archivo macro handler
    mov ah,3eh 
    mov bx,handler 
    int 21h
    jc Lerror2
endm 

; leer camino 

getLeerArchivo macro handlerm,buffer,numbytes 
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes
    lea dx,buffer
    int 21h
    jc Lerror5
endm 

getLogin macro 
    local e1,e2,e3,e4

    getPrint _enter
    getPrint _chain11
    getInputM _usuario

    getPrint _chain12
    getPasswordAnalitic

    e1:
        getCleanVariable 100, _usuarioSave
        getCleanVariable 100, _contraseniaSave
        GuardarUsuarios
        verificarUsuarios _usuario,_usuarioSave
        cmp _ifBool,1
        je 2 
        jmp e3 
    e2:
        verificarUsuarios _contrasenia,_contraseniaSave
        cmp _ifBool , 0 
        je errorContrasenia
        mov _tamfile,0
        jmp ingresarsist ; verificar main 

    e3: 
        mov si, _tamfile
        cmp _bufferInfo[si], 24h 
        je sinerror ;verificar en main 
        jmp e1
        
endm 

GuardarUsuarios macro 
    local e1,e2,e3,e4
    mov si, _tamfile
    xor bx,bx 
    e1:
        cmp _bufferInfo[SI],','
        je e2
        mov al, _bufferInfo[SI]
        mov _usuarioSave[bx] , al 
        INC si 
        INC bx 
        jmp e1 

    e2:
        INC si 
        xor bx,bx
    e3:
        cmp _bufferInfo[si], 0Ah 
        je e4
        mov al, _bufferInfo[si]
        mov _contraseniaSave[bx],al 
        INC si 
        INc bx 
        jmp e3 
    e4: 
        getPrint _enter
        getPrint _usuario
        getPrint _separador
        inc si 
        mov _tamfile ,si 

endm 


verificarUsuarios macro p1,p2 
    local e1,e2,e3,e4,e5
    xor si,si 
    xor al,al

    e1: 
        mov al , p1[si]
        cmp al, 24h 
        je e2 
        jmp e3 
    
    e3:
        mov al, p2[si]
        cmp al ,24h 
        je e4 
        cmp al,p1[si]
        jne e2 
        inc si 
        jmp e3 

    e4: 
        mov _ifBool,1 
        jmp e5
    e2: 
        mov _ifBool,0
        jmp e5
    e5:



endm 
; path write 

EscirbirArchivo macro handler, buffer 
    LOCAL  e1,e2
    MOV AX,@data
    MOV DS,AX
    XOR BX,BX
    XOR AX,AX 
    e1:
        MOV AL , buffer[BX]
        CMP AL, '$'
        JE e2
        INC BX 
        JMP e1
    e2: 
        XOR BX ,BX 
        MOV AH,40h 
        MOV BX,handler
        MOV CX,_BufferCount
        LEA DX, buffer 
        INT 21h
endm 