; FUNCIONES de C
	extern malloc
	extern free
	extern fopen
	extern fclose
	extern fprintf

;define tipos de dato y puntero 
	%define NULL 0
	%define NONE 0
	%define INTEGER 1
	%define STRING 2
	%define LIST 3
	%define MATRIX 4

; //* defines estructura Entero, String y List *//
	%define tam_list_elem 16
	%define tam_list 32
	%define tam_string 32
	%define tam_entero 32
	%define tam_matrix 40

	%define OFFSET_dataType 0
	%define OFFSET_remove 8
	%define OFFSET_print 16
	%define OFFSET_first 24
	%define OFFSET_data 24

	%define OFFSET_elem_data 0
	%define OFFSET_elem_next 8

	%define OFFSET_columna 24
	%define OFFSET_fila 28
	%define OFFSET_elemMatriz 32


section .data
msgNULL: DB "NULL",0
formatoString: db "%s",0 
formatoInt: db "%d",0 
corcheteIzq : db "[",0
corcheteDer : db "]",0 
coma : db ",",0

section .text

global str_len
global str_copy
global str_cmp
global str_concat
global matrixAdd
global matrixRemove
global matrixDelete
global listNew
global listAddFirst
global listAddLast
global listAdd
global listRemove
global listRemoveFirst
global listRemoveLast
global listDelete
global listPrint
global strNew
global strSet
global strAddRight
global strAddLeft
global strRemove
global strDelete
global strCmp
global strPrint
global intNew
global intSet
global intRemove
global intDelete
global intCmp
global intPrint
;########### Funciones Auxiliares Recomendadas

; uint32_t str_len(char* a)
str_len:
	xor rax,rax
	.ciclo:
		cmp byte [rdi],0
		je .fin
		add rax,1
		add rdi,1
		jmp .ciclo
	
	.fin:	
	ret

; char* str_copy(char* a)
str_copy:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	
	mov r12, rdi 			 ; guardo el string1 en r12 para guardar puntero al contenido en rdi

	call str_len

	mov r13,rax 			 ; guardo el largo de string1 en r13 para guardar el valor contenido en rax
	
	mov rdi,rax
	inc rdi
	call malloc 			 ; en rax tengo puntero a memoria reservada para construir mi string
	mov r15,rax

	mov rcx,r13 			 ; loop largo de string1
	cmp r13,0 				 ; caso string largo 0
	je .finCopia

	.copia:
		mov byte r14b, [r12] 
		mov byte [r15],r14b
		inc r15
		inc r12
		loop .copia

	.finCopia:
		mov byte [r15],0

	pop r15
	pop r14
	pop r13
	pop r12	
	pop rbp
	ret

; int32_t str_cmp(char* a, char* b)
str_cmp:
	push rbp
	mov rbp,rsp
	push r12 
	push r13
	push r14
	push r15

	mov rax,0
	mov r12,rdi 		; r12 <-- puntero a string1
	mov r13,rsi 		; r12 <-- puntero a string1

	call str_len
	mov r14,rax 		; r14 <-- longitud de string1
	
	mov rdi,r13
	call str_len
	mov r15,rax 		; r15 <-- longitud de string2

	cmp r14,0
	jne .string2Vacio?
	cmp r15,0
	je .iguales

	.string2Vacio?:
		cmp r15,0
	je .mayor	


	cmp r14,r15
	jg .minLongitud
	mov rcx,r14

	.minLongitud:
		mov rcx,r15

	mov rcx,r14 		; rcx <-- itero cantidad de veces largo de string mas chico
	cmp rcx,0

	.comparoStrings:
		mov r8b,[r12]		
		cmp byte r8b,[r13]
		jg .mayor
		jl .menor
		inc r12
		inc r13
		loop .comparoStrings

	cmp r14,r15
	jl .menor
	je .iguales
	.mayor:
		mov rax,-1
		jmp .fin

	.menor: 
		mov rax,1
		jmp .fin

	.iguales:	
		mov rax,0
		
	.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp		
	ret
	
;char* str_concat(char* a, char* b)
str_concat:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15

	mov r12, rdi 					; r12 <-- puntero a string1
	mov r13, rsi 					; r13 <-- puntero a string2

	call str_len
	mov r14, rax 					; r14 <-- largo de string1

	mov rdi,r13
	call str_len
	mov r15, rax 					; r15 <-- largo de string2

	;en rdi guardo el tamaño que necesito pedir a memoria para la concat de los strings
	mov rdi,r14
	add rdi,r15
	inc rdi

	call malloc 

	mov rdi, rax 					; rdi <-- puntero al string concatenado


	mov rcx,r14 					;loop largo de string1
	cmp r14,0 	 					;caso string1 largo 0
	je .finString1

	.copiaString1:
		mov byte bl,[r12] 
		mov byte [rdi],bl
		inc rdi
		inc r12
		loop .copiaString1

	.finString1:
		mov rcx,r15 			    ; loop largo de string2
		cmp r15,0 	 				; caso string2 largo 0
		je .fin	

	.copiaString2:
		mov byte bl,[r13] 
		mov byte [rdi],bl
		inc rdi
		inc r13
		loop .copiaString2

	.fin:
		mov byte [rdi],0
	pop r15
	pop r14	
	pop r13
	pop r12	
	pop rbp			
	ret
;########### Funciones Auxiliares Propias
; string_t* strConcatAux(string_t* s, string_t* d, int i);
strConcatAux:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15

	mov r12,rdi 						; r12 <-- *s
	mov r13,rsi 						; r13 <-- *d
	mov qword r14,[r12 + OFFSET_data]
	cmp dword edx, 0
	jne .concatIzq
	mov  rdi,r14 						; rdi <-- (s->data)
	mov qword rsi,[r13 + OFFSET_data] 	; rsi <-- (d->data) 
	jmp .concat
	.concatIzq:
	mov  rsi,r14 						; rdi <-- (s->data)
	mov qword rdi,[r13 + OFFSET_data] 	; rsi <-- (d->data) 

    .concat:
	call str_concat
	mov r15,rax 						; r15 <-- s+d
	mov rdi,r12 						; rdi <-- *s
	call strRemove 						; borro el string s de *s
	cmp r13,r12
	je .fin
	mov rdi,r13 						; rdi <-- *d
	call strDelete					    ; borro el string_t d

	.fin:
	mov qword [r12 + OFFSET_data],r15 	; (s->data) <-- s+d

	mov rax, r12 						; rax <-- *s

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret	

; listElem_t* crearNodo(void* data)
crearNodo:
	push rbp
	mov rbp,rsp
	push r12
	sub rsp,8
	mov r12,rdi
	mov rdi,tam_list_elem 						; pido tamaño de 16 bytes para struct list_elem
	call malloc
	mov	qword [rax + OFFSET_elem_data],r12 		; (nodo->data) <-- data
	mov qword [rax + OFFSET_elem_next],NULL 	; (nodo->next) <-- NULL
	add rsp,8
	pop r12
	pop rbp
	ret
; void borrarNodo(listElem_t* nodo)
borrarNodo:
	push rbp
	mov rbp,rsp
	push r12
	sub rsp,8
	mov r12,rdi
	mov rdi,[rdi + OFFSET_elem_data] 			; borro primero el dato del Nodo
	mov r8,[rdi + OFFSET_remove]
	call r8
	mov rdi,r12
	call free
	add rsp,8
	pop r12
	pop rbp
	ret	

;########### Funciones Matriz
; matrix_t* matrixAdd(matrix_t* m, uint32_t x, uint32_t y, void* data);
matrixAdd:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15

	xor r13,r13
	xor r14,r14
	mov r12,rdi 								; puntero a matriz
	mov dword r13d,esi 							; columna x
	mov dword r14d,edx 							; fila y
	mov r15,rcx

	xor r9,r9
	xor r8,r8
	xor r10,r10
	mov qword r8,[r12 + OFFSET_elemMatriz] 		; comienzo de memoria donde estan almacenados los elems
	mov dword r9d,[r12 + OFFSET_fila] 			; m = filas
	mov dword r10d,[r12 + OFFSET_columna] 		; n = columnas
	imul r10d,r14d 								; fila en donde quiero añadir dato
	imul r10d,8
	add r8,r10
	imul r13d,8
	add r8,r13
	mov qword r11,[r8] 							; dato viejo
	cmp r11,NULL
	je .fin
	push r8
	push r11
	mov rdi,r11 								; borro dato viejo
	mov qword r11,[rdi + OFFSET_remove]
	call r11 									; dato->remove(dato)
	pop r11
	pop r8
	
	.fin:
	mov qword [r8],r15 							; m[i][j] <-datoNuevo
	mov rax,r12

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	
; matrix_t* matrixRemove(matrix_t* m, uint32_t x, uint32_t y);
matrixRemove:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15

	xor r13,r13
	xor r14,r14
	mov r12,rdi 								; puntero a matriz
	mov dword r13d,esi 							; columna x
	mov dword r14d,edx 							; fila y

	xor r9,r9
	xor r8,r8
	xor r10,r10
	mov qword r8,[r12 + OFFSET_elemMatriz] 		; comienzo de memoria donde estan almacenados los elems
	mov dword r9d,[r12 + OFFSET_fila] 			; m = filas
	mov dword r10d,[r12 + OFFSET_columna] 		; n = columnas
	imul r10d,r14d 								; fila en donde quiero añadir dato
	imul r10d,8
	add r8,r10
	imul r13d,8
	add r8,r13
	mov qword r11,[r8] 							; dato viejo
	cmp r11,NULL
	je .fin
	mov qword [r8],NULL 						; ahora m[i][j] es null
	mov rdi,r11 								;borro dato viejo
	mov qword r11,[rdi + OFFSET_remove]
	call r11 									; dato->remove(dato)
	.fin:

	mov rax,r12

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	
; void matrixDelete(matrix_t* m);
matrixDelete:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp,8

	mov r12,rdi

	mov dword r13d,[r12 + OFFSET_fila] 			; m
	mov dword r14d,[r12 + OFFSET_columna] 		; n

	xor rbx,rbx 								;contador filas
	xor r15,r15 								;contador columnas
	.cicloFila:
		cmp dword ebx,r13d 
		je .termineBorrarDatos
		.cicloColumna:
			cmp dword r15d,r14d
			je .termineCol
			mov rdi,r12
			mov dword esi,r15d
			mov dword edx,ebx
			call matrixRemove
			inc r15d
			jmp .cicloColumna
		.termineCol:
			xor r15d,r15d
			inc ebx
			jmp .cicloFila

	.termineBorrarDatos:
		mov qword rdi,[r12 + OFFSET_elemMatriz]
		call free
		mov qword rdi,r12
		call free

	add rsp,8
	pop rbx			
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp

	ret
	
;########### Funciones: Lista

; list_t* listNew();
listNew:
	push rbp
	mov rbp,rsp
	mov rdi,tam_list 							; pido 32 bytes de memoria para el struct lista
	call malloc
	mov dword [rax + OFFSET_dataType],LIST 		;(list->dataType) <-- LIST
	mov qword [rax + OFFSET_remove],listDelete  ; (list->remove) <-- NULL
	mov qword [rax + OFFSET_print],listPrint 	; (list->print) <-- NULL
	mov qword [rax + OFFSET_first],NULL 		; (list->first) <-- NULL
	pop rbp
	ret
	
; list_t* listAddFirst(list_t* l, void* data);
listAddFirst:
	push rbp
	mov rbp,rsp
	push r12
	sub rsp,8
	mov r12,rdi
	mov rdi,rsi 								; creo nodo
	call crearNodo
	mov qword r8,[r12 + OFFSET_first] 			; r8 <-- (list->prim)
	mov qword [rax + OFFSET_elem_next],r8
	mov qword [r12 + OFFSET_first],rax
	mov rax,r12
	add rsp,8
	pop r12
	pop rbp
	ret
	
; list_t* listAddLast(list_t* l, void* data);
listAddLast:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	mov r12,rdi
	mov r13,rsi

	mov rdi,rsi
	call crearNodo                            ; rax <-- nodo_creado

	mov qword r8,[r12 + OFFSET_first]         ; r8 <-- (list->prim)
	cmp qword r8,NULL
	jne .listaNoVacia
	;lista vacia ? inserto nodo al principio                          
	.listaVacia:       
		mov qword [r12 + OFFSET_first],rax
		jmp .fin
	;lista no vacia	
	.listaNoVacia:
		mov qword r9,[r8 + OFFSET_elem_next]  ; (nodo_actual->next) == NULL ? encontre el ultimo nodo
		cmp r9,NULL
		je .encontreUlt
		mov r8,r9                             ; si no encontre ultimo, sigo recorriendo ( nodo_actual <-- (nodo_actual->next) )
		jmp .listaNoVacia
	.encontreUlt:
		mov qword [r8 + OFFSET_elem_next],rax ; (nodo_actual-->next) <-- nodo_creado

	.fin:
		mov rax,r12
	pop r13
	pop r12
	pop rbp		
	ret
	
; list_t* listAdd(list_t* l, void* data, funcCmp_t* f);
listAdd:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	mov r12,rdi 									; r12 <-- lista
	mov r13,rdx 									; r13 <-- f
	mov r14,rsi 									; r14 <-- data


	mov qword r9,[r12 + OFFSET_first] 				; r9 <-- nodo_actual
	mov qword r10,NULL 								; r10 <-- nodo_previo

	.ciclo:
		cmp qword r9,NULL 
		je .finCiclo
		mov qword rdi,[r9 + OFFSET_elem_data] 		; rdi <-- (nodo_actual->data)
		mov qword rsi,r14 							; rsi <-- (nodo_creado->data)
		call r13
		cmp dword eax,-1                
		je .finCiclo
		mov r10,r9 									; nodo_previo <-- nodo_actual
		mov qword r9,[r10 + OFFSET_elem_next] 		; nodo_actual <-- (nodo_actual->next)
		jmp .ciclo

	.finCiclo:
		cmp qword [r12 + OFFSET_first],r9
		jne .agregoNodoInterno
		.agregoAdelante:
			mov rdi,r12
			mov rsi,r14
			call listAddFirst
			jmp .fin
		.agregoNodoInterno:
			mov rdi,r14
			call crearNodo
			mov qword [r10 + OFFSET_elem_next],rax
			mov qword [rax + OFFSET_elem_next],r9
			mov rax,r12

	.fin:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp				
	ret



; list_t* listRemove(list_t* l, void* data, funcCmp_t* f);
listRemove:
	push rbp
	mov rbp,rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp,8

	mov r12,rdi 										; r12 <-- list
	mov r13,rsi 										; r13 <-- data
	mov r14,rdx 										; r14 <-- f

	mov qword rbx,[r12 + OFFSET_first] 					; rbx <-- nodo_actual	
	mov qword r15,NULL 									; r15 <-- nodo_previo
	cmp rbx, NULL 										; lista vacia ?
	je .fin

	.ciclo:
		cmp qword rbx,NULL 								; termine de recorrer ?
		je .fin
		mov rdi,[rbx + OFFSET_elem_data]
		mov rsi,r13
		call r14 										; node->data == data ?
		cmp dword eax,0
		jne .noBorrarElem
		.borrarElem:
			mov qword r10,[rbx + OFFSET_elem_next] 		; r10 <-- (nodo_actual->next)
			cmp qword r15,NULL 							; prim elem de la lista a borrar ?
			jne .actualizoPrevio
			.primElem:
				mov qword [r12 + OFFSET_first],r10 		; (list->first) <-- (nodo_actual->next)
				jmp .actualizoDatos
			.actualizoPrevio:
				mov qword [r15 + OFFSET_elem_next],r10 	; (nodo_previo->next) <-- (nodo_actual->next)
			.actualizoDatos:
				mov qword rdi,rbx 
				mov qword rbx,[rbx + OFFSET_elem_next] 	; nodo_actual <-- (nodo_actual->next)
				call borrarNodo
				jmp .ciclo

		.noBorrarElem:
			mov r15,rbx
			mov qword rbx,[rbx + OFFSET_elem_next]
			jmp .ciclo

	.fin:
		mov rax,r12

	add rsp,8	
	pop r15
	pop r14
	pop r13
	pop r12	
	pop rbx
	pop rbp
	ret

listRemoveFirst:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	mov r12,rdi
	mov qword r8,[r12 + OFFSET_first] 				; r8 <-- (list->prim)
	cmp r8,NULL 									; lista vacia entonces no borro nada
	je .fin
	mov qword r9,[r8 + OFFSET_elem_next] 			; (list->prim)->next es el nuevo (list->prim)
	mov qword [r12 + OFFSET_first],r9
	mov rdi,r8 										; rdi <-- (list->prim) viejo
	call borrarNodo 								; borro primero
	.fin:
		mov rax,r12
	
	pop r13
	pop r12
	pop rbp
	ret
	
; list_t* listRemoveLast(list_t* l);
listRemoveLast:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	mov r12,rdi
	mov qword r8,[r12 + OFFSET_first]     		; r8 <-- (list->first)
	cmp r8,NULL									; lista vacia ? entonces no hay nodo que borrar
	je .fin
	;lista de un unico nodo ? entonces actualizo list->first = NULL								  
	mov qword r9,[r8 + OFFSET_elem_next]              
	cmp r9,NULL
	jne .listaLongitudMayorUno
	.listaLongitudUno:
		call listRemoveFirst
		jmp .fin
	; tengo guardados nodo_actual en r8 y nodo_previo en r10	
	.listaLongitudMayorUno:
		cmp r9,NULL
		je .encontreUlt
		mov r10,r8
		mov r8,r9
		mov qword r9,[r8 + OFFSET_elem_next]
		jmp .listaLongitudMayorUno
	;actualizo el next del anteultimo nodo y borro el ultimo nodo	
	.encontreUlt:
		mov qword [r10 + OFFSET_elem_next],NULL
		mov rdi,r8
		call borrarNodo	
	.fin:
		mov rax,r12
	
	pop r13
	pop r12
	pop rbp
	ret
	
; void listDelete(list_t* l);
listDelete:
	push rbp
	mov rbp,rsp
	push r12
	sub rsp,8
	mov r12,rdi

	;elimino nodos
	.borroNodos:
		mov qword r8,[r12 + OFFSET_first]
		cmp r8,NULL
		je .borreNodos
		mov rdi,r12
		call listRemoveFirst
		mov r12,rax
		jmp .borroNodos
	;elimino struct	
	.borreNodos:
		mov rdi,r12
		call free
	add rsp,8	
	pop r12	
	pop rbp		
	ret
	
; void listPrint(list_t* m, FILE *pFile);
listPrint:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15

	mov r12,rdi
	mov r13,rsi
	;imprimo corchete extremo izquierdo
	mov rdi,r13
	mov rsi,formatoString
	mov rdx,corcheteIzq
	call fprintf
	.imprimoElementos:
		mov qword r14,[r12 + OFFSET_first]              ; r14 <-- (list->first)
		cmp r14,NULL					
		je .termine										; lista vacia? entonces no imprimo nodos
		.ciclo:
			mov qword r15,[r14 + OFFSET_elem_data]      ; r15 <-- (nodo_actual->data)
			mov qword r8,[r15 + OFFSET_print]           ; r8  <-- (nodo_actual->print)
			.imprimoNodo:
				mov rdi,r15                             ; fprintf(nodo_actual->data,pFile)
				mov rsi,r13
				call r8                                 
				mov qword r14,[r14 + OFFSET_elem_next]  ; nodo_actual <-- (nodo_actual->next)
				cmp r14,NULL                            ; ultimo nodo ? 
				je .termine
				;nodo interno, imprimo ","                             
				mov rdi,r13                             
				mov rsi,formatoString
				mov rdx,coma
				call fprintf
				jmp .ciclo
	.termine:
		; imprimo corchete del extremo derecho de la lista
		mov rdi,r13
		mov rsi,formatoString
		mov rdx,corcheteDer
		call fprintf

	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
;########### Funciones: String

; string_t* strNew();
strNew:
	push rbp ;pila alineada
	mov rbp, rsp
	;reservo memoria para crear string
	mov rdi, tam_string
	call malloc

	;inicializo miembros del struct
	mov dword [rax + OFFSET_dataType], STRING
	mov qword [rax + OFFSET_remove], strDelete
	mov qword [rax + OFFSET_print], strPrint
	mov qword [rax + OFFSET_data], NULL

	pop rbp
	ret
	
; string_t* strSet(string_t* s, char* c);
strSet:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	mov r12, rdi
	mov r13,rsi

	mov qword rdi, [rdi + OFFSET_data]      ; me fijo si string->data tenia un dato ya
	cmp rdi, NULL                           
	je .creoString
	call free                               ; borro dato viejo

	.creoString:
		mov rdi, r13						; rdi <-- dato nuevo
		call str_copy                       ; rax <-- copia(dato nuevo)
		mov qword [r12 + OFFSET_data], rax  ; (string->data) <-- copia(dato nuevo)

	mov rax, r12	 
	pop r13
	pop r12
	pop rbp
	ret

; string_t* strAddRight(string_t* s, string_t* d);
strAddRight:
	push rbp
	mov rbp, rsp
	xor rdx,rdx
	mov rdx, 0
	call strConcatAux
	pop rbp	
	ret
	
; string_t* strAddLeft(string_t* s, string_t* d);
strAddLeft:
	push rbp
	mov rbp, rsp
	xor rdx,rdx
	mov rdx, 1
	call strConcatAux
	pop rbp	
	ret
	
; string_t* strRemove(string_t* s);
strRemove:
	push rbp
	mov rbp,rsp
	push r12
	sub rsp, 8

	mov r12, rdi
	mov qword rdi,[rdi + OFFSET_data]
	call free

	mov qword [r12 + OFFSET_data], NULL
	mov rax, r12
	add rsp, 8
	pop r12
	pop rbp
	ret
	
; void strDelete(string_t* s);
strDelete:
	push rbp
	mov rbp, rsp
	push r12
	sub rsp, 8

	
	mov r12, rdi
	;libero memoria pedida para los miembros del struct que son punteros y luego la ocupada por el struct en si mismo
	mov qword rdi, [r12 + OFFSET_data]
	call free
	mov rdi, r12
	call free

	add rsp, 8
	pop r12
	pop rbp
	ret
	ret
	
; int32_t strCmp(string_t* a, string_t* b);
strCmp:
	push rbp
	mov rbp,rsp
	mov qword rdi, [rdi + OFFSET_data] ;rdi <-- (a->data)
	mov qword rsi, [rsi + OFFSET_data] ;rsi <-- (b->data)
	call str_cmp
	pop rbp
	ret
	
; void strPrint(string_t* m, FILE *pFile);
strPrint:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	xor rdx,rdx
	mov r12,rdi 					   ; uso de auxiliar r12 para swappear rdi con rsi
	mov rdi,rsi 					   ; rdi <-- puntero al file
	mov qword r13, [r12 + OFFSET_data] ; r13 <-- (m->data)
	cmp r13,NULL
	je .imprimoNull
	
	mov  rdx,r13 			  ; rdx <-- m->data
	jmp .asignoFormato

	.imprimoNull:
		mov dword edx,msgNULL ; rdx <-- NULL
	.asignoFormato:
		mov rsi,formatoString
		mov rax,0
		call fprintf

	pop r13	
	pop r12
	pop rbp
	ret	
	
;########### Funciones: Entero

; integer_t* intNew();
intNew:
	push rbp ;pila alineada
	mov rbp, rsp

	;reservo memoria para crear entero
	mov rdi, tam_entero
	call malloc

	;inicializo miembros del struct
	mov dword [rax + OFFSET_dataType], INTEGER
	mov qword [rax + OFFSET_remove], intDelete
	mov qword [rax + OFFSET_print], intPrint
	mov qword [rax + OFFSET_data], NULL

	pop rbp
	ret
	
; integer_t* intSet(integer_t* i, int d);
intSet:
	push rbp 				
	mov rbp, rsp
	push r12
	push r13
	push r14
	sub rsp, 8

	mov r12, rdi 				 		; r12 <-- puntero al struct entero
	mov r13, rsi 				 		; r13 <-- valor d

	mov r14, [r12 + OFFSET_data] 		; r14 <-- (i->data)
	cmp r14, NULL 				 		; me fijo si (i->data) es puntero a null, en ese caso debo pedir 4 bytes de memo
	jne .asignoValor

	mov rdi, 4
	call malloc
	mov r14,rax
	mov qword [r12 + OFFSET_data], rax 	; (i->data) <-- puntero a memoria reservada para el int
    .asignoValor:    
	mov dword [r14], r13d 				; (i->data) <-- d

	mov rax, r12
	add rsp, 8
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
	
; integer_t* intRemove(integer_t* i);
intRemove:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	
	mov r12, rdi 						; r12 <-- puntero a integer_t para devolverlo en rax despues de llamar a free
	mov qword rdi, [rdi + OFFSET_data]  ; r13 <-- (integer_t->data)
	call free

	mov qword [r12 + OFFSET_data], NULL ; (integer_t->data) <-- NULL
	mov rax,r12
	pop r13
	pop r12
	pop rbp
	ret
	
; void intDelete(integer_t* i);
intDelete:
	push rbp
	mov rbp, rsp
	push r12
	sub rsp, 8

	
	mov r12, rdi
	;libero memoria pedida para los miembros del struct que son punteros y luego la ocupada por el struct en si mismo
	mov qword rdi, [r12 + OFFSET_data]
	call free
	mov rdi, r12
	call free

	add rsp, 8
	pop r12
	pop rbp
	ret
	
; int32_t intCmp(integer_t* a, integer_t* b);
intCmp:
	push rbp
	mov rbp, rsp
	push r12
	push r13

	mov qword r12, [rdi + OFFSET_data]
	mov dword r12d, [r12] 				; r12d <-- *(a->data)
	
	mov qword r13, [rsi + OFFSET_data]
	mov dword r13d, [r13] 				; r13d <-- *(b->data)

	mov rax, 0                          
	cmp dword r12d, r13d
	jg .mayor
	jl .menor
	jmp .fin

	.mayor:
		mov rax, -1
		jmp .fin

	.menor:
		mov rax, 1

	.fin:
	pop r13
	pop r12
	pop rbp

	ret
	
; void intPrint(integer_t* m, FILE *pFile);
intPrint:
	push rbp
	mov rbp,rsp
	push r12
	push r13
	xor rdx,rdx
	mov r12,rdi 						; uso de auxiliar r12 para swappear rdi con rsi
	mov rdi,rsi 						; rdi <-- puntero al file
	mov qword r13,[r12 + OFFSET_data]  	; r13 <-- (m->data)
	cmp r13,NULL
	je .imprimoNull
	mov rsi,formatoInt 					; rsi <-- formato entero para imprimir (%d)
	mov dword edx, [r13] 				; edx <-- *(m->data)
	jmp .asigneFormato

	.imprimoNull:
		mov rsi,formatoString 			; rsi <-- formato string para imprimir (%s)
		mov dword edx,msgNULL 			; rdx <-- NULL
	.asigneFormato:
		mov rax,0
		call fprintf

	pop r13	
	pop r12
	pop rbp
	ret	