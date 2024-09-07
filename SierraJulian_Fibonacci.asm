.data
    msg_prompt: .asciiz "Ingrese el numero de elementos en la serie Fibonacci: "
    msg_result: .asciiz "Serie Fibonacci: "
    msg_sum:    .asciiz "La suma de los numeros en la serie es: "
    msg_error:  .asciiz "Entrada invalida. Debe ingresar un numero entero positivo."
    buffer:     .space 4   # Espacio para el input del usuario

.text
    main:
        # Imprimir mensaje para número de elementos
        li $v0, 4
        la $a0, msg_prompt
        syscall
        
        # Leer número de elementos
        li $v0, 5
        syscall
        move $t0, $v0        # $t0 = número de elementos
        
        # Validar que sea un número positivo
        blez $t0, error
        
        # Inicializar variables para la serie de Fibonacci
        li $t1, 0            # Fibonacci[0] = 0
        li $t2, 1            # Fibonacci[1] = 1
        li $t3, 0            # Contador de números impresos
        li $t4, 0            # Suma de la serie
        li $t5, 0            # Índice de la serie
        li $t6, 1            # Índice de impresión para Fibonacci[1]
        
        # Imprimir mensaje de la serie Fibonacci
        li $v0, 4
        la $a0, msg_result
        syscall
        
    print_fibonacci:
        # Imprimir número Fibonacci
        li $v0, 1
        move $a0, $t1        # Mostrar el número Fibonacci
        syscall
        
        # Sumar el número actual a la suma total
        add $t4, $t4, $t1
        
        # Preparar el siguiente número Fibonacci
        move $a0, $t1
        move $t1, $t2
        add $t2, $a0, $t2   # Fibonacci[n] = Fibonacci[n-1] + Fibonacci[n-2]
        addi $t3, $t3, 1    # Incrementar contador
        
        # Imprimir coma y espacio si no es el último número
        bne $t3, $t0, print_comma
        
        # Imprimir nueva línea después del último número
        li $v0, 4
        la $a0, newline
        syscall
        j compute_sum
        
    print_comma:
        li $v0, 4
        la $a0, comma_space
        syscall
        j print_fibonacci
    
    compute_sum:
        # Imprimir mensaje de la suma
        li $v0, 4
        la $a0, msg_sum
        syscall
        
        # Imprimir la suma total
        li $v0, 1
        move $a0, $t4
        syscall
        
       
        li $v0, 10
        syscall
        
    error:
        # Imprimir mensaje de error
        li $v0, 4
        la $a0, msg_error
        syscall
        
        
        li $v0, 10
        syscall

    .data
        newline: .asciiz "\n"
        comma_space: .asciiz ", "
