# Featury Documentation

Welcome to the comprehensive documentation for Featury, a flexible Ruby gem for managing feature flags with powerful organization capabilities.

## Table of Contents

### Getting Started

- [Getting Started](./getting-started.md) - Installation, setup, and your first feature

### Core Concepts

- [Features](./features.md) - Defining features with prefixes and descriptions
- [Groups](./groups.md) - Organizing features into hierarchical groups
- [Actions](./actions.md) - Defining custom actions for feature management
- [Resources](./resources.md) - Type-safe resource definitions with Servactory
- [Conditions](./conditions.md) - Adding conditional logic to features

### Usage

- [Working with Features](./working-with-features.md) - Practical usage patterns and examples
- [Info and Introspection](./info-and-introspection.md) - Inspecting features, actions, and resources

### Integration

- [Integration](./integration.md) - Backend storage implementations (Flipper, Redis, Database, HTTP APIs)

### Reference

- [Examples](./examples.md) - Real-world examples and use cases
- [Best Practices](./best-practices.md) - Recommended patterns and conventions

## What is Featury?

Featury is a feature flag management library that provides:

- **Unified Interface**: Manage multiple feature flags through a single class
- **Flexible Backend**: Works with Flipper, Redis, databases, HTTP APIs, or any custom solution
- **Hierarchical Organization**: Group related features with automatic prefix management
- **Type Safety**: Built on Servactory for robust resource validation
- **Lifecycle Hooks**: Before/after callbacks with customizable scope
- **Rich Introspection**: Complete visibility into your feature configuration

## Quick Links

- [GitHub Repository](https://github.com/servactory/featury)
- [RubyGems](https://rubygems.org/gems/featury)
- [Changelog](https://github.com/servactory/featury/blob/main/CHANGELOG.md)
- [Contributing Guide](https://github.com/servactory/featury/blob/main/CONTRIBUTING.md)

## Architecture Overview

Featury is built around several key concepts:

1. **Base Class**: `ApplicationFeature` defines how features interact with your storage backend
2. **Feature Classes**: Inherit from `ApplicationFeature` and define specific features
3. **Actions**: Custom methods that operate on feature collections (e.g., `enabled?`, `enable`, `disable`)
4. **Resources**: Type-safe inputs validated through Servactory
5. **Groups**: Nested feature hierarchies for organization
6. **Conditions**: Lambda-based validation logic

## Philosophy

Featury follows these design principles:

- **Backend Agnostic**: Actions receive feature names and options - you decide how to store them
- **Convention over Configuration**: Automatic prefix generation from class names
- **Composability**: Combine features, groups, resources, and conditions
- **Transparency**: Full introspection through the `info` API
- **Type Safety**: Leverage Servactory's resource validation

## Getting Help

- Read through the documentation in order for a complete understanding
- Check [Examples](./examples.md) for real-world use cases
- Review [Best Practices](./best-practices.md) for recommended patterns
- Open an issue on [GitHub](https://github.com/servactory/featury/issues) for bugs or questions

## Contributing

We welcome contributions! Please see our [Contributing Guide](https://github.com/servactory/featury/blob/main/CONTRIBUTING.md) for details.
