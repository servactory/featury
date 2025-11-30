# Best Practices

Recommended patterns and conventions for building maintainable feature flag systems with Featury.

## Naming Conventions

### Prefixes

Use descriptive, lowercase prefixes with underscores:

```ruby
# Good
prefix :user_onboarding
prefix :billing_system
prefix :payment_gateway

# Avoid
prefix :uo
prefix :BillingSystem
prefix :payment_gateway_integration_system
```

**Guidelines:**
- 2-3 words maximum
- Describes the feature domain
- Uses underscores, not hyphens or camelCase

### Features

Use short, descriptive feature names:

```ruby
# Good
feature :api
feature :webhooks
feature :passage
feature :email_notifications

# Avoid
feature :api_integration
feature :webhook_endpoint_receiver
feature :p
```

**Guidelines:**
- 1-2 words preferred
- Describes the specific capability
- Combined with prefix should be clear: `:billing_api`, `:user_onboarding_passage`

### Class Names

Follow Rails/Ruby conventions:

```ruby
# Good
class User::OnboardingFeature < ApplicationFeature
class BillingFeature < ApplicationFeature
class PaymentSystemFeature < ApplicationFeature

# Avoid
class UserOnboarding < ApplicationFeature
class Billing_Feature < ApplicationFeature
class PaymentSystem < ApplicationFeature
```

**Guidelines:**
- Use modules for namespacing (`User::`, `Admin::`)
- Always suffix with `Feature`
- Use descriptive names that reflect the domain

## Resource Organization

### Required vs. Optional

Be explicit about resource requirements:

```ruby
# Good - Clear about requirements
class User::ProfileFeature < ApplicationFeature
  resource :user, type: User, option: true                    # Required
  resource :avatar, type: String, option: true, required: false # Optional
end

# Avoid - Ambiguous
class User::ProfileFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :avatar, type: String  # Is this required?
end
```

### option: true Usage

Only use `option: true` when the resource should be passed to the feature flag system:

```ruby
# Good - User is passed to Flipper
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end
end

# Good - Metadata is validated but not passed to Flipper
class AnalyticsFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :event_metadata, type: Hash  # Only for validation
end

# Avoid - Everything as option when not needed
class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :invoice_id, type: String, option: true  # Not needed in Flipper
  resource :amount, type: Integer, option: true     # Not needed in Flipper
end
```

### nested: true Pattern

Use `nested: true` when resources should flow to nested groups:

```ruby
# Good - Explicit nesting
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true
end

# Avoid - Missing nested when required
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true  # BillingFeature won't receive :user

  group BillingFeature
end
```

## Action Design

### Aggregation Logic

Choose aggregation logic that makes sense for your use case:

```ruby
# All-must-match for critical features
action :enabled?, web: :enabled? do |features:, **options|
  features.all? { |feature| Flipper.enabled?(feature, *options.values) }
end

# Any-can-match for progressive rollout
action :any_enabled?, web: :enabled? do |features:, **options|
  features.any? { |feature| Flipper.enabled?(feature, *options.values) }
end

# Count-based for partial availability
action :percentage_enabled, web: :regular do |features:, **options|
  enabled_count = features.count { |feature| Flipper.enabled?(feature, *options.values) }
  (enabled_count.to_f / features.size * 100).round(2)
end
```

### Web Mappings

Use consistent web mappings across your application:

```ruby
# Good - Consistent pattern
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled?   # Read operation
  action :disabled?, web: :regular   # Read operation (not primary)
  action :enable, web: :enable       # Write operation
  action :disable, web: :disable     # Write operation
  action :add, web: :regular         # Other operation
end

# Avoid - Inconsistent mappings
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled?
  action :enable, web: :regular      # Should be :enable
  action :disable, web: :enabled?    # Should be :disable
end
```

### Callbacks

Use callbacks judiciously:

```ruby
# Good - Specific after callbacks
class ApplicationFeature < Featury::Base
  before do |action:, features:|
    Rails.logger.info("Feature action: #{action} on #{features}")
  end

  after :enable, :disable do |action:, features:|
    FeatureAuditLog.create!(action: action, features: features)
  end

  after :enabled?, :disabled? do |action:, features:|
    Metrics.track("feature.check", features: features)
  end
end

# Avoid - Heavy operations in callbacks
class ApplicationFeature < Featury::Base
  before do |action:, features:|
    # Expensive external API call
    SlackNotifier.notify_all_channels(action, features)
  end
end
```

## Condition Patterns

### Guard Conditions

Use conditions for business logic, not configuration:

```ruby
# Good - Business logic
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage
end

# Avoid - Configuration logic (use feature flags instead)
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  condition ->(resources:) { ENV["ONBOARDING_ENABLED"] == "true" }

  feature :passage
end
```

### Optional Resource Checks

Always check for presence when using `required: false`:

```ruby
# Good
class AnalyticsFeature < ApplicationFeature
  resource :user, type: User, option: true, required: false

  condition(lambda do |resources:|
    resources.user.nil? || resources.user.analytics_enabled?
  end)
end

# Avoid - Will raise error if user is nil
class AnalyticsFeature < ApplicationFeature
  resource :user, type: User, option: true, required: false

  condition ->(resources:) { resources.user.analytics_enabled? }
end
```

## Group Organization

### Logical Grouping

Group related features together:

```ruby
# Good - Logical grouping
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  feature :passage
  feature :tutorial
  feature :welcome_email

  group BillingFeature         # Related to onboarding
  group PaymentSystemFeature   # Related to billing
end

# Avoid - Unrelated grouping
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  feature :passage

  group AdminPanelFeature      # Not related to onboarding
  group AnalyticsFeature       # Not related to onboarding
end
```

### Shared Base Class

Keep all feature classes using the same base:

```ruby
# Good
class ApplicationFeature < Featury::Base
  # Shared action definitions
end

class BillingFeature < ApplicationFeature
end

class PaymentFeature < ApplicationFeature
end

# Avoid - Different bases unless necessary
class BillingFeatureBase < Featury::Base
  # Different actions
end

class BillingFeature < BillingFeatureBase
end
```

## Feature Descriptions

### Write Clear Descriptions

Always add descriptions to features and groups:

```ruby
# Good
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "External billing API integration"
  feature :webhooks, description: "Webhook endpoints for billing events"
  feature :invoicing, description: "Automated invoice generation"

  group PaymentSystemFeature, description: "Payment processing features"
end

# Avoid
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api
  feature :webhooks
  feature :invoicing

  group PaymentSystemFeature
end
```

**Guidelines:**
- Describe what the feature does, not how
- Be concise (one sentence)
- Use consistent terminology

## Testing Strategies

### Test Conditions

```ruby
RSpec.describe User::OnboardingFeature do
  let(:user) { create(:user) }

  describe "condition" do
    context "when user is awaiting onboarding" do
      before do
        allow(user).to receive(:onboarding_awaiting?).and_return(true)
        allow(Flipper).to receive(:enabled?).with(:user_onboarding_passage, user).and_return(true)
      end

      it "proceeds to check feature flags" do
        expect(Flipper).to receive(:enabled?).with(:user_onboarding_passage, user)
        User::OnboardingFeature.enabled?(user: user)
      end
    end

    context "when user is not awaiting onboarding" do
      before { allow(user).to receive(:onboarding_awaiting?).and_return(false) }

      it "returns false without checking feature flags" do
        expect(Flipper).not_to receive(:enabled?)
        expect(User::OnboardingFeature.enabled?(user: user)).to be(false)
      end
    end
  end
end
```

### Test Actions

```ruby
RSpec.describe ApplicationFeature do
  describe ".enabled?" do
    let(:user) { create(:user) }

    before do
      class TestFeature < ApplicationFeature
        prefix :test
        resource :user, type: User, option: true
        feature :alpha
        feature :beta
      end
    end

    it "returns true when all features are enabled" do
      allow(Flipper).to receive(:enabled?).and_return(true)
      expect(TestFeature.enabled?(user: user)).to be(true)
    end

    it "returns false when any feature is disabled" do
      allow(Flipper).to receive(:enabled?).with(:test_alpha, user).and_return(true)
      allow(Flipper).to receive(:enabled?).with(:test_beta, user).and_return(false)
      expect(TestFeature.enabled?(user: user)).to be(false)
    end
  end
end
```

### Test Resource Validation

```ruby
RSpec.describe User::OnboardingFeature do
  describe "resource validation" do
    it "raises error when user is not provided" do
      expect { User::OnboardingFeature.enabled? }.to raise_error(Servactory::Errors::InputError)
    end

    it "raises error when user is wrong type" do
      expect { User::OnboardingFeature.enabled?(user: "not a user") }.to raise_error(Servactory::Errors::InputError)
    end

    it "accepts valid user" do
      user = create(:user)
      expect { User::OnboardingFeature.enabled?(user: user) }.not_to raise_error
    end
  end
end
```

## Performance Considerations

### Minimize Feature Count

Keep feature classes focused to reduce the number of feature flag checks:

```ruby
# Good - Focused feature set
class BillingAPIFeature < ApplicationFeature
  prefix :billing

  feature :api
  feature :webhooks
end

# Avoid - Too many features (consider splitting)
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api
  feature :webhooks
  feature :invoicing
  feature :payments
  feature :subscriptions
  feature :refunds
  feature :analytics
  feature :reporting
  # ... 20 more features
end
```

### Cache Feature Instances

When using `.with()`, cache the instance if used multiple times:

```ruby
# Good
feature = User::OnboardingFeature.with(user: user)

if feature.enabled?
  feature.disable
  log_feature_change(feature)
end

# Avoid - Creating multiple instances
if User::OnboardingFeature.with(user: user).enabled?
  User::OnboardingFeature.with(user: user).disable
  log_feature_change(User::OnboardingFeature.with(user: user))
end
```

## Documentation

### Use .info for Runtime Discovery

Use the `.info` API to dynamically discover features and actions:

```ruby
feature_classes = [BillingFeature, PaymentFeature]

features = feature_classes.map do |klass|
  info = klass.info

  {
    name: klass.name,
    features: info.features.all,
    actions: info.actions.web.all
  }
end

# Use this data to build admin UIs, generate documentation, etc.
```

### Generate Documentation

Create automated documentation from feature definitions:

```ruby
class FeatureDocGenerator
  def self.generate
    feature_classes = [User::OnboardingFeature, BillingFeature, PaymentFeature]

    feature_classes.each do |klass|
      info = klass.info

      puts "## #{klass.name}"
      puts ""

      info.features.all.each do |feature|
        puts "- `#{feature.name}`: #{feature.description}"
      end

      puts ""
    end
  end
end
```

## Common Anti-Patterns

### Avoid Feature Flag Sprawl

```ruby
# Avoid - Too granular
class User::ProfileFeature < ApplicationFeature
  feature :edit_name
  feature :edit_email
  feature :edit_phone
  feature :edit_address
  # ... 20 more edit features
end

# Good - Appropriate granularity
class User::ProfileFeature < ApplicationFeature
  feature :editing
  feature :avatar_upload
  feature :privacy_settings
end
```

### Avoid Complex Conditions

```ruby
# Avoid - Complex business logic in conditions
class PremiumFeature < ApplicationFeature
  condition(lambda do |resources:|
    user = resources.user
    subscription = user.subscription

    return false unless subscription

    # 50 lines of complex logic
    # ...
  end)
end

# Good - Delegate to model methods
class PremiumFeature < ApplicationFeature
  condition ->(resources:) { resources.user.eligible_for_premium? }
end

class User < ApplicationRecord
  def eligible_for_premium?
    # Complex logic here
  end
end
```

### Avoid Circular Dependencies

```ruby
# Avoid - Circular group dependencies
class FeatureA < ApplicationFeature
  group FeatureB
end

class FeatureB < ApplicationFeature
  group FeatureA  # Circular!
end

# Good - One-way hierarchy
class MainFeature < ApplicationFeature
  group FeatureA
  group FeatureB
end
```

## Next Steps

- Review [Examples](./examples.md) for real-world patterns
- Explore [Integration](./integration.md) for framework-specific practices
- See [Actions](./actions.md) for action design patterns
- Learn about [Resources](./resources.md) for resource organization
