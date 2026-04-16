.section .data
filename: .asciz "input.txt"
yes_msg:  .asciz "Yes\n"
no_msg:   .asciz "No\n"

.section .bss
buf1: .space 1
buf2: .space 1

.section .text
.globl main

main:
    li a7, 56
    li a0, -100
    la a1, filename
    li a2, 0
    li a3, 0
    ecall

    mv s0, a0

    li a7, 62
    mv a0, s0
    li a1, 0
    li a2, 2
    ecall

    mv s1, a0

    beqz s1, is_palindrome

    li a7, 62
    mv a0, s0
    addi a1, s1, -1
    li a2, 0
    ecall

    li a7, 63
    mv a0, s0
    la a1, buf1
    li a2, 1
    ecall

    lbu t0, buf1
    li t1, 10

    bne t0, t1, no_newline
    addi s1, s1, -1

no_newline:
    ble s1, 1, is_palindrome

    li s2, 0
    addi s3, s1, -1

loop:
    bge s2, s3, is_palindrome

    li a7, 62
    mv a0, s0
    mv a1, s2
    li a2, 0
    ecall

    li a7, 63
    mv a0, s0
    la a1, buf1
    li a2, 1
    ecall

    li a7, 62
    mv a0, s0
    mv a1, s3
    li a2, 0
    ecall

    li a7, 63
    mv a0, s0
    la a1, buf2
    li a2, 1
    ecall

    lbu t0, buf1
    lbu t1, buf2

    bne t0, t1, not_palindrome

    addi s2, s2, 1
    addi s3, s3, -1
    j loop

is_palindrome:
    li a7, 64
    li a0, 1
    la a1, yes_msg
    li a2, 4
    ecall
    j exit

not_palindrome:
    li a7, 64
    li a0, 1
    la a1, no_msg
    li a2, 3
    ecall

exit:
    li a7, 57
    mv a0, s0
    ecall

    li a0, 0
    ret