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

function isempty(bt::BinaryTree{T}) where T

    return bt.root === nothing

end

#length()

length(tree::BinaryTree{T}) where T = tree.size


#clear()

function clear!(tree::BinaryTree{T}) where T
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

function insert_root(tree::BinarySearchTree{T}, treeHead::Union{NodeBST{T},Nothing}, key::T) where T
    if treeHead === nothing
        tree.size += 1
        return NodeBST{T}(key, nothing, nothing)
    end
    
    if key < treeHead.elem
        treeHead.left = insertW(tree, treeHead.left, key)
    elseif key > treeHead.elem
        treeHead.right = insertW(tree, treeHead.right, key)
    end    
    return treeHead
end

function search_non_head(treeHead::Union{NodeBST{T}, Nothing}, key::T) where T
    if treeHead === nothing
        return false
    end

    if key < treeHead.elem
        return search(tree, treeHead.left, key)
    elseif key > treeHead.elem
        return search(tree, treeHead.right, key)
    else
        return true
    end
end

function search(tree::BinarySearchTree{T}, key::T) where T #wrapper
    return search_non_head(tree.root, key)
end




function Base.insert!(tree::BinarySearchTree{T}, key::T) where T
    tree.root = insert_root(tree, tree.root, key)
    return tree
end

function main()
    bt = BinarySearchTree{Int}([1,2,3,4,56,7,8,9,200,123])
    print_tree_vertical(bt)
    print(isempty(bt))  
end

main()