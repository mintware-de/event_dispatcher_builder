## 2.1.0

Dependency updates

```yaml
analyzer: ">=8.1.0 <14.0.0"
```

## 2.0.1

- Fix wrong dependency constraint of `code_builder`

## 2.0.0

Dependency changes:

- `analyzer`: `^8.0.0` ➡️ `^8.1.0`
- `test`: `any`
- `lints`: `>=2.0.0`

## 2.0.0-dev.1

Reworked the underlying architecture. This should improve the build performance.

For upgrading see [UPGRADE.md](UPGRADE.md)

Dependency changes:

- `analyzer`: `>=5.0.0 <7.0.0` ➡️ `^8.0.0`
- `sdk`: `>=2.17.0 <4.0.0` ➡️ `^3.5.0`
- `code_builder`: `>=3.2.0 <5.0.0` ➡️ `^4.0.0`
- `build`: `^2.1.0` ➡️ `^4.0.0`
- `path`: Removed 🎉
- `analyzer`: `>=5.0.0 <7.0.0` ➡️ `^8.0.0`
- `build_runner_core`: Removed 🎉

Dev Dependency changes:

- `test`: `^1.21.1` ➡️ Loose constraint
- `lints`: `^2.1.0` ➡️ Loose constraint
- `build_runner`: `^2.0.5` ➡️ `^2.5.0`

## 1.2.0

Add support for dart_style ^3 and build_runner_core ^8

## 1.1.0

Features:

- `async` subscribers are now supported. The `EventDispatcher.dispatch` returns a future.

## 1.0.0

- Initial version.
