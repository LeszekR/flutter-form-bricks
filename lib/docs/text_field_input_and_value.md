/// Dual-State Form Input: `inputString` + `T? value`
/// 
/// `FormFieldBrickState<T>` maintains both:
/// 
/// - `inputString`: the raw text entered by the user
/// - `value`: the parsed value of type `T?`, or `null` if parsing/validation failed
/// 
/// This dual-state design ensures robust user experience and type-safe data handling:
/// 
/// - `inputString` is always preserved, even if it's invalid or partially edited
/// - On widget build, the input field is rehydrated from `inputString` to resume editing exactly where the user left off
/// - `FormFieldStateData` stores both the current input and parsed value; this state is preserved across widget rebuilds and navigation
/// 
/// Parsing and Validation:
/// All conversion and validation are handled by the associated `FormatterValidatorChain<T>`, which processes `inputString` and returns a `DateTimeValueAndError<T>`:
/// 
/// - If parsing and validation succeed, `parsedValue` is stored in `FormFieldStateData.value`
/// - If parsing or validation fail, `value` is set to `null`, but `inputString` remains unchanged
/// 
/// This design allows for meaningful error feedback while avoiding user frustration due to input loss.
/// 
/// Specialized Validators:
/// For date and time fields, `DateFormatterValidator`, `TimeFormatterValidator`, and `DateTimeFormatterValidator` provide:
/// 
/// - String parsing logic (`String → T`)
/// - Domain-specific validation
/// - Meaningful error messages when input is invalid
/// 
/// Data Submission:
/// On form submission, the final parsed values (`T`) are read from `FormFieldBrick.value` and passed to a domain-layer service responsible for saving or transforming the data.
