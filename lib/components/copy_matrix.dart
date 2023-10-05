typedef CopyItemCallback<T> = T Function(T item);

Iterable<T> copyIterable<T>(
  Iterable<T> list, {
  CopyItemCallback<T>? copyItem,
}) {
  return list.map((item) => copyItem == null ? item : copyItem(item));
}

List<T> copyList<T>(
  List<T> list, {
  CopyItemCallback<T>? copyItem,
}) {
  return copyIterable(list, copyItem: copyItem).toList();
}

List<List<T>> copyMatrix<T>(
  List<List<T>> matrix, {
  CopyItemCallback<T>? copyItem,
}) {
  return copyList(
    matrix,
    copyItem: (item) => copyList(item, copyItem: copyItem),
  );
}
