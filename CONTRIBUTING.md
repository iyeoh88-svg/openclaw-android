# Contributing to OpenClaw Android

Thank you for your interest in contributing! This document provides guidelines for contributing to the OpenClaw Android installer project.

## ⚠️ Important Notice

**This repository contains an installer/automation tool, not OpenClaw itself.**

- **What we maintain**: The automated installation script and documentation for Android/Termux
- **What we don't maintain**: OpenClaw framework itself (see [official OpenClaw repo](https://github.com/openclaw/openclaw))
- **Contribution scope**: Installation process, Android compatibility, Termux setup, documentation

**For OpenClaw framework issues, features, or contributions**, please visit the official OpenClaw repository.

---

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Submission Guidelines](#submission-guidelines)
- [Style Guidelines](#style-guidelines)
- [Testing](#testing)

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on what's best for the community
- Show empathy towards others
- Accept constructive criticism gracefully

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing others' private information
- Any conduct that would be inappropriate in a professional setting

## How Can I Contribute?

### Reporting Bugs

Before creating a bug report:
1. Check the [TROUBLESHOOTING.md](TROUBLESHOOTING.md) guide
2. Search [existing issues](https://github.com/iyeoh88-svg/openclaw-android/issues)
3. Update to the latest version

**Good Bug Report Includes:**
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Android version
- Termux version
- Error messages/logs
- Screenshots (if relevant)

**Template:**
```markdown
**Environment:**
- Android Version: 
- Termux Version: 
- Installer Version: 

**Steps to Reproduce:**
1. 
2. 
3. 

**Expected Behavior:**


**Actual Behavior:**


**Error Messages:**
```
[paste error messages here]
```

**Additional Context:**

```

### Suggesting Enhancements

Before suggesting an enhancement:
1. Check if it's already been suggested
2. Consider if it fits the project scope
3. Think about how it helps users

**Good Enhancement Suggestion Includes:**
- Clear use case
- How it improves user experience
- Potential implementation approach
- Mockups/examples (if applicable)

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Test thoroughly** on real Android device
5. **Update documentation** if needed
6. **Commit with clear messages**: `git commit -m 'Add amazing feature'`
7. **Push to your fork**: `git push origin feature/amazing-feature`
8. **Open a Pull Request**

## Development Setup

### Prerequisites

- Android device with Termux
- Git installed in Termux
- Text editor (nano, vim, or use termux-open to edit externally)

### Setting Up Development Environment

```bash
# In Termux
pkg install git nano

# Fork and clone your repository
git clone https://github.com/YOUR_USERNAME/openclaw-android.git
cd openclaw-android

# Create a feature branch
git checkout -b feature/my-feature
```

### Testing Your Changes

1. **Test the installer:**
   ```bash
   # Make script executable
   chmod +x install.sh
   
   # Test installation
   ./install.sh --skip-update-check
   ```

2. **Test on clean environment:**
   ```bash
   # Remove existing installation
   proot-distro remove debian -y
   
   # Test fresh install
   ./install.sh --reinstall
   ```

3. **Test update mechanism:**
   - Modify VERSION file
   - Test if update detection works
   - Verify script updates correctly

### Areas for Contribution

#### 🐛 Bug Fixes
- Fix installation errors
- Resolve compatibility issues
- Improve error messages

#### 📚 Documentation
- Improve README clarity
- Add more troubleshooting solutions
- Create video tutorials
- Translate documentation

#### ✨ Features
- Add new convenience commands
- Improve performance
- Add configuration options
- Create Termux widgets

#### 🧪 Testing
- Test on different Android versions
- Test on various devices
- Create automated tests
- Performance benchmarking

#### 🎨 User Experience
- Improve installer output
- Better progress indicators
- More helpful error messages
- Interactive menus

## Submission Guidelines

### Commit Messages

Use clear, descriptive commit messages:

**Good:**
```
Add automatic log rotation feature

- Implements daily log rotation
- Keeps last 7 days of logs
- Configurable via environment variable
```

**Bad:**
```
fixed stuff
update
more changes
```

### Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Example:**
```
feat: Add progress bar for Debian installation

- Shows percentage complete during package installation
- Improves user experience for long-running operations
- Uses simple ASCII progress bar compatible with Termux

Closes #42
```

### Pull Request Process

1. **Update documentation** for any new features
2. **Add comments** to explain complex code
3. **Test on real device** before submitting
4. **Update CHANGELOG.md** with your changes
5. **Reference related issues** in PR description

**PR Description Template:**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
How did you test this?
- [ ] Tested on Android 12
- [ ] Tested on Android 13
- [ ] Tested fresh install
- [ ] Tested upgrade path

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Changes tested on device
- [ ] CHANGELOG.md updated
```

## Style Guidelines

### Bash Script Style

```bash
# Use set -e for error handling
set -e

# Clear variable names
DEBIAN_VERSION="12"  # Good
v="12"              # Bad

# Functions should have descriptive names
install_debian() {   # Good
    # implementation
}

do_stuff() {        # Bad
    # implementation
}

# Use comments for complex logic
# Check if Debian is already installed before proceeding
if proot-distro list | grep -q "debian.*installed"; then
    # ... handling code
fi

# Consistent indentation (4 spaces)
if [ condition ]; then
    do_something
    if [ other_condition ]; then
        do_nested_thing
    fi
fi
```

### Documentation Style

- Use clear, simple language
- Include code examples
- Break complex tasks into steps
- Use emojis sparingly for section headers
- Keep line length reasonable (80-100 chars)

### Code Comments

```bash
# Good: Explain WHY, not WHAT
# We use loopback binding to avoid Android network restrictions
openclaw gateway --bind loopback

# Bad: States the obvious
# Start the gateway
openclaw gateway --bind loopback
```

## Testing

### Manual Testing Checklist

Before submitting:

- [ ] Fresh installation works
- [ ] Reinstallation works
- [ ] Update detection works
- [ ] All aliases work correctly
- [ ] Error handling works
- [ ] Documentation is accurate
- [ ] No broken links in docs
- [ ] VERSION file is updated

### Test Environments

Ideally test on:
- Android 12
- Android 13
- Android 14
- Different devices (if possible)
- Different Termux versions

### Reporting Test Results

```markdown
**Test Results:**
- Device: Samsung Galaxy S21
- Android: 13
- Termux: 0.118.0
- Result: ✅ All tests passed

**Notes:**
- Installation took 12 minutes
- No errors encountered
- All features working as expected
```

## Recognition

Contributors will be:
- Listed in README.md
- Mentioned in release notes
- Credited in CHANGELOG.md

## Questions?

- Open a [Discussion](https://github.com/iyeoh88-svg/openclaw-android/discussions)
- Comment on relevant issues
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to make OpenClaw accessible on Android! 🦞
