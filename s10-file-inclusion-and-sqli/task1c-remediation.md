# Task 1C: Remediation — File Inclusion and SQL Injection

**Student:** Aazib Ali

---

## Fix for File Inclusion

The `page` parameter must never be passed directly into `include()`.
Correct fix: an allowlist — define the exact set of files allowed,
reject anything that doesn't match.

```php
$allowed = ['home', 'about', 'contact'];
if (!in_array($_GET['page'], $allowed)) {
    die('Invalid page.');
}
include($allowed[$_GET['page']]);
```

A blocklist (blocking `../` or null bytes) fails because there are
many encoding variants (`%2e%2e%2f`, `..%2f`, etc.) that bypass
string matching.

---

## Fix for SQL Injection

Only complete fix: parameterized queries (prepared statements).
User input must never be concatenated into a query string.

```php
$stmt = $pdo->prepare('SELECT * FROM users WHERE id = ?');
$stmt->execute([$_GET['id']]);
```

Input validation / WAFs are extra layers, not substitutes — a WAF
can be bypassed with encoding; a parameterized query cannot, because
the DB engine never treats user input as SQL syntax.

---

## Why allowlist beats blocklist (both cases)

A blocklist defines what's forbidden — one missed encoding/variant
breaks it everywhere. An allowlist defines what's permitted — nothing
outside it is ever accepted. Root cause in both vulnerabilities:
unvalidated input reaching an interpreter. The allowlist fixes that
directly by only letting known-safe values through.
