    .text
    .globl make_node
    .globl insert
    .globl get
    .globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)        # save val

    li a0, 24           # size
    call malloc

    ld t0, 0(sp)        # val
    sw t0, 0(a0)        # node->val = val

    sd zero, 8(a0)      # left = NULL
    sd zero, 16(a0)     # right = NULL

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

insert:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)        # save root

    beqz a0, insert_create

    lw t0, 0(a0)        # root->val
    blt a1, t0, go_left

# go right
go_right:
    ld t1, 16(a0)       # root->right
    mv a0, t1
    call insert
    ld t2, 0(sp)
    sd a0, 16(t2)
    mv a0, t2
    j insert_end

# go left
go_left:
    ld t1, 8(a0)        # root->left
    mv a0, t1
    call insert
    ld t2, 0(sp)
    sd a0, 8(t2)
    mv a0, t2
    j insert_end

# create node
insert_create:
    mv a0, a1
    call make_node

insert_end:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

get:
loop_get:
    beqz a0, not_found

    lw t0, 0(a0)
    beq t0, a1, found

    blt a1, t0, go_left_get

    ld a0, 16(a0)
    j loop_get

go_left_get:
    ld a0, 8(a0)
    j loop_get

found:
    ret

not_found:
    li a0, 0
    ret

getAtMost:
    li t2, -1           # ans = -1

loop_gam:
    beqz a1, end_gam

    lw t0, 0(a1)

    beq t0, a0, exact_match

    blt t0, a0, update_ans

    ld a1, 8(a1)
    j loop_gam

update_ans:
    mv t2, t0
    ld a1, 16(a1)
    j loop_gam

exact_match:
    mv a0, t0
    ret

end_gam:
    mv a0, t2
    ret