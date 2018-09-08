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
sleep(0.15)
@test state(future) == "running"
@test state(future2) == "not yet started"
@test fetch(future) == 1
@test istaskdone(future)
@test !istaskdone(future2)
sleep(0.15)
@test state(future) == "done"
@test state(future2) == "running"
@test fetch(future2) == 2
future = schedule(scheduler, fn)
future2 = schedule(scheduler, fn2)
@test !istaskdone(future)
@test !istaskdone(future2)
@test fetch(future2) == 2
@test istaskdone(future)
@test istaskdone(future2)
@test fetch(future) == 1

fn3(a) = (sleep(0.5); a)
@test fn3(1) == 1
@test fn3(2) == 2

future = schedule(scheduler, @task fn3(2))
future2 = schedule(scheduler, @task fn3(3))
@test !istaskdone(future)
@test !istaskdone(future2)
@test fetch(future2) == 3
@test istaskdone(future)
@test istaskdone(future2)
@test fetch(future) == 2

future = schedule(scheduler, @task fn3(2))
future2 = schedule(scheduler, @task fn3(3))
sleep(0.15)
@test state(future) == "running"
@test state(future2) == "not yet started"
cancel(scheduler)
@test state(future) == "running"
@test state(future2) == "not yet started"
fetch(future) == 2
sleep(0.5)
@test state(future2) == "not yet started"
end
