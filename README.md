<p align="center">
  <a href="https://servactory.com" target="_blank">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/servactory/featury/main/.github/logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/servactory/featury/main/.github/logo-light.svg">
      <img alt="Featury" src="https://raw.githubusercontent.com/servactory/featury/main/.github/logo-light.svg" width="350" height="70" style="max-width: 100%;">
    </picture>
  </a>
</p>

<p align="center">
  <a href="https://rubygems.org/gems/featury"><img src="https://img.shields.io/gem/v/featury?logo=rubygems&logoColor=fff" alt="Gem version"></a>
  <a href="https://github.com/servactory/featury/releases"><img src="https://img.shields.io/github/release-date/servactory/featury" alt="Release Date"></a>
</p>

## Documentation

Complete documentation is available in the [docs](./docs) directory:

- [Getting Started](./docs/getting-started.md)
- [Features](./docs/features.md)
- [Groups](./docs/groups.md)
- [Actions](./docs/actions.md)
- [Resources](./docs/resources.md)
- [Conditions](./docs/conditions.md)
- [Working with Features](./docs/working-with-features.md)
- [Info and Introspection](./docs/info-and-introspection.md)
- [Integration](./docs/integration.md)
- [Examples](./docs/examples.md)
- [Best Practices](./docs/best-practices.md)

## Why Featury?

**Unified Feature Management** — Group and manage multiple feature flags through a single interface with automatic prefix handling

**Flexible Integration** — Works with any backend: Flipper, Redis, databases, HTTP APIs, or custom solutions

**Powerful Organization** — Organize features with prefixes, groups, and nested hierarchies for scalable feature management

**Rich Introspection** — Full visibility into features, actions, and resources through the comprehensive info API

**Lifecycle Hooks** — Before/after callbacks for actions with customizable scope and full context access

**Type-Safe Resources** — Built on Servactory for robust resource validation, type checking, and automatic coercion

## Quick Start

### Installation

Add Featury to your Gemfile:

```ruby
gem "featury"
```

### ApplicationFeature

Create a base class that defines how features interact with your feature flag system:

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end

  action :disabled?, web: :regular do |features:, **options|
    features.any? { |feature| !Flipper.enabled?(feature, *options.values) }
  end

  action :enable, web: :enable do |features:, **options|
    features.all? { |feature| Flipper.enable(feature, *options.values) }
  end

  action :disable, web: :disable do |features:, **options|
    features.all? { |feature| Flipper.disable(feature, *options.values) }
  end

  action :add, web: :regular do |features:, **options|
    features.all? { |feature| Flipper.add(feature, *options.values) }
  end

  before do |action:, features:|
    Slack::API::Notify.call!(action:, features:)
  end

  after :enabled?, :disabled? do |action:, features:|
    Slack::API::Notify.call!(action:, features:)
  end
end
```

### Feature Definitions

Define features with prefixes, resources, conditions, and groups:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage, description: "User onboarding passage feature" # => :user_onboarding_passage

  group BillingFeature, description: "Billing functionality group"
  group PaymentSystemFeature, description: "Payment system functionality group"
end
```

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "Billing API feature"        # => :billing_api
  feature :webhooks, description: "Billing webhooks feature"    # => :billing_webhooks
end
```

```ruby
class PaymentSystemFeature < ApplicationFeature
  prefix :payment_system

  feature :api, description: "Payment system API feature"      # => :payment_system_api
  feature :webhooks, description: "Payment system webhooks feature"  # => :payment_system_webhooks
end
```

### Usage

```ruby
# Direct method calls
User::OnboardingFeature.enabled?(user:) # => true
User::OnboardingFeature.enable(user:)   # => true
User::OnboardingFeature.disable(user:)  # => true

# Using .with() method
feature = User::OnboardingFeature.with(user:)
feature.enabled? # => true
feature.enable   # => true
feature.disable  # => true
```

## Contributing

This project is intended to be a safe, welcoming space for collaboration.
Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
We recommend reading the [contributing guide](./CONTRIBUTING.md) as well.

## License

Featury is available as open source under the terms of the [MIT License](./LICENSE).
