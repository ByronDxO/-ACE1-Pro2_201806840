include atajos.asm
.model small
.stack
.data 

; variables 
; mensajes claves 
_enter db 0ah,0dh, "$"
_separador db 0ah,0dh, "-------------------------------------$"
_mensaje_predeterminado db 0ah,0dh, "ingresar seleccion: $"
; mensajes inicio 
_chain1 db 0ah,0dh, "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA$"
_chain2 db 0ah,0dh, "FACULTAD DE INGENIERIA$"
_chain3 db 0ah,0dh, "ESCUELA DE CIENCIAS Y SISTEMAS$"
_chain4 db 0ah,0dh, "ARQUITECTURA DE COPMILADORES Y ENSAMBLADORES$"
_chain5 db 0ah,0dh, "SECCION <A>$"
_chain6 db 0ah,0dh, "<BYRON RUBEN HERNANDEZ DE LEON>$"
_chain7 db 0ah,0dh, "<201806840>$"
; mensajes de menu  
_chain8 db 0ah,0dh, "Login  F1$"
_chain9 db 0ah,0dh, "Registrarse  F2$"
_chain10 db 0ah,0dh, "salir   F3$"
; mensajes para inicio de login  
_chain11 db 0ah,0dh, "nombre de usuario:$"
_chain12 db "contraseña: $"
 ;vairblaes de login 
 _usuario db 100 dup('$')
 _contrasenia db 100 dup('$')
 _usuarioSave db 100 dup('$')
 _contraseniaSave  db 100 dup('$')
 _tamfile dw 0
 _handle dw ?
 _ifBool dw 0
 ;permisos denegados 
_permiso1 db 0ah,0dh , "permission denied$"
_permiso2 db 0ah,0dh, "there where 3 failed login attempts$"
_permiso3 db 0ah,0dh, "Please contact the administrator$"
_permiso4 db 0ah,0dh, "Press Enter to go back to menu$"
_permiso5 db 0ah,0dh, "wait 18 seconds and try again$"
;mensajes validaciones contraselas 
_validacion1 db 0ah,0dh, "Action Rejected$"
_validacion2 db 0ah,0dh, "missed requirements:$"
_validacion3 db 0ah,0dh, "username begins with a letter $"
_validacion4 db 0ah,0dh ,"username length between 8 and 15 characters$"
_validacion5 db 0ah,0dh, "Password must contain at least one number$"
_validacion6 db 0ah,0dh, "Password length at least 16 character$"
_validacion7 db 0ah,0dh, " Press Enter to go to back menu$"
;menu jugador
_jugador1 db 0ah,0dh, "F2. Play game$"
_jugador2 db 0ah,0dh, "F3. Show to top 10 scoreboards$"
_jugador3 db 0ah,0dh, "F5. shoy my top 10 scoreboard$"
_jugador4 db 0ah,0dh,"F9. Logout$"

;menu administrador
_menuAdmin1 db 0ah,0dh, "F1. unlock user $"
_menuAdmin2 db 0ah,0dh, "F2. Promote user to admin$"
_menuAdmin3 db 0ah,0dh, "F3. Demote user from admin$"
_menuAdmin4 db 0ah,0dh, "F5. Bubble sort$"
_menuAdmin5 db 0ah,0dh, "F6. Heap sort$"
_menuAdmin6 db 0ah,0dh, "F7. Tim sort$"
_menuAdmin7 db 0ah,0dh, "F9. Logout$"
; MENU ADMINISTRADOR NORMAL
_normalAdmin1 db 0ah,0dh, "F1. unlock user $"
_normalAdmin2 db 0ah,0dh, "F2. Show to top 10 scoreboards$"
_normalAdmin3 db 0ah,0dh, "F3. Show my top 10 scoreboards$"
_normalAdmin4 db 0ah,0dh, "F4. Play Game$"
_normalAdmin5 db 0ah,0dh, "F5. Bubble sort$"
_normalAdmin6 db 0ah,0dh, "F6. Heap sort$"
_normalAdmin7 db 0ah,0dh, "F7. Tim sort$"
_normalAdmin8 db 0ah,0dh, "F9. Logout$"
;unlock user  sin errorres 
_unlock1 db 0ah,0dh, "succesfully unlock user$"
_unlock2 db 0ah,0dh, "Press enter go to back Menu$"
;unlock user con errores 
_unlock3 db 0ah,0dh, "error, wasn't locked$"
_unlock4 db 0ah,0dh, "Press enter go to bakc Menu$"

;menu estadisticas 
;menu ordenamientos 
;buffers 
_bufferInput    db 50 dup('$')
_handleInput    dw ? 
_bufferInfo     db 2000 dup('$')
_BufferCount  dw 0 
_reporteHandle  dw ?

; procs 
; mensaje de inicio de sistema 
funcIdentificar proc far 
    getPrint _chain1
    getPrint _chain2
    getPrint _chain3
    getPrint _chain4
    getPrint _chain5
    getPrint _chain6
    getPrint _chain7
    getPrint _separador
    ret 
funcIdentificar endp
;menu jugador 
functionMenuJugador proc far 
    getPrint _jugador1
    getPrint _jugador2
    getPrint _jugador3
    getPrint _jugador4
    getPrint _separador
    ret
functionMenuJugador endp
;menu adminadmin
functionMenuAdminAdmin proc far
    getPrint _menuAdmin1
    getPrint _menuAdmin2
    getPrint _menuAdmin3
    getPrint _menuAdmin4
    getPrint _menuAdmin5
    getPrint _menuAdmin6
    getPrint _menuAdmin7
    getPrint _separador
    ret 
functionMenuAdminAdmin endp
; menu admin normal 
functionMenuAdminNormal proc far
    getPrint _normalAdmin1
    getPrint _normalAdmin2
    getPrint _normalAdmin3
    getPrint _normalAdmin4
    getPrint _normalAdmin5
    getPrint _normalAdmin6 
    getPrint _normalAdmin7
    getPrint _normalAdmin7
    getPrint _normalAdmin8
    getPrint _separador
    ret 
functionMenuAdminNormal endp

; login errores 
functionLoginError proc far 
    getPrint _unlock1
    getPrint _unlock2
    getPrint _separador
    ret
functionLoginError endp 
; menu  
functionMenu proc far 
    getPrint _chain8
    getPrint _chain9
    getPrint _chain10
    getPrint _separador
    ret 
functionMenu endp
;funcion de login 

functionLogin proc far 
    getPrint _chain11
    getPrint _separador
    getPrint _enter
    ret 
    functionLogin endp 

funcionRechazo proc far
ret 
funcionRechazo endp

; code 
.code 
 ; inicio de aplicaion mensaje de identificacion 
main proc

 Lstart:
 call funcIdentificar
 getInput 
 cmp al,0Dh
 je Lmenu
 jmp Lstart

; mensajes de menu ejecucion de gramatica 

Lmenu:
call functionMenu
getInput
cmp ax,3b00h ; 1 en hexa 
cmp al,32H ; 2 en hexa 
je Llogin
cmp al,33H ; 3 en exa 
je Lexit
jmp Lmenu

Llogin: 
call functionLogin
getInput
jmp Lmenu


Lexit:
mov ax,4c00h
int 21h


main endp
end main
