---
title: "Learning how to use Nix Flakes"
date: "2025-05-11"
categories: ["automation", "homelab", "nix", "nixos"]
---
# Snowy Spellcraft Manual

Hey there, fellow NixOS enthusiasts! Today I'm excited to guide you through the essentials of working with Nix Flakes. If you've been using Nix for a while but haven't yet dipped your toes into the Flakes ecosystem, you're in for a treat. Flakes bring reproducibility, composability, and improved usability to the already powerful Nix ecosystem.

> Flakes are like **magic spells** for your development environment - once written, they work consistently for everyone, everywhere!

I've been using NixOS for the past few years, and switching to Flakes has been a game-changer for managing my configurations across different machines. Let me share what I've learned along the way!

## What are Flakes? ⛄️

In essence, Flakes are a way to package Nix code with strict dependencies, making it more reproducible and shareable. They solve several pain points in the Nix ecosystem:

- **Reproducibility**: Flakes lock all dependencies, ensuring the same build across different machines
- **Composability**: Easily incorporate other flakes into your own
- **Discoverability**: Standard structure makes it clear what a Flake provides
- **Usability**: Consistent CLI interface for all Flakes

Before we dive into creating our first Flake, make sure you have Nix installed with Flakes enabled. If you're using NixOS, add this to your configuration:

```nix
nix.extraOptions = "experimental-features = nix-command flakes";
```

For non-NixOS users, you can add this to your `~/.config/nix/nix.conf`:

```nix
experimental-features = nix-command flakes
```

## Basic Flake Structure 📁

Every Flake revolves around a `flake.nix` file at the root of your project. Here's the simplest possible Flake:

```nix
{
  description = "My first Nix Flake";
  
  inputs = {};
  
  outputs = { self }: {};
}
```

That's it! This is a valid (but empty) Flake. Let's break down these three essential components:

1. **description**: A human-readable description of your Flake
2. **inputs**: External dependencies your Flake needs
3. **outputs**: What your Flake provides to the world

Now that we understand what Flakes are, let's explore how to interact with them using the `nix flake` command. Whether you're using someone else's Flake or your own, these commands will become part of your daily workflow.

For example, it is possible to initialize a basic flake using the `nix flake init` command.

## Checking what a Flake provides 👀

The `show` command gives you a quick overview of what a Flake offers:

```bash
# Show outputs from a local flake
nix flake show

# Show outputs from a remote flake
nix flake show github:nixos/nixpkgs/nixos-unstable
```

This is incredibly useful to discover what packages, NixOS modules, or development environments a Flake provides. The output might look something like this:

```
github:NixOS/nixpkgs/nixos-unstable
├───checks
│   ├───x86_64-linux
│   │  └───...
├───devShells
│   ├───aarch64-darwin
│   │   └───default: development environment 'nix-shell'
├───packages
│   └───x86_64-linux
│   │  └───...
```

As you can see, this specific Flake provides checks, development shells, programs, and more.

We will leave for another time what each of these categories is, but the output highlights the structured and organized nature of Flakes, making it easier to identify and utilize the resources they provide.

## Pinning dependencies 📌

Flakes use a `flake.lock` file to pin dependencies to specific versions. When you first use a Flake, this file is created automatically.

It is also possible to force this behavior using the following commands:

```bash
# Initialize or update lock file
nix flake lock

# Update all inputs to their latest versions
nix flake update

# Update only specific inputs
nix flake update nixpkgs
```

The lock file is what makes Flakes so reproducible. Even if you run `nix flake` commands months apart, you'll get the exact same results as long as the lock file remains unchanged.

## Building and running packages 📦

In the context of a Flake, `packages` are software artifacts that can be built or executed.

Flakes provide a standardized way to define, build, and run packages across different systems. These packages are self-contained with all their dependencies specified, ensuring they work the same way regardless of where they're used.

Packages are defined under the `outputs.packages.<system>.<name>` attribute. If a Flake provides `packages`, you can build and run them with:

```bash
# Build the default package provided by the local flake
nix build

# Build a specific package provided by the local flake
nix build .#name

# Build a package provided by a remote flake
nix build github:nixos/nixpkgs/nixos-unstable#cowsay

# Run the previous built package
./result/bin/<package>

# Run the default package provided by the flake
nix run

# Run a specific package provided by the flake
nix run .#name

# Run a package provided by a remote flake
nix run github:nixos/nixpkgs/nixos-unstable#cowsay
```

## Using development environments 🛠️

A `devShell` in the context of Nix Flakes is a declarative development environment.

It allows you to define all the tools, dependencies, and environment variables needed for a project in a reproducible way. This ensures that every developer working on the project has the exact same environment, avoiding "it works on my machine" issues.

Development shells are defined under the `outputs.devShells.<system>.<name>` value. If a Flake provides `devShells`, you can use them with:

```bash
# Enter the default shell provided by the local flake
nix develop

# Enter a specific shell provided by the local flake
nix develop .#name

# Enter a shell provided by a remote flake
nix develop github:nixos/nixpkgs/nixos-unstable#default
```

### Managing NixOS with Flakes 🖥️

For NixOS users, Flakes offer a powerful way to manage system configurations:

```bash
# Switch to a system configuration defined in a flake
sudo nixos-rebuild switch --flake .#my-laptop

# Build but don't activate a configuration
sudo nixos-rebuild build --flake .#my-laptop

# Test a configuration in a VM
sudo nixos-rebuild build-vm --flake .#my-laptop
```

## Advanced Usage Tips 🧙‍♂️

Here are some advanced tips for working with Flakes:

1. **Registry shortcuts**: Add frequently used Flakes to your registry with `nix registry add my-flake github:user/repo`
2. **Flake references**: Use flake references like `nixpkgs#output` to directly refer to outputs.
3. **Evaluating attributes**: Use `nix eval` to inspect specific attributes of a Flake package, as the version.
4. **Temporary overrides**: Use `--override-input` to temporarily use a different version of a dependency

For example, to temporarily use a different input:

```bash
nix build --override-input nixpkgs github:NixOS/nixpkgs/nixos-22.11
```

## Creating Your Own Flakes 📝

While I've focused on how to use Flakes here, creating your own Flakes is a topic that deserves its own dedicated posts. If you're interested in learning more about writing your own Flakes, check out these upcoming articles:

- [Creating Development Environment Flakes](/posts/flake-dev-environments) (coming soon)
- [Building Packages with Flakes](/posts/flake-packages) (coming soon)
- [Managing NixOS Configurations with Flakes](/posts/flake-nixos-config) (coming soon)
- [Advanced Flake Techniques](/posts/advanced-flakes) (coming soon)

## Resources 📚

Here are some fantastic resources that helped me understand Flakes:

- [Nix Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [Zero to Nix](https://zero-to-nix.com/)
- [Flake Schema Reference](https://nixos.wiki/wiki/Flakes#Flake_schema)
- [Practical Nix Flakes](https://serokell.io/blog/practical-nix-flakes)

Happy Flaking! 🎉