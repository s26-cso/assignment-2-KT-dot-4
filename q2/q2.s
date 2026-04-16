.section .rodata
fmt_int:    .asciz "%ld "
fmt_end:    .asciz "\n"

.section .bss
.align 3
arr:    .space 8000
res:    .space 8000
stack:  .space 8000

.section .text
.globl main
.extern atoi
.extern printf

main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0          # argc
    mv s1, a1          # argv

    addi s0, s0, -1    # n
    blez s0, done

    li s2, 0           # i = 0

parse_loop:
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
    j parse_loop

process:
    li t6, -1          # top = -1
    addi t0, s0, -1    # i = n-1

outer_loop:
    blt t0, zero, print

while_loop:
    blt t6, zero, after_while

    slli t1, t6, 3
    la t2, stack
    add t2, t2, t1
    ld t3, 0(t2)

    slli t4, t3, 3
    la t5, arr
    add t5, t5, t4
    ld t4, 0(t5)

    slli t1, t0, 3
    la t2, arr
    add t2, t2, t1
    ld t5, 0(t2)

    bgt t4, t5, after_while

    addi t6, t6, -1
    j while_loop

after_while:
    slli t1, t0, 3
    la t2, res
    add t2, t2, t1

    blt t6, zero, set_minus1

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
    sd t0, 0(t2)

    addi t0, t0, -1
    j outer_loop
print:
    li s2, 0

print_loop:
    bge s2, s0, print_end

    slli t0, s2, 3
    la t1, res
    add t1, t1, t0
    ld a1, 0(t1)

    la a0, fmt_int
    call printf

    addi s2, s2, 1
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