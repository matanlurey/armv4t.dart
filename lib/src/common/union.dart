/// Represents either [L] or [R], in a type-safe manner.
abstract class Or2<L, R> {
  /// Creates initialized with a value of type [L].
  const factory Or2.left(L value) = _Left2;

  /// Creates initialized with a value of type [R].
  const factory Or2.right(R value) = _Right2;

  /// Given the initialized value, invokes either [ifLeft] or [ifRight].
  T pick<T>(
    T Function(L) ifLeft,
    T Function(R) ifRight,
  );
}

class _Left2<L, R> implements Or2<L, R> {
  final L _value;

  const _Left2(this._value) : assert(_value != null);

  @override
  T pick<T>(
    T Function(L) ifLeft,
    T Function(R) ifRight,
  ) {
    return ifLeft(_value);
  }
}

class _Right2<L, R> implements Or2<L, R> {
  final R _value;

  const _Right2(this._value) : assert(_value != null);

  @override
  T pick<T>(
    T Function(L) ifLeft,
    T Function(R) ifRight,
  ) {
    return ifRight(_value);
  }
}

/// Represents either [L], [M], or [R], in a type-safe manner.
abstract class Or3<L, M, R> {
  /// Creates initialized with a value of type [L].
  const factory Or3.left(L value) = _Left3;

  /// Creates initialized with a value of type [M].
  const factory Or3.middle(M value) = _Middle3;

  /// Creates initialized with a value of type [R].
  const factory Or3.right(R value) = _Right3;

  /// Given the initialized value, invokes either [ifLeft] or [ifRight].
  T pick<T>(
    T Function(L) ifLeft,
    T Function(M) ifMiddle,
    T Function(R) ifRight,
  );
}

class _Left3<L, M, R> implements Or3<L, M, R> {
  final L _value;

  const _Left3(this._value) : assert(_value != null);

  @override
  T pick<T>(
    T Function(L) ifLeft,
    T Function(M) ifMiddle,
    T Function(R) ifRight,
  ) {
    return ifLeft(_value);
  }
}

class _Middle3<L, M, R> implements Or3<L, M, R> {
  final M _value;

  const _Middle3(this._value) : assert(_value != null);

  @override
  T pick<T>(
    T Function(L) ifLeft,
    T Function(M) ifMiddle,
    T Function(R) ifRight,
  ) {
    return ifMiddle(_value);
  }
}

class _Right3<L, M, R> implements Or3<L, M, R> {
  final R _value;

  const _Right3(this._value) : assert(_value != null);

  @override
  T pick<T>(
    T Function(L) ifLeft,
    T Function(M) ifMiddle,
    T Function(R) ifRight,
  ) {
    return ifRight(_value);
  }
}
