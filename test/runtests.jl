using DataStructs
using Test

@testset "DataStructs.jl" begin
    # AVLTree tests
    t = AVLTree{Int}()
    avl_insert!(t, 10)
    avl_insert!(t, 20)
    avl_insert!(t, 30)
    avl_insert!(t, 40)
    avl_insert!(t, 50)
    avl_insert!(t, 25)

    @test avl_inorder(t) == [10, 20, 25, 30, 40, 50]
    @test avl_preorder(t)[1] == 30  # root should be 30 after balancing
    @test avl_postorder(t)[end] == 30
    @test avl_min(t) == 10
    @test avl_max(t) == 50
    @test avl_height(t) <= 3
    @test avl_isbalanced(t)

    n = avl_search(t, 25)
    @test n !== nothing && n.key == 25

    avl_delete!(t, 40)
    @test avl_inorder(t) == [10, 20, 25, 30, 50]
    @test avl_isbalanced(t)

    avl_delete!(t, 10)
    avl_delete!(t, 20)
    avl_delete!(t, 25)
    avl_delete!(t, 30)
    avl_delete!(t, 50)
    @test avl_inorder(t) == []
    @test avl_isbalanced(t)
end
