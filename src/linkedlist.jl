mutable struct NodeLL{T}
    elem::T
    next::Union{NodeLL{T}, Nothing}
end

mutable struct LinkedList{T}
    last::Union{NodeLL{T}, Nothing}
    head::Union{NodeLL{T}, Nothing}
    size::Int
end
#Constructors 
LinkedList{T}() where T = LinkedList{T}(nothing, nothing, 0)
LinkedList() = LinkedList{Any}()
LinkedList{T}(elements::Vector{T}) where T = begin

    if isempty(elements)
        return LinkedList{T}(nothing, nothing, 0)
    end
    
    head = nothing
    last = nothing
    for elem in reverse(elements)
        head = NodeLL{T}(elem, head)
        if last === nothing
            last = head
        end
    end
    
    return LinkedList{T}(last, head, length(elements))
end

function InsertAnyNode(ll::LinkedList{T}, position::Int, amount::T) where T
    if position < 0
        error("Position cannot be negative.")
    end
    
    current = ll.head
    prev = nothing
    pos = 0
    
    while current !== nothing && pos < position
        prev = current
        current = current.next
        pos += 1
    end
    
    if pos < position
        error("Position is beyond list length.")
    end
    
    new_node = NodeLL{T}(amount, current)
    
    if prev !== nothing
        prev.next = new_node
    else
        ll.head = new_node
    end
    
    if current === nothing
        ll.last = new_node
    end
    ll.size += 1
    return ll
end

function RemoveNode(ll, pos)
    if pos < 0
        error("Position cannot be negative.")
    end
    
    current = ll.head
    prev = nothing
    position = 0
    
    while current !== nothing && position < pos
        prev = current
        current = current.next
        position += 1
    end
    
    if current === nothing
        error("Position not found.")
    end
    
    if prev === nothing
        ll.head = current.next
        if ll.head === nothing
            ll.last = nothing
        end
    else
        prev.next = current.next
        if current.next === nothing
            ll.last = prev
        end
    end
    ll.size -= 1
    return ll
end



function FindElement(ll::LinkedList{T}, n::T) where T
    current = ll.head
    while current !== nothing
        if current.elem == n
            return current
        end
        current = current.next
    end
    return nothing
end

function Base.show(io::IO, ll::LinkedList{T}) where T
    iterator = ll.head
    print(io, "(")
    while iterator !== nothing
        print(iterator.elem)
        if iterator.next !== nothing
            print(io, ", ")
        else
            print(io, ")")
        end
        iterator = iterator.next
    end

end
