# Pyinfra Migration Guide

This guide documents patterns and conventions for migrating Ansible roles to pyinfra.

## Function Naming

All roles use `setup()` as the main entry point:

```python
# roles/{name}/__init__.py
def setup(repo_path, **kwargs):
    ...
```

## Directory Structure

```
pyinfra-dots/
├── deploy.py              # Main entry point
└── roles/
    ├── {role}/
    │   ├── __init__.py    # def setup(...)
    │   ├── files/         # Static files to link/copy
    │   └── templates/     # Jinja2 templates
```

## Ansible to pyinfra Mapping

### Operations

| Ansible | pyinfra | Module |
|---------|---------|--------|
| `ansible.builtin.file: state=directory` | `files.directory(path=...)` | `pyinfra.operations.files` |
| `ansible.builtin.file: state=link` | `files.link(path=..., target=..., force=True)` | `pyinfra.operations.files` |
| `ansible.builtin.file: state=file` | `files.file(path=...)` | `pyinfra.operations.files` |
| `ansible.builtin.template` | `files.template(src=..., dest=..., **vars)` | `pyinfra.operations.files` |
| `ansible.builtin.copy` | `files.put(src=..., dest=...)` | `pyinfra.operations.files` |
| `ansible.builtin.git` | `git.repo(src=..., dest=..., pull=True)` | `pyinfra.operations.git` |
| `ansible.builtin.package` | `files.package(packages=[...])` | `pyinfra.operations.files` |
| `ansible.builtin.user` | `server.user(user=..., shell=...)` | `pyinfra.operations.server` |
| `ansible.builtin.shell` | `server.shell(commands=[...])` | `pyinfra.operations.server` |
| `community.general.homebrew` | `brew.packages(packages=[...])` | `pyinfra.operations.brew` |
| `community.general.homebrew_cask` | `brew.casks(casks=[...])` | `pyinfra.operations.brew` |

### Facts

| Ansible | pyinfra | Module |
|---------|---------|--------|
| `ansible_facts['os_family']` | `host.get_fact(Kernel)` | `pyinfra.facts.server` |
| `ansible_env.USER` | `host.get_fact(User)` | `pyinfra.facts.server` |
| `ansible_env.HOME` | `host.get_fact(Home)` | `pyinfra.facts.server` |
| `ansible_env.PWD` | Pass `repo_path` parameter | - |
| `ansible_facts['hostname']` | `host.get_fact(Hostname)` | `pyinfra.facts.server` |
| Check file exists (`stat`) | `host.get_fact(File, path)` | `pyinfra.facts.files` |
| Check dir exists | `host.get_fact(Directory, path)` | `pyinfra.facts.files` |
| Check link exists | `host.get_fact(Link, path)` | `pyinfra.facts.files` |

### Conditionals

**Ansible:**
```yaml
- name: Install package
  ansible.builtin.package:
    name: zsh
  when: ansible_facts['os_family'] == "Debian"
```

**pyinfra:**
```python
from pyinfra.facts.server import Kernel

if host.get_fact(Kernel) == "Linux":
    files.package(packages=["zsh"])
```

### Loops

**Ansible:**
```yaml
- name: Link files
  ansible.builtin.file:
    src: "{{ item }}"
    path: ~/.config/{{ item }}
    state: link
  loop:
    - settings.json
    - keybindings.json
```

**pyinfra:**
```python
for item in ["settings.json", "keybindings.json"]:
    files.link(
        name=f"Link {item}",
        path=f"~/.config/{item}",
        target=f"{repo_path}/roles/vscode/files/{item}",
        force=True,
    )
```

## Common Patterns

### Check File Exists Before Action

```python
from pyinfra.facts.files import File

existing = host.get_fact(File, "~/.gitconfig")
if existing:
    server.shell(
        name="Backup existing file",
        commands=["mv ~/.gitconfig ~/.gitconfig.bak"],
    )
```

### Create Directory

```python
files.directory(
    name="Create config directory",
    path="~/.config/app",
    mode="0755",
)
```

### Create Symbolic Link

```python
files.link(
    name="Link config file",
    path="~/.config/app/config",
    target=f"{repo_path}/roles/app/files/config",
    force=True,  # Overwrite existing
)
```

### Template File (Jinja2)

```python
files.template(
    name="Generate config",
    src=f"{repo_path}/roles/app/templates/config.j2",
    dest="~/.config/app/config",
    mode="0644",
    # Template variables
    user="myuser",
    email="user@example.com",
)
```

### Install Package (macOS)

```python
brew.packages(
    packages=["tmux", "neovim"],
)
```

### Clone Git Repository

```python
git.repo(
    name="Clone repository",
    src="https://github.com/user/repo.git",
    dest="~/code/repo",
    pull=True,  # Update if exists
)
```

### Change User Shell

```python
from pyinfra.facts.server import User

username = host.get_fact(User)
server.user(
    name="Change shell to zsh",
    user=username,
    shell="/bin/zsh",
)
```

## deploy.py Pattern

```python
from pyinfra import host
from pyinfra.operations import brew, files
import os

repo_path = os.path.expanduser("~/dotfiles/pyinfra-dots")
home_path = os.path.expanduser("~")

# Import roles
from roles.git import setup as git_setup
from roles.zsh import setup as zsh_setup

# Git
git_setup(
    repo_path=repo_path,
    git_user="enochchau",
    git_email="enoch965@gmail.com",
)

# ZSH
zsh_setup(
    home_path=home_path,
    repo_path=repo_path,
)

# Brew packages
brew.packages(packages=["tmux", "neovim"])

# Brew casks
brew.casks(casks=["ghostty", "rectangle"])
```

## Important Notes

1. **Always use pyinfra facts** - Never use `os.path.exists()` or native Python for file system checks. Use `host.get_fact(File, path)` instead.

2. **Use `host.get_fact()` not `host.fact.get()`** - The correct API is `host.get_fact(FactName, *args)`.

3. **Force links** - Always use `force=True` in `files.link()` to match Ansible's behavior of overwriting existing links.

4. **Git pull** - Use `pull=True` in `git.repo()` to match Ansible's `update: true`.

5. **Modes as strings** - File modes should be strings: `mode="0755"`, `mode="0644"`.

6. **Path expansion** - Use `os.path.expanduser("~")` in deploy.py and pass as parameters to roles.

7. **Conditional imports** - For OS-specific roles, check facts at the top of the role:
   ```python
   from pyinfra.facts.server import Kernel
   
   if host.get_fact(Kernel) != "Darwin":
       return  # Skip macOS-only role
   ```

## Migration Checklist

- [ ] Create `roles/{name}/__init__.py` with `def setup(...)`
- [ ] Create `roles/{name}/files/` for static files
- [ ] Create `roles/{name}/templates/` for Jinja2 templates
- [ ] Copy files from Ansible `roles/{name}/files/`
- [ ] Copy templates from Ansible `roles/{name}/templates/`
- [ ] Convert tasks to pyindra operations
- [ ] Replace Ansible facts with `host.get_fact()`
- [ ] Replace `when:` with Python `if` statements
- [ ] Replace `loop:` with Python `for` loops
- [ ] Add role call to `deploy.py`
- [ ] Test with `pyinfra @local deploy.py`
