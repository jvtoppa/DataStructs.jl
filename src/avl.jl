module Avl

export AVLNode, AVLTree, avl_insert!, avl_delete!, avl_search, avl_inorder, avl_preorder,
       avl_postorder, avl_min, avl_max, avl_height, avl_isbalanced

mutable struct AVLNode{T}
    key::T
    left::Union{AVLNode{T}, Nothing}
    right::Union{AVLNode{T}, Nothing}
    height::Int
end

AVLNode(key::T) where T = AVLNode{T}(key, nothing, nothing, 1)

mutable struct AVLTree{T}
    root::Union{AVLNode{T}, Nothing}
end

AVLTree{T}() where T = AVLTree{T}(nothing)
AVLTree() = AVLTree{Any}(nothing)

# Helpers
height(n) = n === nothing ? 0 : n.height
_update_height!(n::AVLNode) = (n.height = 1 + max(height(n.left), height(n.right)))
balance_factor(n) = n === nothing ? 0 : height(n.left) - height(n.right)

# Rotations
function right_rotate(y::AVLNode{T}) where T
    x = y.left
    T2 = x.right

    x.right = y
    y.left = T2

    _update_height!(y)
    _update_height!(x)

    return x
end

function left_rotate(x::AVLNode{T}) where T
    y = x.right
    T2 = y.left

    y.left = x
    x.right = T2

    _update_height!(x)
    _update_height!(y)

    return y
end

# Insertion (recursive)
function _insert_node(n::Union{AVLNode{T}, Nothing}, key::T) where T
    if n === nothing
        return AVLNode(key)
    end

    if key < n.key
        n.left = _insert_node(n.left, key)
    elseif key > n.key
        n.right = _insert_node(n.right, key)
    else
        # duplicate keys are ignored (no-op)
        return n
    end

    _update_height!(n)
    bf = balance_factor(n)

    # Left Left
    if bf > 1 && key < n.left.key
        return right_rotate(n)
    end
    # Right Right
    if bf < -1 && key > n.right.key
        return left_rotate(n)
    end
    # Left Right
    if bf > 1 && key > n.left.key
        n.left = left_rotate(n.left)
        return right_rotate(n)
    end
    # Right Left
    if bf < -1 && key < n.right.key
        n.right = right_rotate(n.right)
        return left_rotate(n)
    end

    return n
end

function avl_insert!(t::AVLTree{T}, key::T) where T
    t.root = _insert_node(t.root, key)
    return t
end

# Find minimum node in subtree
function _min_node(n::AVLNode{T}) where T
    while n.left !== nothing
        n = n.left
    end
    return n
end

# Deletion (recursive)
function _delete_node(n::Union{AVLNode{T}, Nothing}, key::T) where T
    if n === nothing
        return nothing
    end

    if key < n.key
        n.left = _delete_node(n.left, key)
    elseif key > n.key
        n.right = _delete_node(n.right, key)
    else
        # node to be deleted
        if n.left === nothing || n.right === nothing
            tmp = (n.left === nothing) ? n.right : n.left
            if tmp === nothing
                return nothing
            else
                n = tmp
            end
        else
            succ = _min_node(n.right)
            n.key = succ.key
            n.right = _delete_node(n.right, succ.key)
        end
    end

    if n === nothing
        return nothing
    end

    _update_height!(n)
    bf = balance_factor(n)

    # Left Left
    if bf > 1 && balance_factor(n.left) >= 0
        return right_rotate(n)
    end
    # Left Right
    if bf > 1 && balance_factor(n.left) < 0
        n.left = left_rotate(n.left)
        return right_rotate(n)
    end
    # Right Right
    if bf < -1 && balance_factor(n.right) <= 0
        return left_rotate(n)
    end
    # Right Left
    if bf < -1 && balance_factor(n.right) > 0
        n.right = right_rotate(n.right)
        return left_rotate(n)
    end

    return n
end

function avl_delete!(t::AVLTree{T}, key::T) where T
    t.root = _delete_node(t.root, key)
    return t
end

# Search
function _avl_search(n::Union{AVLNode{T}, Nothing}, key::T) where T
    if n === nothing
        return nothing
    end
    if key == n.key
        return n
    elseif key < n.key
        return _avl_search(n.left, key)
    else
        return _avl_search(n.right, key)
    end
end

function avl_search(t::AVLTree{T}, key::T) where T
    return _avl_search(t.root, key)
end

# Traversals returning Vector{T}
function _inorder(n::Union{AVLNode{T}, Nothing}, res::Vector{T}) where T
    if n === nothing
        return
    end
    _inorder(n.left, res)
    push!(res, n.key)
    _inorder(n.right, res)
end

function avl_inorder(t::AVLTree{T}) where T
    res = Vector{T}()
    _inorder(t.root, res)
    return res
end

function _preorder(n::Union{AVLNode{T}, Nothing}, res::Vector{T}) where T
    if n === nothing
        return
    end
    push!(res, n.key)
    _preorder(n.left, res)
    _preorder(n.right, res)
end

function avl_preorder(t::AVLTree{T}) where T
    res = Vector{T}()
    _preorder(t.root, res)
    return res
end

function _postorder(n::Union{AVLNode{T}, Nothing}, res::Vector{T}) where T
    if n === nothing
        return
    end
    _postorder(n.left, res)
    _postorder(n.right, res)
    push!(res, n.key)
end

function avl_postorder(t::AVLTree{T}) where T
    res = Vector{T}()
    _postorder(t.root, res)
    return res
end

# Min / Max keys
function avl_min(t::AVLTree{T}) where T
    if t.root === nothing
        return nothing
    end
    return _min_node(t.root).key
end

function avl_max(t::AVLTree{T}) where T
    if t.root === nothing
        return nothing
    end
    node = t.root
    while node.right !== nothing
        node = node.right
    end
    return node.key
end

# Height of tree
function avl_height(t::AVLTree)
    return height(t.root)
end

# Validate AVL property for every node
function _is_balanced_node(n::Union{AVLNode, Nothing})
    if n === nothing
        return true
    end
    bf = balance_factor(n)
    return abs(bf) <= 1 && _is_balanced_node(n.left) && _is_balanced_node(n.right)
end

function avl_isbalanced(t::AVLTree)
    return _is_balanced_node(t.root)
end

end # module Avl
