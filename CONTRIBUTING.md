# Contributing to Minecraft Server on Raspberry Pi

This document covers the guidelines and processes for contributing to this project, including how to report issues, suggest enhancements, submit code changes, and follow project standards.

## 📑 Table of Contents

- [Contributing](#-contributing)
  - [Reporting Issues](#reporting-issues)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Code Contributions](#code-contributions)
    - [Prerequisites](#prerequisites)
    - [Development Setup](#development-setup)
    - [Making Changes](#making-changes)
    - [Pull Request Guidelines](#pull-request-guidelines)
  - [Testing](#testing)
  - [Documentation](#documentation)
- [Security](#-security)
- [License](#-license)

## 🤝 Contributing

### Reporting Issues

- Search existing issues first.
- Use the issue templates if available.
- Provide clear reproduction steps.
- Include environment details.

### Suggesting Enhancements

- Check the existing discussions.
- Explain the use case and expected conduct.
- Consider the implementation complexity.

### Code Contributions

#### Prerequisites

- A Raspberry Pi 4 with a compatible power supply and an SD card running a Linux-based OS.
- Java 16 or later installed on the host.
- The host utilities required by the scripts: `jq`, `yq`, `xmlstarlet`, `tmux`, `tar`, `curl`, and `wget`.

#### Development Setup

```bash
# Clone the repository
git clone https://github.com/hmlendea/minecraft-server-raspberrypi.git
cd minecraft-server-raspberrypi

# Install dependencies
sudo apt-get install -y jq yq xmlstarlet tmux tar curl wget
```

#### Making Changes

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes.
4. Run tests: `for TEST_SCRIPT in tests/*-tests.sh; do bash "${TEST_SCRIPT}"; done`
5. Run linters: `shellcheck scripts/*.sh scripts/common/*.sh tests/*.sh server`
6. Commit with clear and descriptive messages.
7. Push to your fork.
8. Open a Pull Request.

#### Pull Request Guidelines

- Target the `master` branch.
- Keep PRs focused and atomic.
- Revise documentation if applicable.
- Include tests for any new functionality.
- Ensure the CI checks pass.

### Testing

```bash
# Run all tests
for TEST_SCRIPT in tests/*-tests.sh; do bash "${TEST_SCRIPT}"; done

# Run specific test suite
bash tests/modrinth-tests.sh
```

### Documentation

- Revise relevant docs for changes.
- Follow the documentation style guide.
- Preview changes locally if possible.

## 🔒 Security

Report security vulnerabilities per the [Security Policy](./SECURITY.md).

## 📄 License

By contributing, you agree that your contributions will be licensed under the GNU General Public License v3.0.
