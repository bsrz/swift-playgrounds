enum LoadingState<T> {
  case idle
  case loading
  case loaded(Result<T, Error>)
}
