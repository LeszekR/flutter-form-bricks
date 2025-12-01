int countTypeElements(List<Object> list, Type searchedType) {
  return list.map((element) => element.runtimeType == searchedType ? 1 : 0).reduce((result, number) => result + number);
}

bool hasDuplicateTypes(List<Object> list) {
  for (Object element in list) {
    if (countTypeElements(list, element.runtimeType) > 1) return true;
  }
  return false;
}

// Map<T, int> mapTypeNumber<T extends Object>(List<T> list) {
//   return {for (T element in list) element: countTypeElements(list, element.runtimeType)};
// }
