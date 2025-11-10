// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'bricks_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class BricksLocalizationsPl extends BricksLocalizations {
  BricksLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get buttonYes => 'Tak';

  @override
  String get buttonNo => 'Nie';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonCancel => 'Anuluj';

  @override
  String get buttonSave => 'Zapisz';

  @override
  String get buttonDelete => 'Skasuj';

  @override
  String get buttonChange => 'Change';

  @override
  String get buttonReset => 'Resetuj';

  @override
  String get dialogsWarning => 'UWAGA';

  @override
  String get dialogsSuccess => 'Sukces';

  @override
  String get dialogsError => 'Błąd';

  @override
  String get dialogsDecision => 'Reset formularza';

  @override
  String get progressPleaseWait => 'Proszę czekać';

  @override
  String get dialogsSaveSuccess => 'Dane zostały zapisane';

  @override
  String get dialogsDeleteSuccess => 'Dane zostały usunięte';

  @override
  String get dialogsNoChanges => 'Nie ma zmian do zapisania';

  @override
  String get dialogsFinishOrCorrect => 'Popraw lub uzupełnij dane';

  @override
  String get dialogsConfirmCancel =>
      'Jeśli potwierdzisz, to wszystkie zmiany zostaną utracone.\nKontynuować?';

  @override
  String validationMessageRequired(Object field, String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': ' jest wymagany',
        'female': ' jest wymagana',
        'other': ' jest wymagane',
      },
    );
    return '$field $_temp0';
  }

  @override
  String validationDecimal(num field) {
    String _temp0 = intl.Intl.pluralLogic(
      field,
      locale: localeName,
      other: 'z $field znakami',
      one: 'z 1 znakiem',
    );
    return 'Tylko dodatnie liczby zmienno-przecinkowe $_temp0';
  }

  @override
  String get validationInteger => 'Tylko dodatnie liczby całkowite';

  @override
  String get validationPasswordOldNew => 'Nowe i stare hasło muszą się różnić';

  @override
  String get validationPasswordPassRepeatPass =>
      'Hasło i hasło powtórz musza się zgadzać';

  @override
  String get openDatePicker => 'Otwórz kalendarz';

  @override
  String get openTimePicker => 'Otwórz zegar';

  @override
  String get and => 'oraz';

  @override
  String get date => 'data';

  @override
  String get time => 'godzina';

  @override
  String get start => 'początek';

  @override
  String get end => 'koniec';

  @override
  String get delete => 'Skasuj';

  @override
  String get reset => 'Resetuj';

  @override
  String get save => 'Zapisz';

  @override
  String get formReset => 'Reset formularza';

  @override
  String get formResetConfirm =>
      'Jeśli wciśniesz OK to wszystkie zmiany zostaną utracone.\nKontynuować?';

  @override
  String get deleteConfirm => 'Na pewno chcesz usunąć?';

  @override
  String get requiredField => 'Pole wymagane';

  @override
  String get invalidEmail => 'Niepoprawny format email';

  @override
  String get invalidVAT => 'Niepoprawny nr VAT';

  @override
  String minNChars(Object charsMinimumN) {
    return 'W polu muszą być min. $charsMinimumN znaki';
  }

  @override
  String maxNChars(Object charsMinimumN) {
    return 'W polu muszą być max. $charsMinimumN znaki';
  }

  @override
  String minIntValue(Object IntValueMinimum) {
    return 'Minimalna liczba to $IntValueMinimum';
  }

  @override
  String maxIntValue(Object IntValueMaximum) {
    return 'Maksymalna liczba to $IntValueMaximum';
  }

  @override
  String get rangeDateStartRequired => 'Brak daty początku';

  @override
  String get rangeDateEndRequiredOrRemoveTimeEnd =>
      'Podaj datę końca lub usuń czas końca';

  @override
  String get rangeDateStartAfterEnd => 'Data końca jest przed datą początku';

  @override
  String get rangeTimeStartAfterEndOrAddDateEnd =>
      'Dodaj datę końca lub poporaw czasy, aby czas końca był po czasie początku';

  @override
  String get rangeTimeStartAfterEnd => 'Czas końca jest przed czasem początku';

  @override
  String rangeTimeStartEndTooCloseOrAddDateEnd(Object timesMinDifference) {
    return 'Dodaj datę końca lub popraw czasy: czas końca musi być co najmniej $timesMinDifference minut po czasie początku';
  }

  @override
  String rangeTimeStartEndTooCloseSameDate(Object timesMinDifference) {
    return 'Czas końca musi być co najmniej $timesMinDifference minut po czasie początku';
  }

  @override
  String rangeDatesTooFarApart(int maxDatesDifference) {
    return 'Maksymalna liczba dni między datą początku a datą końca, to $maxDatesDifference';
  }

  @override
  String get rangeStartSameAsEnd =>
      'Początek i koniec to ten sam termin - mień lub usuń koniec';

  @override
  String get dateStringErrorBadChars => 'Znaki niedozwolone dla daty';

  @override
  String get dateStringErrorTooFewDigits => 'Za mało cyfr dla daty';

  @override
  String get dateStringErrorTooManyDigits => 'Za dużo cyfr dla daty';

  @override
  String get dateStringErrorTooManyDelimiters =>
      'Za dużo znaków rozdzielających dla daty';

  @override
  String get dateStringErrorTooManyDigitsDay => 'Za dużo cyfr dla dnia';

  @override
  String get dateStringErrorTooManyDigitsMonth => 'Za dużo cyfr dla miesiąca';

  @override
  String get dateStringErrorTooManyDigitsYear => 'Za dużo cyfr dla roku';

  @override
  String get dateErrorDay0 => 'Nie ma dnia 0';

  @override
  String get dateErrorMonth0 => 'Nie ma miesiaca 0';

  @override
  String get dateErrorTooManyDaysInMonth => 'Za dużo dni w miesiącu';

  @override
  String get dateErrorMonthOver12 => 'Nie ma miesiąca większego niż 12';

  @override
  String dateErrorTooFarBack(String minDateParam) {
    return 'Data i czas nie mogą być wcześniejsze niż $minDateParam';
  }

  @override
  String dateErrorTooFarForward(String maxDateParam) {
    return 'Data nie może być późniejsza niż $maxDateParam';
  }

  @override
  String get mustNotPrecede => 'nie może być przed';

  @override
  String get timeStringErrorBadChars => 'Znaki niedozwolone dla czasu';

  @override
  String get timeStringErrorTooFewDigits => 'Za mało cyfr dla czasu';

  @override
  String get timeStringErrorTooManyDigits => 'Za dużo cyfr dla czasu';

  @override
  String get timeStringErrorTooManyDelimiters =>
      'Za dużo znaków rozdzielających dla czasu';

  @override
  String get timeStringErrorTooManyDigitsMinutes => 'Za dużo cyfr dla minut';

  @override
  String get timeStringErrorTooManyDigitsHours => 'Za dużo cyfr dla godzin';

  @override
  String get timeErrorTooBigMinute => 'Za dużo minut - nie ma takiej godziny';

  @override
  String get timeErrorTooBigHour =>
      'Za dużo godzin - nie ma takiej godziny (północ to 00:00)';

  @override
  String get datetimeStringErrorNoSpace =>
      'Data musi być oddzielona spacją od godziny';

  @override
  String get datetimeStringErrorTooManySpaces => 'Za dużo spacji';
}
