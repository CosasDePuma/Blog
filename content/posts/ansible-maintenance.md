---
title: "Automating package maintenance with Ansible"
date: "2025-01-30"
categories: ["ansible", "automation", "devops", "linux"]
---

Hey there fellow sysadmins! 👋 I've been playing with Ansible to keep my Linux servers tidy and up-to-date. I thought that an interesting idea to start with could be to keep the package managers clean and up to date using Ansible.

## What are we building? 👷🏼

The main objective will be to create tasks in Ansible to handle the main operating system package manager, regardless of which one it is.

Let's dive into the code!

## Ansible tasks 🧑🏻‍💻

We want to keep the package manager clean and the packages updated to the latest version available. Luckily, Ansible has several pre-built modules for this, such as `apk`, `apt` and `dnf` (cool, right?).

In addition, Ansible has a _magic variable_ called `ansible_pkg_mgr` that indicates which is the main package manager inside the system, so we can execute the specific tasks for each system.

This would be the final result:

```yaml
- name: "Update and clean APK"
  when: "ansible_pkg_mgr == 'apk'"
  ansible.builtin.apk:
    available: true
    update_cache: true
    upgrade: true

- name: "Update and clean APT"
  when: "ansible_pkg_mgr == 'apt'"
  ansible.builtin.apt:
    autoclean: true
    autoremove: true
    cache_valid_time: 3600
    purge: true
    update_cache: true
    upgrade: true

- name: "Update and clean DNF"
  when: "ansible_pkg_mgr == 'dnf'"
  block:
    - name: "Update DNF packages"
      ansible.builtin.dnf:
        name: "*"
        state: "latest"
        update_cache: true
        update_only: true

    - name: "Autoremove DNF packages"
      ansible.builtin.dnf:
        autoremove: true
```

## Important details 🧑🏻‍🏫

Here are some awesome things about this tasks:

- They're idempotent (safe to run multiple times).
- Works across different Linux distributions.

But there are a few _"not so cool"_ things too:

- Not 100% tested.
- They may not work on **all** Linux distributions.
- They don't handle all the possible package managers.
- Surely there's a better way to do this!
