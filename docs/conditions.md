# Conditions

Conditions are lambda-based rules that determine when features should be evaluated. They provide a way to add business logic that controls whether feature actions should execute.

## Defining Conditions

Use the `condition` method with a lambda:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage
end
```

The condition lambda receives a `resources:` parameter that provides access to all resources defined in the feature class.

## Condition Parameters

### resources:

An object that provides access to all resources via method calls:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :account, type: Account, option: true

  condition lambda { |resources:|
    resources.user.active? && resources.account.premium?
  }
end
```

Access resources by name:
- `resources.user` — Returns the User instance
- `resources.account` — Returns the Account instance

## How Conditions Work

When a condition is defined, it acts as a guard for feature actions:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage

  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end
end

# If user.onboarding_awaiting? returns false:
User::OnboardingFeature.enabled?(user: user)
# The action is not executed, returns false immediately

# If user.onboarding_awaiting? returns true:
User::OnboardingFeature.enabled?(user: user)
# The action executes normally
```

## Resource-Based Conditions

### Single Resource

```ruby
class User::ProfileEditingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.email_verified? }

  feature :profile_editing
end
```

### Multiple Resources

```ruby
class OrganizationFeature < ApplicationFeature
  resource :organization, type: Organization, option: true
  resource :user, type: User, option: true

  condition lambda { |resources:|
    resources.organization.active? && resources.user.admin?
  }

  feature :admin_panel
end
```

### Optional Resources

When using `required: false`, check for resource presence:

```ruby
class AnalyticsFeature < ApplicationFeature
  resource :user, type: User, option: true, required: false

  condition lambda { |resources:|
    # Check if user is provided before accessing it
    resources.user.nil? || resources.user.analytics_enabled?
  }

  feature :tracking
end
```

## Complex Conditions

### Method Chains

```ruby
class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition lambda { |resources:|
    resources.user.subscription&.active? &&
      resources.user.subscription&.plan&.premium?
  }

  feature :api
end
```

### Time-Based Conditions

```ruby
class SeasonalFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition lambda { |resources:|
    Date.current.month.in?([11, 12]) && resources.user.active?
  }

  feature :holiday_theme
end
```

### External Service Checks

```ruby
class ExperimentalFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition lambda { |resources:|
    ExperimentService.user_enrolled?(resources.user.id)
  }

  feature :beta_ui
end
```

## Conditions vs. Feature Flags

Conditions and feature flags serve different purposes:

**Conditions** — Business logic that determines if a feature should be evaluated

```ruby
condition ->(resources:) { resources.user.onboarding_awaiting? }
# "Should we even check the feature flag?"
```

**Feature Flags** — Configuration that enables/disables features

```ruby
action :enabled? do |features:, **options|
  features.all? { |feature| Flipper.enabled?(feature, *options.values) }
end
# "Is the feature flag turned on?"
```

### Example: Combined Usage

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  # Condition: Only proceed if user is in onboarding state
  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage

  # Feature flag: Check if feature is enabled for this user
  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end
end

# Flow:
# 1. Check condition: Is user.onboarding_awaiting? true?
#    - If false: Return false immediately
#    - If true: Continue to step 2
# 2. Check feature flag: Is Flipper.enabled?(:user_onboarding_passage, user) true?
#    - Return the result
```

## Conditions with Groups

Conditions apply to the current class and do not cascade to nested groups:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true

  # This class has NO condition
  # It will always execute its actions

  feature :api
end

# The condition only applies to :user_onboarding_passage
# BillingFeature actions always execute
User::OnboardingFeature.enabled?(user: user)
```

To add conditions to nested groups, define them in each class:

```ruby
class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.billing_enabled? }

  feature :api
end
```

## Condition Patterns

### Permission Check

```ruby
class AdminFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.admin? }

  feature :admin_panel
end
```

### Subscription Tier

```ruby
class PremiumFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition lambda { |resources:|
    resources.user.subscription&.tier&.in?(["premium", "enterprise"])
  }

  feature :advanced_analytics
end
```

### State Machine

```ruby
class OnboardingStepFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition lambda { |resources:|
    resources.user.onboarding_state == "step_2"
  }

  feature :step_2_completion
end
```

### Regional Availability

```ruby
class RegionalFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition lambda { |resources:|
    resources.user.country_code.in?(["US", "CA", "GB"])
  }

  feature :regional_payment_method
end
```

## Testing Conditions

When testing, verify that conditions control action execution:

```ruby
RSpec.describe User::OnboardingFeature do
  let(:user) { User.new }

  context "when user is awaiting onboarding" do
    before { allow(user).to receive(:onboarding_awaiting?).and_return(true) }

    it "checks the feature flag" do
      expect(Flipper).to receive(:enabled?).with(:user_onboarding_passage, user)
      User::OnboardingFeature.enabled?(user: user)
    end
  end

  context "when user is not awaiting onboarding" do
    before { allow(user).to receive(:onboarding_awaiting?).and_return(false) }

    it "returns false without checking feature flag" do
      expect(Flipper).not_to receive(:enabled?)
      expect(User::OnboardingFeature.enabled?(user: user)).to be(false)
    end
  end
end
```

## Next Steps

- Learn about [Actions](./actions.md) and how conditions affect action execution
- Review [Resources](./resources.md) for accessing resource data in conditions
- See [Examples](./examples.md) for real-world condition patterns
- Explore [Best Practices](./best-practices.md) for condition design
