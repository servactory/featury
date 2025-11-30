# Working with Features

Featury provides two primary ways to interact with features: direct method calls and the `.with()` method. Both approaches support the same actions and produce the same results.

## Direct Method Calls

Call actions directly on the feature class:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User, option: true

  feature :passage
end

user = User.find(1)

User::OnboardingFeature.enabled?(user: user)  # => true
User::OnboardingFeature.enable(user: user)    # => true
User::OnboardingFeature.disable(user: user)   # => true
```

This approach is concise and works well for one-off checks or actions.

## Using .with()

The `.with()` method creates a feature instance with resources bound:

```ruby
user = User.find(1)

feature = User::OnboardingFeature.with(user: user)

feature.enabled? # => true
feature.enable   # => true
feature.disable  # => true
```

### When to Use .with()

**Multiple Operations on the Same Resources:**

```ruby
feature = User::OnboardingFeature.with(user: user)

if feature.disabled?
  feature.enable
  NotificationService.notify(user, "Onboarding enabled!")
end
```

**Passing Feature Instances:**

```ruby
def enable_feature_for_user(feature)
  return if feature.enabled?

  feature.enable
  log_feature_change(feature)
end

enable_feature_for_user(User::OnboardingFeature.with(user: user))
```

**Cleaner Syntax:**

```ruby
# Without .with()
if User::OnboardingFeature.enabled?(user: user)
  User::OnboardingFeature.disable(user: user)
end

# With .with()
feature = User::OnboardingFeature.with(user: user)
feature.disable if feature.enabled?
```

## Passing Resources

Resources are passed as keyword arguments:

### Single Resource

```ruby
class User::ProfileFeature < ApplicationFeature
  resource :user, type: User, option: true

  feature :editing
end

User::ProfileFeature.enabled?(user: user)
# Or
User::ProfileFeature.with(user: user).enabled?
```

### Multiple Resources

```ruby
class OrganizationFeature < ApplicationFeature
  resource :organization, type: Organization, option: true
  resource :user, type: User, option: true

  feature :admin_panel
end

OrganizationFeature.enabled?(organization: org, user: user)
# Or
OrganizationFeature.with(organization: org, user: user).enabled?
```

### Optional Resources

```ruby
class ExperimentalFeature < ApplicationFeature
  resource :user, type: User, option: true, required: false

  feature :beta_ui
end

# Without user (global check)
ExperimentalFeature.enabled?

# With user (user-specific check)
ExperimentalFeature.enabled?(user: user)

# Using .with()
ExperimentalFeature.with(user: user).enabled?
ExperimentalFeature.with.enabled? # No resources
```

## Result Aggregation

Actions operate on **all features** in a class (including nested groups) and aggregate results based on your action definition.

### All Features Must Match

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

class User::OnboardingFeature < ApplicationFeature
  feature :passage
  feature :completion

  group BillingFeature # Contains :billing_api
end

# Returns true only if ALL three features are enabled:
# - :user_onboarding_passage
# - :user_onboarding_completion
# - :billing_api
User::OnboardingFeature.enabled?(user: user)
```

### Any Feature Can Match

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end

  action :disabled?, web: :regular do |features:, **options|
    features.any? { |feature| !Flipper.enabled?(feature, *options.values) }
  end

  action :any_enabled?, web: :enabled? do |features:, **options|
    features.any? { |feature| Flipper.enabled?(feature, *options.values) }
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

# Returns true if ANY feature is enabled
User::OnboardingFeature.any_enabled?(user: user)
```

### Negation (Disabled Check)

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

# Returns true if ANY feature is disabled
User::OnboardingFeature.disabled?(user: user)
```

### Custom Aggregation

```ruby
class ApplicationFeature < Featury::Base
  action :status, web: :regular do |features:, **options|
    features.map do |feature|
      { feature: feature, enabled: Flipper.enabled?(feature, *options.values) }
    end
  end
end

User::OnboardingFeature.status(user: user)
# => [
#      { feature: :user_onboarding_passage, enabled: true },
#      { feature: :user_onboarding_completion, enabled: false },
#      { feature: :billing_api, enabled: true }
#    ]
```

## Working with Nested Groups

When calling actions on a parent feature, they cascade through all nested groups:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true

  feature :passage

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true

  feature :api
  feature :webhooks
end

# This checks THREE features:
# 1. :user_onboarding_passage
# 2. :billing_api
# 3. :billing_webhooks
User::OnboardingFeature.enabled?(user: user)
```

The `nested: true` option ensures resources are passed to `BillingFeature`. See [Resources](./resources.md) for details.

## Feature-Specific Actions

To work with individual features, create dedicated classes:

```ruby
class BillingAPIFeature < ApplicationFeature
  prefix :billing

  resource :user, type: User, option: true

  feature :api
end

class BillingWebhooksFeature < ApplicationFeature
  prefix :billing

  resource :user, type: User, option: true

  feature :webhooks
end

# Control each feature independently
BillingAPIFeature.enable(user: user)
BillingWebhooksFeature.disable(user: user)
```

Or interact with your feature flag system directly:

```ruby
Flipper.enable(:billing_api, user)
Flipper.disable(:billing_webhooks, user)
```

## Conditional Execution

Features can have conditions that guard action execution:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage
end

# If user.onboarding_awaiting? is false:
User::OnboardingFeature.enabled?(user: user) # => false (condition failed)

# If user.onboarding_awaiting? is true:
User::OnboardingFeature.enabled?(user: user) # => (checks Flipper)
```

See [Conditions](./conditions.md) for complete details.

## Common Patterns

### Enable/Disable Toggle

```ruby
feature = User::OnboardingFeature.with(user: user)

if feature.enabled?
  feature.disable
else
  feature.enable
end
```

### Conditional Enable

```ruby
feature = User::OnboardingFeature.with(user: user)

feature.enable if user.premium?
```

### Status Check with Action

```ruby
feature = BillingFeature.with(user: user)

if feature.disabled?
  feature.enable
  NotificationService.notify(user, "Billing features enabled")
end
```

### Bulk Operations

```ruby
users = User.where(premium: true)

users.each do |user|
  PremiumFeature.with(user: user).enable
end
```

### Feature Instance as Parameter

```ruby
class FeatureManager
  def enable_and_log(feature)
    return if feature.enabled?

    feature.enable
    Rails.logger.info("Enabled feature: #{feature.class.name}")
  end
end

manager = FeatureManager.new
manager.enable_and_log(User::OnboardingFeature.with(user: user))
manager.enable_and_log(BillingFeature.with(user: user))
```

## Error Handling

### Missing Resources

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true
end

# Raises Servactory validation error
User::OnboardingFeature.enabled?
# => Error: :user is required

# Correct usage
User::OnboardingFeature.enabled?(user: user)
```

### Invalid Resource Types

```ruby
# Raises Servactory validation error
User::OnboardingFeature.enabled?(user: "not a user")
# => Error: :user must be of type User

# Correct usage
User::OnboardingFeature.enabled?(user: User.new)
```

### Handling Exceptions

```ruby
begin
  feature = User::OnboardingFeature.with(user: user)
  feature.enable
rescue Servactory::Errors::InputError => e
  Rails.logger.error("Invalid feature parameters: #{e.message}")
rescue StandardError => e
  Rails.logger.error("Feature error: #{e.message}")
end
```

## Testing

### RSpec Examples

```ruby
RSpec.describe User::OnboardingFeature do
  let(:user) { create(:user) }

  describe ".enabled?" do
    it "returns true when all features are enabled" do
      allow(Flipper).to receive(:enabled?).and_return(true)
      expect(User::OnboardingFeature.enabled?(user: user)).to be(true)
    end
  end

  describe ".with" do
    it "creates a feature instance" do
      feature = User::OnboardingFeature.with(user: user)
      expect(feature).to respond_to(:enabled?)
    end
  end
end
```

## Next Steps

- Learn about [Actions](./actions.md) and aggregation logic
- Review [Resources](./resources.md) for parameter handling
- Explore [Conditions](./conditions.md) for conditional execution
- See [Examples](./examples.md) for real-world usage patterns
