# Flutter Form Bricks

## Gap analysis

As part of building this form library, I performed a **systematic gap analysis between Flutter’s
native form APIs (Form, FormField, RestorationMixin, etc.) and the advanced requirements of
enterprise-grade forms**. This involved surveying existing framework capabilities, identifying
overlaps, and defining clear boundaries for reuse, extension, or replacement. The outcome was an
architecture where Flutter’s proven primitives are leveraged wherever possible, and this library
adds missing features such as centralized validation, error summaries, tabbed form state, built-in
state restoration, etc.

### Key uniqueness guard

This project includes a **key-uniqueness guard** to prevent subtle Flutter bugs caused by duplicate
keys.

- **Classes**: `KeyGen` (marker), `KeyRegistry` (debug-time uniqueness checks), `ValueKeyGen`
  , `ObjectKeyGen`, `UniqueKeyGen`, `GlobalKeyGen`.
- **Mechanism**: In debug mode, every generated key is checked against a global registry. Duplicates
  immediately throw an error. In release builds, all checks are tree-shaken out → no runtime cost.
- **Why**: Flutter only enforces key uniqueness among siblings. Two widgets in the same form can
  share a `ValueKey("x")` and behave unpredictably. Our guard enforces **global uniqueness** during
  development to catch such mistakes.
- **Testing**: `KeyRegistry.reset()` is provided for unit tests to clear the registry between runs.
- **Future**: Eventually, all keys in this app will be supplied only through `KeyGen`
  implementations, ensuring full coverage.

### AutoValidateModeBrick

`AutoValidateModeBrick` defines when form fields automatically validate in Brick forms.

Unlike Flutter’s `AutovalidateMode`, Brick **always validates once before the first build**.  
This replaces Flutter’s default post-build validation and ensures that the form knows its initial
validity immediately.

This approach also allows `TabbedFormBrick` to validate `initialValue`s without instantiating states
for invisible tabs.  
Errors in those initial values (or their absence) can immediately mark the tab header with an error
state, even if the tab’s content hasn’t been built yet.

Modes:

- **onCreateOrSave** → validate before the first build, then only again when the form is saved (
  equivalent to Flutter’s `disabled`, but using pre-build instead of post-build validation).
- **onChange** → validate before the first build and on every change to the field’s value (
  equivalent to Flutter’s `onUserInteraction`, but using pre-build instead of post-build validation)
  .
- **onEditingComplete** → validate before the first build and when editing completes (focus loss, or
  user presses “done”). Useful when a `FormatterValidatorChain` can only complete its work on
  finished multi-character input, e.g. shortened date/time input.

There is no `always` mode: it is redundant in Brick, since every field already validates once before
the first build.  
All fields are also validated on form save, ensuring that external state changes are always taken
into account at that time.

⚠️ Brick does **not** validate fields on every focus gain. While this could catch rare cases where
external state changes affect a field’s validity, it would waste energy by running unnecessary
validations.  
This design deliberately favors slightly worse UX in rare edge cases over continuous revalidation on
focus.

## TODO

**describe / explain / elaborate on:**

- `ElevatedButtonWithDisabling`

## Input widget stack

###

**Assumptions**

- every input in the UI must be labelled
- the label can be placed on top, to the left, to the right of the input
- colors assigned to states are unified across the app
- the colors of states can be overriden individually via passing overloaded AppStyle object
- if a menu/picker/list/etc opening button is attached to a text field it both the button and the
  text field mus react to the change in state of any of them
- states are prioritised so the more important state's color is displayed (e.g. disabled over error,
  error over others, etc)

###

**Elaborate on**

- `AppTheme` - global (scoped), dynamic, possibly scoped when overriding class used - less
  boilerplate, consistent look
- label position around BrickField
- `BrickTextField` can have `IconButton` for any use
- architecture: `LabelledContainer`, `TextFieldBox`, `BrickTextField`
  containint `StateAwareIconButton`
- formatting validation chain
- `FormManager` role: formatting, validation, storing state, collecting data from inputs, initial
  values

**Visual params**

- Refactored AppColor, AppSize, AppStyle to abstract class + default implementation
- This way no static vars and dynamic change of theme, sizes are possible to implement
- AppStyle can also be overriden by a dev
- All three are accessed via InheritedWidget - this allows for scoping by replacing implementations
  for parts of the tree

###

**Architecture**

- all inputs are put inside `LabelledContainer`

`LabelledContainer` provides

- label position setting
- bordered container providing unified style and color
- `ValueListenableBuilder` reacting to widget states with colors

**Widget classes**

- `TextFieldStateAware`
- `IconButtonStateAware`
- `(CheckBoxStateAware)`
- `(RadioStateAware)`
- `(DropBoxStateAware)`

**Text input variants**

- no button: `LabelledContainer` + `TextFieldColored`
- with button: `LabelledContainer` + `TextFieldColored` + `IconButtonColored`

## Add your files

- [ ] [Create](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#create-a-file)
  or [upload](https://docs.gitlab.com/ee/user/project/repository/web_editor.html#upload-a-file)
  files
- [ ] [Add files using the command line](https://docs.gitlab.com/topics/git/add_files/#add-files-to-a-git-repository)
  or push an existing Git repository with the following command:

```
cd existing_repo
git remote add origin https://gitlab.com/zarzur/flutter-desktop-bricks.git
git branch -M main
git push -uf origin main
```

## Integrate with your tools

- [ ] [Set up project integrations](https://gitlab.com/zarzur/flutter-desktop-bricks/-/settings/integrations)

## Collaborate with your team

- [ ] [Invite team members and collaborators](https://docs.gitlab.com/ee/user/project/members/)
- [ ] [Create a new merge request](https://docs.gitlab.com/ee/user/project/merge_requests/creating_merge_requests.html)
- [ ] [Automatically close issues from merge requests](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
- [ ] [Enable merge request approvals](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/)
- [ ] [Set auto-merge](https://docs.gitlab.com/user/project/merge_requests/auto_merge/)

## Test and Deploy

Use the built-in continuous integration in GitLab.

- [ ] [Get started with GitLab CI/CD](https://docs.gitlab.com/ee/ci/quick_start/)
- [ ] [Analyze your code for known vulnerabilities with Static Application Security Testing (SAST)](https://docs.gitlab.com/ee/user/application_security/sast/)
- [ ] [Deploy to Kubernetes, Amazon EC2, or Amazon ECS using Auto Deploy](https://docs.gitlab.com/ee/topics/autodevops/requirements.html)
- [ ] [Use pull-based deployments for improved Kubernetes management](https://docs.gitlab.com/ee/user/clusters/agent/)
- [ ] [Set up protected environments](https://docs.gitlab.com/ee/ci/environments/protected_environments.html)

***

# Editing this README

When you're ready to make this README your own, just edit this file and use the handy template
below (or feel free to structure it however you want - this is just a starting point!). Thanks
to [makeareadme.com](https://www.makeareadme.com/) for this template.

## Suggestions for a good README

Every project is different, so consider which of these sections apply to yours. The sections used in
the template are suggestions for most open source projects. Also keep in mind that while a README
can be too long and detailed, too long is better than too short. If you think your README is too
long, consider utilizing another form of documentation rather than cutting out information.

## Name

Choose a self-explaining name for your project.

## Description

Let people know what your project can do specifically. Provide context and add a link to any
reference visitors might be unfamiliar with. A list of Features or a Background subsection can also
be added here. If there are alternatives to your project, this is a good place to list
differentiating factors.

## Badges

On some READMEs, you may see small images that convey metadata, such as whether or not all the tests
are passing for the project. You can use Shields to add some to your README. Many services also have
instructions for adding a badge.

## Visuals

Depending on what you are making, it can be a good idea to include screenshots or even a video (
you'll frequently see GIFs rather than actual videos). Tools like ttygif can help, but check out
Asciinema for a more sophisticated method.

## Installation

Within a particular ecosystem, there may be a common way of installing things, such as using Yarn,
NuGet, or Homebrew. However, consider the possibility that whoever is reading your README is a
novice and would like more guidance. Listing specific steps helps remove ambiguity and gets people
to using your project as quickly as possible. If it only runs in a specific context like a
particular programming language version or operating system or has dependencies that have to be
installed manually, also add a Requirements subsection.

## Usage

Use examples liberally, and show the expected output if you can. It's helpful to have inline the
smallest example of usage that you can demonstrate, while providing links to more sophisticated
examples if they are too long to reasonably include in the README.

## Support

Tell people where they can go to for help. It can be any combination of an issue tracker, a chat
room, an email address, etc.

## Roadmap

If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing

State if you are open to contributions and what your requirements are for accepting them.

For people who want to make changes to your project, it's helpful to have some documentation on how
to get started. Perhaps there is a script that they should run or some environment variables that
they need to set. Make these steps explicit. These instructions could also be useful to your future
self.

You can also document commands to lint the code or run tests. These steps help to ensure high code
quality and reduce the likelihood that the changes inadvertently break something. Having
instructions for running tests is especially helpful if it requires external setup, such as starting
a Selenium server for testing in a browser.

## Authors and acknowledgment

Show your appreciation to those who have contributed to the project.

## License

For open source projects, say how it is licensed.

## Project status

If you have run out of energy or time for your project, put a note at the top of the README saying
that development has slowed down or stopped completely. Someone may choose to fork your project or
volunteer to step in as a maintainer or owner, allowing your project to keep going. You can also
make an explicit request for maintainers.
