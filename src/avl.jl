module Avl

export AVLNode, AVLTree, avl_insert!, avl_delete!, avl_search, avl_inorder, avl_preorder, avl_postorder, avl_min, avl_max, avl_height, avl_isbalanced

import ..Containers: Stack, push!, pop!, isempty

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

"""
    avl_insert!(t::AVLTree{T}, key::T)
Insert the element `key` into the AVL tree `t`. If the key already exists, the operation is a no-op.
"""
function avl_insert!(t::AVLTree{T}, key::T) where T
    t.root = _insert_node(t.root, key)
    return t
end

"""
    avl_delete!(t::AVLTree{T}, key::T)
Remove the element `key` from the AVL tree `t`.
"""
function avl_delete!(t::AVLTree{T}, key::T) where T
    t.root = _delete_node(t.root, key)
    return t
end

"""
    avl_search(t::AVLTree{T}, key::T)
Search for the element `key` in the AVL tree `t`. Returns the node or `nothing`.
"""
function avl_search(t::AVLTree{T}, key::T) where T
    return _search_node(t.root, key)
end

"""
    avl_inorder(t::AVLTree{T})
Returns a vector with the elements in order (inorder) using a stack.
"""
function avl_inorder(t::AVLTree{T}) where T
    res = Vector{T}()
    stack = Stack{AVLNode{T}}()
    curr = t.root
    while curr !== nothing || !isempty(stack)
        while curr !== nothing
            push!(stack, curr)
            curr = curr.left
        end
        curr = pop!(stack)
        push!(res, curr.key)
        curr = curr.right
    end
    return res
end

"""
    avl_preorder(t::AVLTree{T})
Returns a vector with the elements in pre-order (preorder) using a stack.
"""
function avl_preorder(t::AVLTree{T}) where T
    res = Vector{T}()
    stack = Stack{AVLNode{T}}()
    curr = t.root
    if curr !== nothing
        push!(stack, curr)
    end
    while !isempty(stack)
        curr = pop!(stack)
        push!(res, curr.key)
        if curr.right !== nothing
            push!(stack, curr.right)
        end
        if curr.left !== nothing
            push!(stack, curr.left)
        end
    end
    return res
end

"""
    avl_postorder(t::AVLTree{T})
Returns a vector with the elements in post-order (postorder) using a stack.
"""
function avl_postorder(t::AVLTree{T}) where T
    res = Vector{T}()
    stack = Stack{AVLNode{T}}()
    last_visited = nothing
    curr = t.root
    while curr !== nothing || !isempty(stack)
        if curr !== nothing
            push!(stack, curr)
            curr = curr.left
        else
            peek_node = stack.vec[stack.first]
            if peek_node.right !== nothing && last_visited !== peek_node.right
                curr = peek_node.right
            else
                curr = pop!(stack)
                push!(res, curr.key)
                last_visited = curr
                curr = nothing
            end
        end
    end
    return res
end

"""
    avl_min(t::AVLTree{T})
Returns the minimum element of the AVL tree `t`.
"""
function avl_min(t::AVLTree{T}) where T
    if t.root === nothing
        return nothing
    end
    return _min_node(t.root).key
end

"""
    avl_max(t::AVLTree{T})
Returns the maximum element of the AVL tree `t`.
"""
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

"""
    avl_height(t::AVLTree)
Returns the height of the AVL tree `t`.
"""
function avl_height(t::AVLTree)
    return _height(t.root)
end

"""
    avl_isbalanced(t::AVLTree)
Returns `true` if the AVL tree `t` is balanced.
"""
function avl_isbalanced(t::AVLTree)
    return _is_balanced_node(t.root)
end

# Private helpers
_height(n) = n === nothing ? 0 : n.height
_update_height!(n::AVLNode) = (n.height = 1 + max(_height(n.left), _height(n.right)))
_balance_factor(n) = n === nothing ? 0 : _height(n.left) - _height(n.right)

function _right_rotate(y::AVLNode{T}) where T
    x = y.left
    T2 = x.right
    x.right = y
    y.left = T2
    _update_height!(y)
    _update_height!(x)
    return x
end

function _left_rotate(x::AVLNode{T}) where T
    y = x.right
    T2 = y.left
    y.left = x
    x.right = T2
    _update_height!(x)
    _update_height!(y)
    return y
end

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
    bf = _balance_factor(n)
    if bf > 1 && key < n.left.key
        return _right_rotate(n)
    end
    if bf < -1 && key > n.right.key
        return _left_rotate(n)
    end
    if bf > 1 && key > n.left.key
        n.left = _left_rotate(n.left)
        return _right_rotate(n)
    end
    if bf < -1 && key < n.right.key
        n.right = _right_rotate(n.right)
        return _left_rotate(n)
    end
    return n
end

function _min_node(n::AVLNode{T}) where T
    while n.left !== nothing
        n = n.left
    end
    return n
end

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
    bf = _balance_factor(n)
    if bf > 1 && _balance_factor(n.left) >= 0
        return _right_rotate(n)
    end
    if bf > 1 && _balance_factor(n.left) < 0
        n.left = _left_rotate(n.left)
        return _right_rotate(n)
    end
    if bf < -1 && _balance_factor(n.right) <= 0
        return _left_rotate(n)
    end
    if bf < -1 && _balance_factor(n.right) > 0
        n.right = _right_rotate(n.right)
        return _left_rotate(n)
    end
    return n
end

function _search_node(n::Union{AVLNode{T}, Nothing}, key::T) where T
    if n === nothing
        return nothing
    end
    if key == n.key
        return n
    elseif key < n.key
        return _search_node(n.left, key)
    else
        return _search_node(n.right, key)
    end
end

function _is_balanced_node(n::Union{AVLNode, Nothing})
    if n === nothing
        return true
    end
    bf = _balance_factor(n)
    return abs(bf) <= 1 && _is_balanced_node(n.left) && _is_balanced_node(n.right)
end

end # module Avl
