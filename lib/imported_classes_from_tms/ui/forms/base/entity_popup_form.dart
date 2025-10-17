import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart';

import '../../../config/objects/abstracts/entity.dart';
import '../../buttons/buttons.dart';
import '../../style/app_size.dart';
import '../../table/column.dart';
import 'form_utils.dart';

class EntityPopupForm<T extends Entity> extends StatelessWidget {
  static const _descriptionKeyString = 'description';
  final List<TrinaColumn> _columns = [
    Columns.text(
      keyString: _descriptionKeyString,
      label: 'Description',
      enableFiltering: true,
    )
  ];

  final List<T> entities;
  EntityPopupForm({super.key, required this.entities});

  @override
  Widget build(final BuildContext context) {
    final rows = entities
        .map((entity) => TrinaRow(cells: {_descriptionKeyString: TrinaCell(value: entity.shortDescription())}, sortIdx: entities.indexOf(entity)))
        .toList();

    final table = TrinaGrid(
      columns: _columns,
      rows: rows,
      onLoaded: (final TrinaGridOnLoadedEvent event) => event.stateManager.setShowColumnFilter(true),
      onRowDoubleTap: (event) {
        final entityDescription = event.row.cells[_descriptionKeyString]!.value as String;
        final selectedEntity = entities.firstWhere((entity) => entity.shortDescription() == entityDescription);
        Navigator.of(context).pop(selectedEntity);
      },
    );

    final content = Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: createTableControls(context),
        ),
        Expanded(child: table),
      ],
    );

    return FormUtils.defaultScaffold(label: "Wybierz", child: content);
  }

  Wrap createTableControls(final BuildContext context) {
    final buttons = [Buttons.elevatedButton(text: 'Usuń wybór',  onPressed: () => Navigator.of(context).pop(null) )];
    return Wrap(spacing: AppSize.popupFormSpacing, children: buttons);
  }
}