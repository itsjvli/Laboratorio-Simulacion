.data
    msg_prompt1: .asciiz "Ingrese el numero de valores a comparar (3-5): "
    msg_prompt2: .asciiz "Ingrese el numero: "
    msg_result:  .asciiz "El numero mayor es: "
    msg_error:   .asciiz "Numero invalido. Debe estar entre 3 y 5."
    msg_error_input: .asciiz "Entrada invalida. Por favor ingrese un numero entero."
    num_array:   .space 20  
    buffer:      .space 4   # Espacio para el input del usuario

.text
    main:
        # Imprimir mensaje para número de valores
        li $v0, 4
        la $a0, msg_prompt1
        syscall
        
        # Leer número de valores
        li $v0, 5
        syscall
        move $t0, $v0        # $t0 = número de valores
        
        # Validar que esté entre 3 y 5
        li $t1, 3
        li $t2, 5
        blt $t0, $t1, error
        bgt $t0, $t2, error
        
        # Leer los números
        li $t3, 0            # Contador de números
        la $t4, num_array    # Dirección base del arreglo
        
    read_loop:
        # Imprimir mensaje para número
        li $v0, 4
        la $a0, msg_prompt2
        syscall
        
        # Leer número
        li $v0, 5
        syscall
        move $t5, $v0        # Guardar el número leído en $t5
        
        # Verificar si la entrada es válida
        bltz $t5, error_input
        sw $t5, 0($t4)       # Guardar número en el arreglo
        addi $t4, $t4, 4     # Mover a la siguiente posición
        addi $t3, $t3, 1     # Incrementar contador
        
        # Verificar si hemos leído todos los números
        bne $t3, $t0, read_loop
        
        # Encontrar el número mayor
        la $t4, num_array    # Volver a la dirección base del arreglo
        lw $t5, 0($t4)       # Inicializar el máximo con el primer número
        addi $t4, $t4, 4     # Mover a la siguiente posición
        li $t6, 1            # Índice para comparar el resto de los números
        
    find_max:
        lw $t7, 0($t4)       # Cargar el siguiente número
        bge $t5, $t7, skip   # Si $t5 (máximo) es mayor o igual, saltar
        move $t5, $t7        # Actualizar máximo
    skip:
        addi $t4, $t4, 4     # Mover a la siguiente posición
        addi $t6, $t6, 1     # Incrementar índice
        blt $t6, $t0, find_max
        
        # Mostrar el número mayor
        li $v0, 4
        la $a0, msg_result
        syscall
        
        li $v0, 1
        move $a0, $t5        # Mostrar el número mayor
        syscall
        
        # Salir del programa
        li $v0, 10
        syscall
        
    error:
        # Imprimir mensaje de error
        li $v0, 4
        la $a0, msg_error
        syscall
        
        # Salir del programa
        li $v0, 10
        syscall
    
    error_input:
        # Imprimir mensaje de entrada inválida
        li $v0, 4
        la $a0, msg_error_input
        syscall
        
        # Volver al inicio del programa (opcional, para reintentar)
        j main
