#insert()
#remove()
abstract type BinaryTreeNode{T} end

abstract type BinaryTree{T} end


mutable struct NodeBST{T} <: BinaryTreeNode{T}

    elem::T
    left::Union{NodeBST{T}, Nothing}
    right::Union{NodeBST{T}, Nothing}

end

mutable struct BinarySearchTree{T} <: BinaryTree{T}

    root::Union{NodeBST{T}, Nothing}
    size::Int

end


#Constructor
BinarySearchTree{T}() where T = BinarySearchTree{T}(nothing, 0)
BinarySearchTree() = BinarySearchTree{Any}(nothing, 0)
BinarySearchTree{T}(v::Vector{T}) where T = begin 
    
    bt = BinarySearchTree{T}()
    
    for vElem in v
        insert!(bt, vElem)
    end
    return bt
end

function Base.isempty(bt::BinaryTree{T}) where T

    return bt.root === nothing

end

#length()

Base.length(tree::BinaryTree{T}) where T = tree.size


#clear()

function Base.empty!(tree::BinaryTree{T}) where T
    tree.root = nothing
    tree.size = 0
end

#insert!()



function print_tree_vertical(tree::BinarySearchTree{T}; level::Int=0) where T
    println("Binary Search Tree (vertical view):")
    
    function print_node_vertical(node::Union{NodeBST{T}, Nothing}, prefix::String="", is_left::Bool=true)
        if node !== nothing
            print_node_vertical(node.right, prefix * (is_left ? "│   " : "    "), false)
            
            println(prefix, is_left ? "└── " : "┌── ", node.elem)
            
            print_node_vertical(node.left, prefix * (is_left ? "    " : "│   "), true)
        end
    end
    
    if tree.root === nothing
        println("(empty tree)")
    else
        print_node_vertical(tree.root)
    end
end

function _insert!(tree::BinarySearchTree{T}, treeHead::Union{NodeBST{T},Nothing}, key::T) where T
    if treeHead === nothing
        tree.size += 1
        return NodeBST{T}(key, nothing, nothing)
    end
    
    if key < treeHead.elem
        treeHead.left = _insert!(tree, treeHead.left, key)
    elseif key > treeHead.elem
        treeHead.right = _insert!(tree, treeHead.right, key)
    end    
    return treeHead
end

function _search(treeHead::Union{NodeBST{T}, Nothing}, key::T) where T
    if treeHead === nothing
        return false
    end

    if key < treeHead.elem
        return _search(treeHead.left, key)
    elseif key > treeHead.elem
        return _search(treeHead.right, key)
    else
        return true
    end
end

function search(tree::BinarySearchTree{T}, key::T) where T #wrapper
    return _search(tree.root, key)
end

Base.in(key, tree::BinarySearchTree) = search(tree, key)

function leftmostnode(node::Union{NodeBST{T}, Nothing}) where T
    while node.left !== nothing
        node = node.left
    end
    return node
end

function _successor(node::Union{NodeBST{T}, Nothing}, target::T) where T
    curr = node
    succ = nothing

    while curr !== nothing
        if target < curr.elem
            succ = curr
            curr = curr.left
        else
            curr = curr.right
        end
    end
    return succ
end

function successor(tree::Union{BinarySearchTree{T}, Nothing}, target::T) where T
    node = _successor(tree.root, target)
    return node === nothing ? nothing : node.elemend
end

function Base.insert!(tree::BinarySearchTree{T}, key::T) where T
    tree.root = _insert!(tree, tree.root, key)
    return tree
end

function main()
    bt = BinarySearchTree{Int}([1,2,3,4,56,7,8,9,200,123,4])
    print_tree_vertical(bt)
    print(isempty(bt))
    print(successor(bt, 56))  
end

main()