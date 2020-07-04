/// Returns whether the `assert` statement is currently enabled.
bool get assertionsEnabled {
  var enabled = false;
  assert(enabled = true);
  return enabled;
}
