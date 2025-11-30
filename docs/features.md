# Features

Features are the core building blocks of Featury. Each feature represents an individual feature flag that can be enabled, disabled, or checked for status.

## Defining Features

Use the `feature` method to define a feature flag:

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api
  feature :webhooks
  feature :invoicing
end
```

This creates three feature flags:
- `:billing_api`
- `:billing_webhooks`
- `:billing_invoicing`

## Feature Naming with Prefixes

The `prefix` method defines a namespace for all features in the class:

```ruby
class PaymentSystemFeature < ApplicationFeature
  prefix :payment_system

  feature :api      # => :payment_system_api
  feature :webhooks # => :payment_system_webhooks
end
```

### Naming Conventions

- Prefixes should use underscores: `user_onboarding`, `payment_system`
- Feature names should be concise: `api`, `webhooks`, `passage`
- Combined names use single underscores: `:user_onboarding_passage`

## Feature Descriptions

Add descriptions to document what each feature does:

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "External billing API integration"
  feature :webhooks, description: "Webhook endpoints for billing events"
  feature :invoicing, description: "Automated invoice generation"
end
```

Descriptions are preserved and accessible via the `.info` method:

```ruby
BillingFeature.info.features.all
# => [
#      { name: :billing_api, description: "External billing API integration" },
#      { name: :billing_webhooks, description: "Webhook endpoints for billing events" },
#      { name: :billing_invoicing, description: "Automated invoice generation" }
#    ]
```

## Multiple Features in One Class

You can define multiple related features in a single class:

```ruby
class User::AccountFeature < ApplicationFeature
  prefix :user_account

  resource :user, type: User, option: true

  feature :profile_editing, description: "Allow users to edit their profiles"
  feature :avatar_upload, description: "Allow users to upload avatars"
  feature :email_change, description: "Allow users to change their email"
  feature :password_reset, description: "Enable password reset functionality"
end
```

When you call actions on this class, they will operate on **all four features**:

```ruby
User::AccountFeature.enabled?(user: user)
# Checks if ALL four features are enabled for this user

User::AccountFeature.enable(user: user)
# Enables ALL four features for this user
```

## Feature Aggregation Logic

By default, Featury uses **all-must-match** logic:

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
    # Returns true only if ALL features are enabled
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

You can customize this behavior in your action definitions. See [Actions](./actions.md) for details.

## Working with Individual Features

To work with individual features, create separate classes:

```ruby
class BillingAPIFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "Billing API"
end

class BillingWebhooksFeature < ApplicationFeature
  prefix :billing

  feature :webhooks, description: "Billing webhooks"
end

# Now you can control them independently
BillingAPIFeature.enable(user: user)
BillingWebhooksFeature.disable(user: user)
```

Or use your feature flag system directly for granular control:

```ruby
Flipper.enable(:billing_api, user)
Flipper.disable(:billing_webhooks, user)
```

## Feature Tree

Access all features including nested groups via `.info.tree`:

```ruby
class MainFeature < ApplicationFeature
  prefix :main

  feature :alpha
  feature :beta

  group SubFeature, description: "Sub-features"
end

class SubFeature < ApplicationFeature
  prefix :sub

  feature :gamma
end

MainFeature.info.tree.features
# Direct features: [:main_alpha, :main_beta]

MainFeature.info.tree.groups
# Features from nested groups: [:sub_gamma]
```

See [Info and Introspection](./info-and-introspection.md) for complete details on the info API.

## Next Steps

- Learn about [Groups](./groups.md) for organizing features hierarchically
- Add [Resources](./resources.md) for type-safe parameters
- Define [Conditions](./conditions.md) for conditional feature activation
- See [Examples](./examples.md) for real-world feature definitions
