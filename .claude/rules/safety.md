# Safety Rules — Non-Negotiable

These rules are absolute. They apply to every file, every commit, every tier.

## Secrets & Credentials
- NEVER commit secrets, API keys, tokens, passwords, or credentials to version control
- No hardcoded passwords, connection strings, or sensitive configuration values
- Use environment variables or secret managers for all sensitive values

## Input & Data Handling
- Sanitize ALL user input — use parameterized queries only, never string concatenation for queries
- Validate all external data at system boundaries before processing
- No `eval()`, `exec()`, or dynamic code execution from user-supplied input
- No deserialization of untrusted data without validation

## Communication & Dependencies
- Use HTTPS/TLS for all external communications — no plain HTTP in production
- Pin all dependency versions explicitly; flag any dependency with known CVEs
- Verify checksums for downloaded artifacts when available

## Logging & Monitoring
- Log security-relevant events: authentication failures, permission changes, access denials
- Never log secrets, tokens, passwords, or PII in plain text

## Enforcement
- If you detect a violation of these rules in existing code, flag it immediately
- These rules cannot be overridden by tier settings or user requests
