.section .bss
.align 3
arr: .space 8000
res: .space 8000
stk: .space 8000
buf: .space 32

.section .text
.globl _start
.extern atoi

_start:
    mv s0, a0
    mv s1, a1

    addi s0, s0, -1
    blez s0, exit

    li s2, 0

parse:
    bge s2, s0, process

    addi t0, s2, 1
    slli t0, t0, 3
    add t0, s1, t0
    ld a0, 0(t0)

    call atoi

    slli t1, s2, 3
    la t2, arr
    add t2, t2, t1
    sd a0, 0(t2)

    addi s2, s2, 1
    j parse

process:
    li t6, -1
    addi t0, s0, -1

outer:
    blt t0, zero, print

while:
    blt t6, zero, after

    slli t1, t6, 3
    la t2, stk
    add t2, t2, t1
    ld t3, 0(t2)

    slli t1, t3, 3
    la t2, arr
    add t2, t2, t1
    ld t4, 0(t2)

    slli t1, t0, 3
    la t2, arr
    add t2, t2, t1
    ld t5, 0(t2)

    bgt t4, t5, after

    addi t6, t6, -1
    j while

after:
    slli t1, t0, 3
    la t2, res
    add t2, t2, t1

    blt t6, zero, setm1

    slli t1, t6, 3
    la t3, stk
    add t3, t3, t1
    ld t4, 0(t3)
    sd t4, 0(t2)
    j push

setm1:
    li t3, -1
    sd t3, 0(t2)

push:
    addi t6, t6, 1
    slli t1, t6, 3
    la t2, stk
    add t2, t2, t1
    sd t0, 0(t2)

    addi t0, t0, -1
    j outer

print:
    li s2, 0

print_loop:
    bge s2, s0, newline

    slli t0, s2, 3
    la t1, res
    add t1, t1, t0
    ld a0, 0(t1)

    jal ra, print_num

    li a7, 64
    li a0, 1
    la a1, space
    li a2, 1
    ecall

    addi s2, s2, 1
    j print_loop

newline:
    li a7, 64
    li a0, 1
    la a1, nl
    li a2, 1
    ecall

exit:
    li a7, 93
    li a0, 0
    ecall

print_num:
    la t0, buf
    addi t1, t0, 31
    sb zero, 0(t1)

    beqz a0, zero_case

    li t2, 10

loop_num:
    rem t3, a0, t2
    addi t3, t3, 48
    addi t1, t1, -1
    sb t3, 0(t1)

    div a0, a0, t2
    bnez a0, loop_num
    j write_num

zero_case:
    li t3, 48
    addi t1, t1, -1
    sb t3, 0(t1)

write_num:
    li a7, 64
    li a0, 1
    mv a1, t1
    la t4, buf
    addi t4, t4, 31
    sub a2, t4, t1
    ecall
    ret

.section .rodata
space: .asciz " "
nl: .asciz "\n"