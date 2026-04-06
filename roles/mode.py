"""Shared deployment mode helpers."""

from __future__ import annotations

import os

from pyinfra import host
from pyinfra.facts.server import Kernel

from facts.system_id import SystemId

from .constants import KERNEL_LINUX


def is_nixos() -> bool:
    """
    Return True when the target host is NixOS.

    We use /etc/os-release via a custom fact so the detection works without
    relying on package-manager-specific commands.
    """
    if host.get_fact(Kernel) != KERNEL_LINUX:
        return False

    return host.get_fact(SystemId) == "nixos"


def is_symlink_only_mode() -> bool:
    """
    Return True when deploys should avoid downloads and external installs.

    The mode auto-enables on NixOS and can also be forced with
    DOTFILES_MODE=symlink-only.
    """
    mode = os.environ.get("DOTFILES_MODE", "").strip().lower()
    if mode == "symlink-only":
        return True

    return is_nixos()
