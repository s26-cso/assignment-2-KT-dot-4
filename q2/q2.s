    .section .rodata
fmt_int:    .asciz "%ld "
fmt_end:    .asciz "\n"

    .section .bss
    .align 3
arr:    .space 8000      # input array (max ~1000 elements)
res:    .space 8000      # result
stack:  .space 8000      # stack (stores indices)

    .section .text
    .globl main
    .extern atoi
    .extern printf

main:
    # save registers
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0          # argc
    mv s1, a1          # argv

    addi s0, s0, -1    # n = argc - 1
    blez s0, done

    li t0, 0           # i = 0

parse_loop:
    bge t0, s0, process

    addi t1, t0, 1
    slli t1, t1, 3
    add t1, s1, t1     # &argv[i+1]
    ld a0, 0(t1)

    call atoi          # convert string → int

    slli t2, t0, 3
    la t3, arr
    add t3, t3, t2
    sd a0, 0(t3)       # arr[i] = value

    addi t0, t0, 1
    j parse_loop

process:
    li t6, -1          # top = -1
    addi t0, s0, -1    # i = n-1

outer_loop:
    blt t0, zero, print

while_loop:
    blt t6, zero, after_while

    # stack[top]
    slli t1, t6, 3
    la t2, stack
    add t2, t2, t1
    ld t3, 0(t2)       # index

    # arr[stack[top]]
    slli t4, t3, 3
    la t5, arr
    add t5, t5, t4
    ld t7, 0(t5)

    # arr[i]
    slli t8, t0, 3
    la t9, arr
    add t9, t9, t8
    ld t10, 0(t9)

    bgt t7, t10, after_while

    addi t6, t6, -1    # pop
    j while_loop

after_while:
    # res[i]
    slli t1, t0, 3
    la t2, res
    add t2, t2, t1

    blt t6, zero, set_minus1

    # res[i] = stack[top]
    slli t3, t6, 3
    la t4, stack
    add t4, t4, t3
    ld t5, 0(t4)
    sd t5, 0(t2)
    j push_stack

set_minus1:
    li t3, -1
    sd t3, 0(t2)

push_stack:
    addi t6, t6, 1
    slli t1, t6, 3
    la t2, stack
    add t2, t2, t1
    sd t0, 0(t2)       # push index i

    addi t0, t0, -1
    j outer_loop

print:
    li t0, 0

print_loop:
    bge t0, s0, print_end

    slli t1, t0, 3
    la t2, res
    add t2, t2, t1
    ld a1, 0(t2)

    la a0, fmt_int
    call printf

    addi t0, t0, 1
    j print_loop

print_end:
    la a0, fmt_end
    call printf

done:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    ld s2, 0(sp)
    addi sp, sp, 32
    ret