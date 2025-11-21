# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of our Neovim configuration seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do Not** Open a Public Issue

Please do not open a public GitHub issue for security vulnerabilities as this could expose users to attacks.

### 2. Report Privately

Send your findings to:
- **GitHub Security Advisories**: Use the "Security" tab in this repository to report privately (Preferred method)
- **Email**: security@epicsagas.dev (Alternative contact)

### 3. Include Details

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)
- Your contact information

### 4. Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: Within 7 days
  - High: Within 14 days
  - Medium: Within 30 days
  - Low: Next regular release

## Security Best Practices

### API Key Management

**Never commit API keys to the repository:**

```bash
# ❌ Bad - Don't do this
export ANTHROPIC_API_KEY="sk-ant-api-key-here"

# ✅ Good - Use environment variables
export ANTHROPIC_API_KEY="sk-ant-..."
export GEMINI_API_KEY="AIza..."
```

**Use password managers:**
```bash
# 1Password
export ANTHROPIC_API_KEY=$(op read "op://personal/Anthropic/credential")

# Bitwarden
export GEMINI_API_KEY=$(bw get password "Gemini API")
```

### Plugin Security

**Before installing plugins:**
1. Review the plugin source code
2. Check the number of stars and recent activity
3. Read through recent issues
4. Verify maintainer reputation

**Plugin sources we use:**
- GitHub repositories with 100+ stars
- Active maintenance (commits within 3 months)
- Clear documentation and license

### LSP and Tool Security

**Only install LSP servers from official sources:**
```vim
-- Use Mason for automatic installation
:Mason
```

**Verify checksums for manually installed tools:**
```bash
# Example: Verify rust-analyzer
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-apple-darwin.gz -o rust-analyzer.gz
# Verify checksum against official release
```

### File Permissions

**Ensure proper permissions:**
```bash
# Config files should not be world-writable
chmod 755 ~/.config/nvim
chmod 644 ~/.config/nvim/**/*.lua

# Scripts should be executable by owner only
chmod 700 ~/.config/nvim/scripts/*
```

### Network Security

**LSP and plugins make network requests:**
- Language servers download updates
- Package managers fetch plugins
- AI integrations call external APIs

**Review network activity:**
```bash
# Monitor network connections
lsof -i -P | grep nvim
```

## Known Security Considerations

### 1. AI Integration

- **API Keys**: Stored in environment variables, never in config files
- **Data Privacy**: Code sent to AI providers (Claude, Gemini, xAI)
- **Network Traffic**: All AI requests use HTTPS

### 2. Plugin Ecosystem

- **Third-party Code**: Plugins run with full Neovim permissions
- **Auto-updates**: lazy.nvim can auto-update plugins
- **Recommendation**: Review plugin updates before applying

### 3. External Tools

- **Language Servers**: Run with file system access
- **Formatters/Linters**: Execute on your code
- **Debuggers**: Can inspect process memory

## Disclosure Policy

When we receive a security report:

1. **Confirmation**: We confirm the vulnerability
2. **Patch Development**: We develop a fix
3. **Testing**: We test the fix thoroughly
4. **Release**: We release a patched version
5. **Disclosure**: We publicly disclose the vulnerability after patch release
6. **Credit**: We credit the reporter (unless they prefer anonymity)

## Security Updates

Subscribe to security updates:
- Watch this repository for security advisories
- Check the [CHANGELOG.md](CHANGELOG.md) for security fixes
- Follow our [GitHub Security Advisories](https://github.com/epicsagas/vortex.nvim/security/advisories)

## Hall of Fame

We appreciate security researchers who responsibly disclose vulnerabilities:

<!-- Future security researchers will be listed here -->

## Questions?

For general security questions (not vulnerability reports), please:
- Open a [GitHub Discussion](https://github.com/epicsagas/vortex.nvim/discussions)
- Tag it with the "security" label

---

**Last Updated**: November 20, 2024
