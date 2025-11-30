# Resources

Resources are type-validated parameters that are passed to feature actions. Featury integrates with Servactory to provide robust resource validation and flexible parameter handling.

## Defining Resources

Use the `resource` method to define a parameter:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User

  feature :passage
end
```

## Resource Options

### type: (Required)

Specifies the expected type of the resource. Featury uses Servactory for type validation:

```ruby
resource :user, type: User
resource :account, type: Account
resource :comment, type: String
resource :count, type: Integer
```

### option: true

Passes the resource as an option to the feature flag system:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true

  feature :passage

  action :enabled?, web: :enabled? do |features:, **options|
    puts options.inspect
    # => { user: #<User:0x00007f9b1c8b3e00> }

    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
    # Calls: Flipper.enabled?(:user_onboarding_passage, user_instance)
  end
end

User::OnboardingFeature.enabled?(user: user)
```

**Without option: true:**

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User
  # option: true is NOT specified

  feature :passage

  action :enabled?, web: :enabled? do |features:, **options|
    puts options.inspect
    # => {}
    # The user resource is NOT included in options
  end
end
```

Use `option: true` when your feature flag system needs the resource as a context parameter (e.g., Flipper actors).

### required: false

Makes a resource optional:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :account, type: Account, option: true, required: false

  feature :passage
end

# Can be called without :account
User::OnboardingFeature.enabled?(user: user)

# Or with :account
User::OnboardingFeature.enabled?(user: user, account: account)
```

**Use Cases:**
- Global feature flags that don't require user context
- Optional context parameters for logging/analytics
- Features that work with or without certain resources

### nested: true

Passes the resource to nested groups:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true

  feature :passage

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true

  feature :api
end

User::OnboardingFeature.enabled?(user: user)
# The :user resource is passed to:
# 1. User::OnboardingFeature (for :user_onboarding_passage)
# 2. BillingFeature (for :billing_api)
```

**Without nested: true:**

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true
  # nested: true is NOT specified

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  resource :user, type: User, option: true

  feature :api
end

# This will raise an error because BillingFeature expects :user
# but it's not passed from the parent
User::OnboardingFeature.enabled?(user: user)
```

## Combining Resource Options

You can combine multiple options:

```ruby
class MainFeature < ApplicationFeature
  # Required resource, passed as option, passed to nested groups
  resource :user, type: User, option: true, nested: true

  # Optional resource, passed as option, not nested
  resource :account, type: Account, option: true, required: false

  # Required resource, not passed as option (only for validation)
  resource :context, type: Hash

  feature :main

  group SubFeature
end
```

## Servactory Integration

Featury uses Servactory for resource validation, which provides:

### Type Checking

```ruby
resource :user, type: User

User::OnboardingFeature.enabled?(user: "not a user")
# Raises Servactory validation error
```

### Custom Validations

You can use Servactory's validation features:

```ruby
resource :user, type: User, option: true
resource :age, type: Integer, option: true, required: false
```

For more advanced validations, refer to the [Servactory documentation](https://github.com/servactory/servactory).

## Resource Patterns

### User Context

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true

  feature :passage
  group BillingFeature
end
```

Use this pattern when:
- Features are user-specific
- Nested groups need the same user context
- Using Flipper actors or similar

### Multi-Resource Context

```ruby
class OrganizationFeature < ApplicationFeature
  resource :organization, type: Organization, option: true, nested: true
  resource :user, type: User, option: true, nested: true

  feature :admin_panel
  group BillingFeature
end
```

Use this pattern when:
- Features depend on multiple entities
- Both resources are needed for nested groups

### Optional Global State

```ruby
class ExperimentalFeature < ApplicationFeature
  resource :user, type: User, option: true, required: false

  feature :beta_ui
end

# Can be called globally
ExperimentalFeature.enabled?

# Or for specific users
ExperimentalFeature.enabled?(user: user)
```

Use this pattern when:
- Features can be enabled globally or per-user
- Managing progressive rollouts

### Validation-Only Resources

```ruby
class AnalyticsFeature < ApplicationFeature
  resource :event_data, type: Hash  # Not option: true
  resource :user, type: User, option: true

  feature :tracking

  action :track, web: :regular do |features:, **options|
    # event_data is validated but not in options
    # Only user is in options
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end
end
```

Use this pattern when:
- You need to validate a resource's type
- But don't need to pass it to the feature flag system

## Accessing Resources

Resources are validated but not directly accessible in action blocks. Instead, they're passed via `**options` if marked with `option: true`:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true
  resource :metadata, type: Hash  # No option: true

  action :enabled?, web: :enabled? do |features:, **options|
    # options contains only :user (marked with option: true)
    # metadata is validated but not included in options

    user = options[:user]
    features.all? { |feature| Flipper.enabled?(feature, user) }
  end
end
```

## Resource Introspection

Access resource definitions via `.info`:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true
  resource :account, type: Account, option: true, required: false
end

User::OnboardingFeature.info.resources.all
# Returns resource collection with type and option information
```

See [Info and Introspection](./info-and-introspection.md) for details.

## Next Steps

- Learn about [Conditions](./conditions.md) that use resources for conditional logic
- Review [Actions](./actions.md) to understand how resources flow to action blocks
- Explore [Groups](./groups.md) and the `nested: true` option
- See [Examples](./examples.md) for real-world resource patterns
