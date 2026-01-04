// class TestTabulatedForm extends TabulatedForm {
//   final List<TabData> _tabsData;
//
//   get tabsData => _tabsData;
//
//   TestTabulatedForm(List<TabData> tabsData, {super.key}) : _tabsData = tabsData;
//
//   @override
//   TestTabulatedFormState createState() => TestTabulatedFormState();
// }
//
// class TestTabulatedFormState extends TabulatedFormState<TestTabulatedForm> {
//   @override
//   List<TabData> makeTabsData() {
//     return (widget as TestTabulatedForm).tabsData;
//   }
//
//   @override
//   Entity? getEntity() => null; //TODO implement
//
//   @override
//   String provideLabel() => "Przykład Tabulated Form";
//
//   @override
//   void deleteEntity() => debugPrint("delete triggered.");
//
//   @override
//   EntityService<Entity> getService() => throw UnimplementedError();
//
//   @override
//   void removeEntityFromState() {}
//
//   @override
//   void upsertEntityInState(Map<String, dynamic> responseBody) {}
//
//   @override
//   void submitData() {
//     final Map<String, dynamic> formData = formManager.collectInputData();
//     debugPrint("save triggered. Data: $formData");
//   }
// }
