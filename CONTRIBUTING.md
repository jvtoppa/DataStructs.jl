Naming Conventions

    Private Functions: Any function not part of the public API must begin with an underscore (_)

        Example: _internal_helper() or _validate_input()

Type System Requirements

    Abstract Parent Types: All data structures sharing a common abstract parent type must implement all operations defined for that parent

        Example: If Collection defines add(), remove(), and size(), then List, Stack, and Queue inheriting from Collection must implement all three methods

Dependencies

    Zero Dependencies: The library must not depend on any external libraries; All functionality must be implemented from scratch - Standard library imports are permitted, but no third-party packages

Code Quality Standards

    All public functions must include docstrings

    New features must include comprehensive unit tests

    Consider time/space complexity in implementations

    Follow existing code style and patterns
    Testing: All tests must pass before merge

    Update wiki if adding new features or changing APIs
