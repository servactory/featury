# Actions

Actions are custom methods that define how your features interact with your feature flag system. They receive feature names and options, and return results based on your system's API.

## Defining Actions

Use the `action` method in your base class:

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

## Action Block Parameters

Each action block receives two parameters:

### features:

An array of feature flag names (symbols) that the action should operate on:

```ruby
action :enabled? do |features:, **options|
  puts features.inspect
  # => [:user_onboarding_passage, :billing_api, :billing_webhooks]
end
```

When a feature class has:
- Direct features defined with `feature`
- Nested groups defined with `group`

The `features:` array contains **all feature names from the current class and all nested groups**.

### **options

A hash of resources passed as options when the action is called:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :account, type: Account, option: true, required: false

  feature :passage
end

action :enabled? do |features:, **options|
  puts options.inspect
  # => { user: #<User:0x00007f9b1c8b3e00>, account: #<Account:0x00007f9b1c8b3f00> }

  puts options.values.inspect
  # => [#<User:0x00007f9b1c8b3e00>, #<Account:0x00007f9b1c8b3f00>]
end

User::OnboardingFeature.enabled?(user: user, account: account)
```

Only resources marked with `option: true` are included in `**options`. See [Resources](./resources.md) for details.

## Web Mappings

The `web:` parameter specifies how the action should be represented in web contexts:

```ruby
action :enabled?, web: :enabled? do |features:, **options|
  # Implementation
end
```

### Available Web Mappings

**web: :enabled?** — For checking feature status (read-only)

**web: :enable** — For enabling features (write)

**web: :disable** — For disabling features (write)

**web: :regular** — For actions that don't fit the above categories

### Accessing Web Mappings

Web mappings are accessible via the `.info.actions.web` API:

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

# Access web mappings
info = ApplicationFeature.info

info.actions.web.enabled  # => :enabled?
info.actions.web.enable   # => :enable
info.actions.web.disable  # => :disable
info.actions.web.all      # => [:enabled?, :disabled?, :enable, :disable, :add]
```

Web mappings allow you to:
- Build admin UIs that know which actions are read vs. write
- Generate API endpoints based on action types
- Create permission systems based on action categories

See [Info and Introspection](./info-and-introspection.md) for complete details.

## Before Callbacks

Execute code before **all** actions:

```ruby
class ApplicationFeature < Featury::Base
  before do |action:, features:|
    Slack::API::Notify.call!(action: action, features: features)
  end

  action :enable, web: :enable do |features:, **options|
    features.all? { |feature| Flipper.enable(feature, *options.values) }
  end
end
```

The `before` callback receives:
- `action:` — Symbol name of the action being called (e.g., `:enable`)
- `features:` — Array of feature flag names

## After Callbacks

Execute code after specific actions:

```ruby
class ApplicationFeature < Featury::Base
  after :enabled?, :disabled? do |action:, features:|
    Slack::API::Notify.call!(action: action, features: features)
  end

  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end

  action :disabled?, web: :regular do |features:, **options|
    features.any? { |feature| !Flipper.enabled?(feature, *options.values) }
  end
end
```

The `after` callback receives the same parameters as `before`.

### Callback Scope

**before** — Runs before all actions (no scope specification)

**after :action1, :action2** — Runs after specific actions only

```ruby
class ApplicationFeature < Featury::Base
  # Runs before ALL actions
  before do |action:, features:|
    Logger.info("Starting action #{action} for #{features}")
  end

  # Runs after ONLY :enabled? and :disabled?
  after :enabled?, :disabled? do |action:, features:|
    Logger.info("Completed check action #{action}")
  end

  # Runs after ONLY :enable, :disable, :add
  after :enable, :disable, :add do |action:, features:|
    Logger.info("Completed mutating action #{action}")
    Cache.clear_for(features)
  end
end
```

## Common Action Patterns

### All-Must-Match (AND Logic)

```ruby
action :enabled?, web: :enabled? do |features:, **options|
  features.all? { |feature| Flipper.enabled?(feature, *options.values) }
end
# Returns true only if ALL features are enabled
```

### Any-Must-Match (OR Logic)

```ruby
action :any_enabled?, web: :enabled? do |features:, **options|
  features.any? { |feature| Flipper.enabled?(feature, *options.values) }
end
# Returns true if ANY feature is enabled
```

### Negation Logic

```ruby
action :disabled?, web: :regular do |features:, **options|
  features.any? { |feature| !Flipper.enabled?(feature, *options.values) }
end
# Returns true if ANY feature is disabled
```

### Aggregate Results

```ruby
action :status, web: :regular do |features:, **options|
  features.map do |feature|
    { feature: feature, enabled: Flipper.enabled?(feature, *options.values) }
  end
end
# Returns array of hashes with status for each feature
```

### Custom Logic

```ruby
action :percentage_enabled, web: :regular do |features:, **options|
  enabled_count = features.count { |feature| Flipper.enabled?(feature, *options.values) }
  (enabled_count.to_f / features.size * 100).round(2)
end
# Returns percentage of features enabled
```

## Action Inheritance

Actions defined in the base class are available to all feature classes:

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end
end

class BillingFeature < ApplicationFeature
  feature :api
end

class PaymentFeature < ApplicationFeature
  feature :stripe
end

# Both classes have the :enabled? action
BillingFeature.enabled?(user: user)
PaymentFeature.enabled?(user: user)
```

## Calling Actions

Actions can be called in two ways:

### Direct Method Calls

```ruby
User::OnboardingFeature.enabled?(user: user)
User::OnboardingFeature.enable(user: user)
User::OnboardingFeature.disable(user: user)
```

### Using .with()

```ruby
feature = User::OnboardingFeature.with(user: user)

feature.enabled?
feature.enable
feature.disable
```

See [Working with Features](./working-with-features.md) for detailed usage patterns.

## Next Steps

- Learn about [Resources](./resources.md) and the `option: true` parameter
- Add [Conditions](./conditions.md) to control when actions are evaluated
- Review [Examples](./examples.md) for real-world action patterns
- Explore [Info and Introspection](./info-and-introspection.md) for runtime action discovery
