# Info and Introspection

Featury provides a comprehensive `.info` API for runtime introspection of features, actions, resources, and groups. This enables dynamic feature discovery, admin UI generation, and debugging.

## Accessing Info

Call `.info` on any feature class:

```ruby
info = User::OnboardingFeature.info
```

The returned object provides access to:
- Actions (all actions and web-specific mappings)
- Resources (resource definitions)
- Features (direct features with descriptions)
- Groups (nested groups with descriptions)
- Tree (complete feature hierarchy)

## Actions Information

### All Actions

Get all action names defined in the feature class:

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    # Implementation
  end

  action :disabled?, web: :regular do |features:, **options|
    # Implementation
  end

  action :enable, web: :enable do |features:, **options|
    # Implementation
  end

  action :disable, web: :disable do |features:, **options|
    # Implementation
  end

  action :add, web: :regular do |features:, **options|
    # Implementation
  end
end

info = ApplicationFeature.info

info.actions.all
# => [:enabled?, :disabled?, :enable, :disable, :add]
```

### Web Actions

Get all actions that have web mappings:

```ruby
info.actions.web.all
# => [:enabled?, :disabled?, :enable, :disable, :add]
```

### Specific Web Mappings

Access actions by their web mapping type:

```ruby
info.actions.web.enabled
# => :enabled?
# Returns the action name that was defined with `web: :enabled?`

info.actions.web.enable
# => :enable
# Returns the action name that was defined with `web: :enable`

info.actions.web.disable
# => :disable
# Returns the action name that was defined with `web: :disable`
```

### Use Cases for Web Mappings

**Admin UI Generation:**

```ruby
info = User::OnboardingFeature.info

# Generate enable button
if info.actions.web.enable
  button "Enable", action: info.actions.web.enable
  # Renders: <button>Enable</button> calling :enable action
end

# Generate disable button
if info.actions.web.disable
  button "Disable", action: info.actions.web.disable
  # Renders: <button>Disable</button> calling :disable action
end
```

**API Endpoint Generation:**

```ruby
info = BillingFeature.info

# Create endpoints for web actions
if info.actions.web.enabled
  get "/api/features/billing/status" do
    BillingFeature.send(info.actions.web.enabled, user: current_user)
  end
end

if info.actions.web.enable
  post "/api/features/billing/enable" do
    BillingFeature.send(info.actions.web.enable, user: current_user)
  end
end
```

**Permission Checks:**

```ruby
info = PremiumFeature.info

# Different permissions for read vs. write actions
def can_check_feature?(user)
  user.role.in?(["user", "admin"]) && info.actions.web.enabled
end

def can_modify_feature?(user)
  user.admin? && (info.actions.web.enable || info.actions.web.disable)
end
```

## Resources Information

Access resource definitions:

```ruby
class User::OnboardingFeature < ApplicationFeature
  resource :user, type: User, option: true, nested: true
  resource :account, type: Account, option: true, required: false
end

info = User::OnboardingFeature.info

info.resources.all
# Returns collection of resources with metadata:
# - Type information
# - Option flags (option: true)
# - Required flags (required: false)
# - Nested flags (nested: true)
```

### Use Cases for Resources

**Dynamic Parameter Validation:**

```ruby
info = User::OnboardingFeature.info

# Validate that all required resources are provided
def validate_resources(params)
  info.resources.all.each do |resource|
    next if resource.optional?

    raise "Missing required resource: #{resource.name}" unless params.key?(resource.name)
  end
end
```

**Form Generation:**

```ruby
info = User::OnboardingFeature.info

# Generate form fields based on resources
info.resources.all.each do |resource|
  label = resource.required? ? "#{resource.name} *" : resource.name
  render_field(resource.name, type: resource.type, label: label)
end
```

## Features Information

Access direct features defined in the current class:

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "External billing API integration"
  feature :webhooks, description: "Webhook endpoints for billing events"
  feature :invoicing, description: "Automated invoice generation"
end

info = BillingFeature.info

info.features.all
# => [
#      { name: :billing_api, description: "External billing API integration" },
#      { name: :billing_webhooks, description: "Webhook endpoints for billing events" },
#      { name: :billing_invoicing, description: "Automated invoice generation" }
#    ]
```

### Use Cases for Features

**Documentation Generation:**

```ruby
info = BillingFeature.info

# Generate feature documentation
info.features.all.each do |feature|
  puts "#{feature.name}: #{feature.description}"
end

# Output:
# billing_api: External billing API integration
# billing_webhooks: Webhook endpoints for billing events
# billing_invoicing: Automated invoice generation
```

**Feature Registry:**

```ruby
# Build a registry of all features in the system
feature_registry = {}

[BillingFeature, PaymentFeature, AnalyticsFeature].each do |klass|
  info = klass.info
  info.features.all.each do |feature|
    feature_registry[feature.name] = {
      class: klass,
      description: feature.description
    }
  end
end
```

## Groups Information

Access nested groups defined in the current class:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  feature :passage, description: "User onboarding passage"

  group BillingFeature, description: "Billing functionality"
  group PaymentSystemFeature, description: "Payment system functionality"
end

info = User::OnboardingFeature.info

info.groups.all
# => [
#      { group_class: BillingFeature, description: "Billing functionality" },
#      { group_class: PaymentSystemFeature, description: "Payment system functionality" }
#    ]
```

### Use Cases for Groups

**Hierarchical UI:**

```ruby
info = User::OnboardingFeature.info

# Render nested feature groups
info.groups.all.each do |group|
  puts "Group: #{group.description}"

  group_info = group.group_class.info
  group_info.features.all.each do |feature|
    puts "  - #{feature.name}: #{feature.description}"
  end
end
```

**Dependency Visualization:**

```ruby
def visualize_dependencies(feature_class, indent = 0)
  info = feature_class.info

  info.features.all.each do |feature|
    puts "  " * indent + "Feature: #{feature.name}"
  end

  info.groups.all.each do |group|
    puts "  " * indent + "Group: #{group.group_class.name}"
    visualize_dependencies(group.group_class, indent + 1)
  end
end

visualize_dependencies(User::OnboardingFeature)
```

## Tree Information

The tree provides a complete view of all features including nested groups:

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  feature :passage, description: "User onboarding passage"

  group BillingFeature
end

class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "Billing API"
  feature :webhooks, description: "Billing webhooks"
end

info = User::OnboardingFeature.info

# Direct features
info.tree.features
# => [:user_onboarding_passage]

# Features from all nested groups (flattened)
info.tree.groups
# => [:billing_api, :billing_webhooks]
```

### Use Cases for Tree

**Complete Feature List:**

```ruby
info = User::OnboardingFeature.info

all_features = info.tree.features + info.tree.groups.flat_map(&:features)
# Returns all feature names in the hierarchy
```

**Feature Auditing:**

```ruby
def audit_features(feature_class)
  info = feature_class.info

  direct_count = info.tree.features.count
  nested_count = info.tree.groups.count
  total_count = direct_count + nested_count

  {
    class: feature_class.name,
    direct_features: direct_count,
    nested_features: nested_count,
    total_features: total_count
  }
end

audit_features(User::OnboardingFeature)
# => { class: "User::OnboardingFeature", direct_features: 1, nested_features: 2, total_features: 3 }
```

## Practical Examples

### API Documentation Generator

```ruby
class FeatureDocGenerator
  def generate
    doc = []

    [User::OnboardingFeature, BillingFeature].each do |klass|
      info = klass.info

      doc << "## #{klass.name}"
      doc << ""

      doc << "### Features"
      info.features.all.each do |feature|
        doc << "- `#{feature.name}`: #{feature.description}"
      end
      doc << ""

      doc << "### Actions"
      info.actions.all.each do |action|
        doc << "- `#{action}`"
      end
      doc << ""

      if info.groups.all.any?
        doc << "### Nested Groups"
        info.groups.all.each do |group|
          doc << "- `#{group.group_class.name}`: #{group.description}"
        end
        doc << ""
      end
    end

    doc.join("\n")
  end
end
```

### Feature Toggle UI

```ruby
class FeatureToggleComponent
  def initialize(feature_class, user:)
    @feature_class = feature_class
    @user = user
    @info = feature_class.info
  end

  def render
    html = ["<div class='feature-toggle'>"]

    # Feature name
    html << "<h3>#{@feature_class.name}</h3>"

    # Current status
    if @info.actions.web.enabled
      status = @feature_class.send(@info.actions.web.enabled, user: @user)
      html << "<p>Status: #{status ? 'Enabled' : 'Disabled'}</p>"
    end

    # Actions
    html << "<div class='actions'>"

    if @info.actions.web.enable
      html << "<button onclick='enableFeature()'>Enable</button>"
    end

    if @info.actions.web.disable
      html << "<button onclick='disableFeature()'>Disable</button>"
    end

    html << "</div>"
    html << "</div>"

    html.join("\n")
  end
end
```

## Next Steps

- Review [Actions](./actions.md) to understand action definitions and web mappings
- Learn about [Resources](./resources.md) and their metadata
- Explore [Examples](./examples.md) for real-world introspection patterns
- See [Integration](./integration.md) for building admin UIs and APIs
