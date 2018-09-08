module Futures
using DataStructures
import Base:schedule
export Executor, schedule

function worker(fromboss::Channel{Task}, toboss::Channel)
    while true
        if isready(fromboss)
            t = take!(fromboss)
            schedule(t)
            put!(toboss, fetch(t))
        else
            sleep(0.1)
        end
    end
end

struct Executor
    toworker::Channel{Task}
    fromworker::Channel
end

function Executor()
    c1 = Channel{Task}(100)
    c2 = Channel(100)
    @async worker(c1, c2)
    Executor(c1, c2)
end

function schedule(e::Executor, fn::Function)
    t =  @task fn()
    put!(e.toworker, t)
    t
end


end # module
