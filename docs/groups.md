# Groups

Groups allow you to organize features into hierarchical structures, combining multiple feature classes into a unified interface.

## Defining Groups

Use the `group` method to include other feature classes:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User, option: true

  feature :passage, description: "User onboarding passage"

  group BillingFeature, description: "Billing functionality"
  group PaymentSystemFeature, description: "Payment system functionality"
end
```

Now when you call actions on `User::OnboardingFeature`, they will operate on:
1. The direct feature: `:user_onboarding_passage`
2. All features from `BillingFeature`
3. All features from `PaymentSystemFeature`

## Group Descriptions

Add descriptions to document what each group provides:

```ruby
class MainFeature < ApplicationFeature
  prefix :main

  feature :core, description: "Core functionality"

  group BillingFeature, description: "Billing and invoicing features"
  group NotificationsFeature, description: "Email and SMS notifications"
  group AnalyticsFeature, description: "Usage analytics and tracking"
end
```

Access group descriptions via `.info`:

```ruby
MainFeature.info.groups.all
# => [
#      { group_class: BillingFeature, description: "Billing and invoicing features" },
#      { group_class: NotificationsFeature, description: "Email and SMS notifications" },
#      { group_class: AnalyticsFeature, description: "Usage analytics and tracking" }
#    ]
```

## Nested Group Structure

Groups can be nested to any depth:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  feature :passage

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api
  feature :webhooks

  group PaymentSystemFeature
end

class PaymentSystemFeature < ApplicationFeature
  prefix :payment_system

  feature :stripe
  feature :paypal
end
```

This creates a hierarchy:
```
User::OnboardingFeature
├── :user_onboarding_passage
└── BillingFeature
    ├── :billing_api
    ├── :billing_webhooks
    └── PaymentSystemFeature
        ├── :payment_system_stripe
        └── :payment_system_paypal
```

Calling `User::OnboardingFeature.enabled?(user: user)` checks **all five features**.

## Passing Resources to Groups

By default, resources are not passed to nested groups. Use `nested: true` to pass resources down the hierarchy:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User, option: true, nested: true

  feature :passage

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  prefix :billing

  resource :user, type: User, option: true

  feature :api
end

# The :user resource is passed to both classes
User::OnboardingFeature.enabled?(user: user)
# Checks: Flipper.enabled?(:user_onboarding_passage, user)
#         Flipper.enabled?(:billing_api, user)
```

See [Resources](./resources.md) for detailed information on the `nested` option.

## Group Inheritance Patterns

### Shared Base Class

All groups should inherit from the same base class to ensure consistent behavior:

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

class BillingFeature < ApplicationFeature
  # Inherits actions from ApplicationFeature
end

class PaymentSystemFeature < ApplicationFeature
  # Inherits actions from ApplicationFeature
end

class MainFeature < ApplicationFeature
  group BillingFeature
  group PaymentSystemFeature
  # All groups share the same action definitions
end
```

### Different Base Classes

You can mix groups with different base classes, but they must define compatible actions:

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

class CustomFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| CustomFeatureSystem.enabled?(feature, *options.values) }
  end

  action :disabled?, web: :regular do |features:, **options|
    features.any? { |feature| !CustomFeatureSystem.enabled?(feature, *options.values) }
  end

  action :enable, web: :enable do |features:, **options|
    features.all? { |feature| CustomFeatureSystem.enable(feature, *options.values) }
  end

  action :disable, web: :disable do |features:, **options|
    features.all? { |feature| CustomFeatureSystem.disable(feature, *options.values) }
  end

  action :add, web: :regular do |features:, **options|
    features.all? { |feature| CustomFeatureSystem.add(feature, *options.values) }
  end
end

class MainFeature < ApplicationFeature
  group BillingFeature # Uses Flipper
  group CustomFeature  # Uses CustomFeatureSystem
end

# Both must respond to the same action names
MainFeature.enabled?(user: user)
```

## Accessing Group Information

### Direct Groups

Get groups defined in the current class:

```ruby
MainFeature.info.groups.all
# Returns only groups defined directly in MainFeature
```

### Complete Tree

Get all features including nested groups:

```ruby
MainFeature.info.tree.features
# Direct features only

MainFeature.info.tree.groups
# All features from all nested groups (flattened)
```

See [Info and Introspection](./info-and-introspection.md) for complete details.

## Use Cases for Groups

### Feature Bundling

Group related features that should be enabled/disabled together:

```ruby
class PremiumFeature < ApplicationFeature
  prefix :premium

  feature :advanced_analytics
  feature :priority_support
  feature :custom_branding

  group IntegrationsFeature
  group ExportFeature
end

# Enable all premium features at once
PremiumFeature.enable(user: user)
```

### Progressive Feature Rollout

Create hierarchies for staged rollouts:

```ruby
class ExperimentalFeature < ApplicationFeature
  prefix :experimental

  feature :beta_ui

  group AlphaFeature # More experimental nested features
end

# Enable outer feature without enabling inner experimental features
ExperimentalFeature.info.features.all # Just :beta_ui
```

### Domain Organization

Organize features by domain:

```ruby
class User::Feature < ApplicationFeature
  group User::OnboardingFeature
  group User::ProfileFeature
  group User::NotificationsFeature
end

# Manage all user-related features together
User::Feature.enabled?(user: user)
```

## Next Steps

- Learn about [Resources](./resources.md) and the `nested: true` option
- Review [Actions](./actions.md) to understand how actions cascade through groups
- See [Examples](./examples.md) for real-world group patterns
