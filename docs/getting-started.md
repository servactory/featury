# Getting Started

This guide will walk you through installing Featury and creating your first feature flag management system.

## Installation

Add Featury to your Gemfile:

```ruby
gem "featury"
```

Then run:

```bash
bundle install
```

## Creating ApplicationFeature

The `ApplicationFeature` base class defines how your features interact with your feature flag system. This is where you define actions and callbacks that will be inherited by all feature classes.

### Basic Setup

Create a base class that inherits from `Featury::Base`:

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
end
```

### Understanding Actions

Each action receives two parameters:

- `features:` — Array of feature flag names (symbols)
- `**options` — Hash of resources passed as options (e.g., `{ user: user_instance }`)

The action block should return a result based on your feature flag system's API. In the example above:

- `enabled?` checks if **all** features are enabled
- `enable` enables **all** features
- `disable` disables **all** features

See [Actions](./actions.md) for detailed information about action parameters and behavior.

## Your First Feature

Create a feature class that inherits from `ApplicationFeature`:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User, option: true

  feature :passage, description: "User onboarding passage"
end
```

### Breaking It Down

**prefix :user_onboarding** — All features in this class will be prefixed with `user_onboarding_`

**resource :user** — Defines a required parameter of type `User` that will be passed to actions as an option

**feature :passage** — Creates a feature flag named `:user_onboarding_passage`

## Basic Usage

Now you can use your feature:

```ruby
user = User.find(1)

# Check if enabled
User::OnboardingFeature.enabled?(user: user)
# => true

# Enable the feature
User::OnboardingFeature.enable(user: user)
# => true

# Disable the feature
User::OnboardingFeature.disable(user: user)
# => true
```

### Using .with()

For cleaner syntax, use the `.with()` method:

```ruby
feature = User::OnboardingFeature.with(user: user)

feature.enabled? # => true
feature.enable   # => true
feature.disable  # => true
```

## Next Steps

- Learn about [Features](./features.md) and naming conventions
- Explore [Groups](./groups.md) for organizing related features
- Add [Resources](./resources.md) for type-safe parameters
- Define [Conditions](./conditions.md) for conditional feature activation
- Review [Examples](./examples.md) for real-world scenarios
