module FuturesTests
using Test
using Futures

fn() = (sleep(0.5); 1)
fn2() = (sleep(0.5); 2)
@test fn() == 1
@test fn2() == 2

scheduler = Executor()
future = schedule(scheduler, fn)
future2 = schedule(scheduler, fn2)
@test !istaskdone(future)
@test !istaskdone(future2)
@test fetch(future) == 1
@test istaskdone(future)
@test !istaskdone(future2)
@test fetch(future2) == 2
future = schedule(scheduler, fn)
future2 = schedule(scheduler, fn2)
@test !istaskdone(future)
@test !istaskdone(future2)
@test fetch(future2) == 2
@test istaskdone(future)
@test istaskdone(future2)
@test fetch(future) == 1
end
