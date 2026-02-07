module Containers
#Structs
export Stack, Queue,  push!, pop!, isempty, peek

abstract type Container{T} end

mutable struct Stack{T} <: Container{T}
    vec::Vector{T}
    first::Int
    size::Int
end

mutable struct Queue{T} <: Container{T}
    vec::Vector{T}
    first::Int
    last::Int
    size::Int
    
end

#Constructors

Stack{T}() where T = Stack(T[], 0, 0)
Stack(T::Type) = Stack(T[], 0, 0)
Stack() = Stack(Any[], 0, 0)
Stack(v::Vector{T}) where T = Stack(v, length(v), length(v))

Queue(T::Type) = Queue(T[], 0, 0, 0)
Queue{T}() where T = Queue(T[], 0, 0, 0)
Queue() = Queue(Any[], 0, 0, 0)
Queue(v::Vector{T}) where T = Queue(v, length(v), 0, length(v))

#Operations:

TopIdx(cont::Container) = cont.first
BottomIdx(q::Queue) = q.last

#size()

Base.size(cont::Container) = cont.size

#isempty()

Base.isempty(cont::Container) = cont.first == 0

#peek()

function peek(cont::Container)
    if isempty(cont)
        error("Container is Empty.")
    else
        return cont.vec[TopIdx(cont)]
    end
    return nothing
end

#push()

function Base.push!(cont::Container{T}, elem::T) where T
    if cont isa Stack
        push!(cont.vec, elem)
        cont.first += 1
        cont.size += 1
    elseif cont isa Queue
        pushfirst!(cont.vec, elem)
        if isempty(cont)
            cont.first = 0
            cont.last = 0
        end
        cont.size += 1
        cont.first += 1
    else
        error("Not pushable.\n")
    end
    return cont
end

#pop()

function Base.pop!(cont::Container{T}) where T
    
    if !isempty(cont)
        popped = pop!(cont.vec)
        cont.first -= 1
        cont.size -= 1
    else
        error("Container is Empty.\n")
    end
    return popped
end

end #module