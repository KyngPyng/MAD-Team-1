# TeamSync Weekly Change Summary

## Data Source Update

- Program listing and program details now read from `assets/data/mock_data.json`.
- Home, projects, team dashboard, and navigation screens now use the same shared mock repository.
- Dummy Dart data files were removed.

## Form Added

- A new feedback form was added on the profile screen.
- Validation rules:
  - name is required
  - email is required and must include `@`
  - feedback message is required and must be at least 10 characters
- Successful submit shows a snackbar and closes the form.

## Loading and Error Handling

- Mock JSON loading happens at app startup.
- If the JSON asset fails to load, the repository falls back to empty lists and the UI shows a warning banner plus empty states instead of crashing.
