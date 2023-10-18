# Upgrade from v1 to v2

## Asynchronous subscribers
`EventDispatcher.dispatch` returns a Future. If any subscriber is async and depend 
on modification of the event itself you need to `await` the result of the call.  