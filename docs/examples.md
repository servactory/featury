# Examples

Real-world examples demonstrating common Featury patterns and use cases.

## User Onboarding System

A complete user onboarding feature with multiple stages and nested billing features:

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
    Rails.logger.info("Executing #{action} on features: #{features}")
  end
end

class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User, option: true, nested: true

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  feature :passage, description: "User onboarding passage feature"
  feature :tutorial, description: "Interactive tutorial"
  feature :welcome_email, description: "Welcome email notification"

  group BillingFeature, description: "Billing functionality group"
  group PaymentSystemFeature, description: "Payment system functionality group"
end

class BillingFeature < ApplicationFeature
  prefix :billing

  resource :user, type: User, option: true

  feature :api, description: "Billing API feature"
  feature :webhooks, description: "Billing webhooks feature"
  feature :invoicing, description: "Invoice generation"
end

class PaymentSystemFeature < ApplicationFeature
  prefix :payment_system

  resource :user, type: User, option: true

  feature :api, description: "Payment system API feature"
  feature :webhooks, description: "Payment system webhooks feature"
  feature :stripe, description: "Stripe integration"
  feature :paypal, description: "PayPal integration"
end

# Usage
user = User.find(1)

# Check if all onboarding features are enabled
User::OnboardingFeature.enabled?(user: user)
# Checks 9 features total:
# - :user_onboarding_passage
# - :user_onboarding_tutorial
# - :user_onboarding_welcome_email
# - :billing_api
# - :billing_webhooks
# - :billing_invoicing
# - :payment_system_api
# - :payment_system_webhooks
# - :payment_system_stripe
# - :payment_system_paypal

# Enable all onboarding features
User::OnboardingFeature.enable(user: user)

# Disable all onboarding features
User::OnboardingFeature.disable(user: user)

# Using .with()
feature = User::OnboardingFeature.with(user: user)
feature.enabled? # => true
feature.disable  # => true
```

## Multi-Tenant SaaS Application

Features organized by organization and user context:

```ruby
class Organization::FeatureBase < Featury::Base
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

class Organization::PremiumFeature < Organization::FeatureBase
  prefix :org_premium

  resource :organization, type: Organization, option: true
  resource :user, type: User, option: true, required: false

  condition(lambda do |resources:|
    resources.organization.subscription&.plan&.in?(["premium", "enterprise"])
  end)

  feature :advanced_analytics, description: "Advanced analytics dashboard"
  feature :custom_branding, description: "Custom branding options"
  feature :priority_support, description: "24/7 priority support"
  feature :api_access, description: "API access"

  group Organization::IntegrationsFeature, description: "Third-party integrations"
end

class Organization::IntegrationsFeature < Organization::FeatureBase
  prefix :org_integrations

  resource :organization, type: Organization, option: true

  feature :slack, description: "Slack integration"
  feature :github, description: "GitHub integration"
  feature :jira, description: "Jira integration"
  feature :salesforce, description: "Salesforce integration"
end

# Usage
org = Organization.find(1)

# Check if premium features are available
Organization::PremiumFeature.enabled?(organization: org)

# Enable premium features for organization
Organization::PremiumFeature.enable(organization: org)

# Check with user context
Organization::PremiumFeature.enabled?(organization: org, user: current_user)
```

## Progressive Feature Rollout

Staged rollout with environment-based and user-based controls:

```ruby
class ExperimentalFeature < ApplicationFeature
  prefix :experimental

  resource :user, type: User, option: true, required: false

  feature :new_dashboard, description: "Redesigned dashboard UI"
  feature :ai_assistant, description: "AI-powered assistant"
  feature :beta_api, description: "Beta API endpoints"

  group AlphaFeature, description: "Alpha-stage features"
end

class AlphaFeature < ApplicationFeature
  prefix :alpha

  resource :user, type: User, option: true, required: false

  condition(lambda do |resources:|
    # Only for staff or opted-in beta testers
    resources.user&.staff? || resources.user&.beta_tester?
  end)

  feature :experimental_ui, description: "Highly experimental UI changes"
  feature :performance_mode, description: "Performance optimization mode"
end

# Usage

# Global rollout (no user)
ExperimentalFeature.enable

# User-specific rollout
ExperimentalFeature.enable(user: beta_user)

# Check for specific user
feature = ExperimentalFeature.with(user: current_user)
if feature.enabled?
  render "new_dashboard"
else
  render "classic_dashboard"
end

# Alpha features only work for staff/beta testers
AlphaFeature.enable(user: staff_user)
AlphaFeature.enabled?(user: regular_user) # => false (condition fails)
```

## Regional Feature Availability

Features controlled by geographic regions:

```ruby
class RegionalFeature < ApplicationFeature
  prefix :regional

  resource :user, type: User, option: true

  condition(lambda do |resources:|
    resources.user.country_code.in?(["US", "CA", "GB", "AU"])
  end)

  feature :crypto_payments, description: "Cryptocurrency payment support"
  feature :instant_transfer, description: "Instant bank transfers"
  feature :local_currency, description: "Local currency support"
end

class EUFeature < ApplicationFeature
  prefix :eu

  resource :user, type: User, option: true

  condition(lambda do |resources:|
    resources.user.country_code.in?(EU_COUNTRY_CODES)
  end)

  feature :gdpr_tools, description: "GDPR compliance tools"
  feature :sepa_payments, description: "SEPA payment support"
  feature :vat_calculation, description: "VAT calculation"
end

# Usage
us_user = User.find_by(country_code: "US")
eu_user = User.find_by(country_code: "DE")

RegionalFeature.enabled?(user: us_user) # => true (condition passes)
RegionalFeature.enabled?(user: eu_user) # => false (condition fails)

EUFeature.enabled?(user: eu_user) # => true (condition passes)
EUFeature.enabled?(user: us_user) # => false (condition fails)
```

## A/B Testing Framework

Features for A/B testing with variant assignments:

```ruby
class ABTestFeature < ApplicationFeature
  prefix :ab_test

  resource :user, type: User, option: true

  feature :new_checkout_v1, description: "Checkout variant 1"
  feature :new_checkout_v2, description: "Checkout variant 2"
  feature :new_pricing_page, description: "New pricing page design"
end

class ABTestService
  def self.assign_variant(user, test_name)
    # Consistent hash-based assignment
    variant = (user.id + test_name.hash) % 2

    case test_name
    when :checkout
      if variant == 0
        Flipper.enable(:ab_test_new_checkout_v1, user)
        Flipper.disable(:ab_test_new_checkout_v2, user)
      else
        Flipper.disable(:ab_test_new_checkout_v1, user)
        Flipper.enable(:ab_test_new_checkout_v2, user)
      end
    end
  end
end

# Setup
ABTestService.assign_variant(user, :checkout)

# Check which variant is active
if Flipper.enabled?(:ab_test_new_checkout_v1, user)
  render "checkout/variant_1"
elsif Flipper.enabled?(:ab_test_new_checkout_v2, user)
  render "checkout/variant_2"
else
  render "checkout/control"
end
```

## Maintenance Mode

System-wide and service-specific maintenance controls:

```ruby
class MaintenanceFeature < ApplicationFeature
  prefix :maintenance

  resource :user, type: User, option: true, required: false

  feature :global, description: "Global maintenance mode"
  feature :api, description: "API maintenance mode"
  feature :webhooks, description: "Webhooks maintenance mode"
  feature :scheduled_jobs, description: "Background jobs maintenance mode"
end


# Usage

# Enable global maintenance
Flipper.enable(:maintenance_global)

# Enable API maintenance only
Flipper.enable(:maintenance_api)

# Disable all maintenance
MaintenanceFeature.disable
```

## Permission-Based Features

Features controlled by user roles and permissions:

```ruby
class AdminFeature < ApplicationFeature
  prefix :admin

  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.admin? }

  feature :user_management, description: "User management panel"
  feature :system_settings, description: "System settings access"
  feature :audit_logs, description: "Audit log viewer"

  group SuperAdminFeature, description: "Super admin features"
end

class SuperAdminFeature < ApplicationFeature
  prefix :super_admin

  resource :user, type: User, option: true

  condition ->(resources:) { resources.user.super_admin? }

  feature :feature_flags, description: "Feature flag management"
  feature :database_access, description: "Direct database access"
  feature :impersonation, description: "User impersonation"
end

# Usage
admin_user = User.find_by(role: "admin")
super_admin = User.find_by(role: "super_admin")
regular_user = User.find_by(role: "user")

# Admin features
AdminFeature.enabled?(user: admin_user)       # => true
AdminFeature.enabled?(user: super_admin)      # => true
AdminFeature.enabled?(user: regular_user)     # => false (condition fails)

# Super admin features
SuperAdminFeature.enabled?(user: super_admin) # => true
SuperAdminFeature.enabled?(user: admin_user)  # => false (condition fails)

```

## Time-Based Features

Features that activate/deactivate based on time windows:

```ruby
class SeasonalFeature < ApplicationFeature
  prefix :seasonal

  resource :user, type: User, option: true, required: false

  condition(lambda do |resources:|
    # Holiday season: November and December
    Date.current.month.in?([11, 12])
  end)

  feature :holiday_theme, description: "Holiday-themed UI"
  feature :gift_cards, description: "Gift card purchases"
  feature :special_offers, description: "Seasonal special offers"
end

class ScheduledFeature < ApplicationFeature
  prefix :scheduled

  resource :user, type: User, option: true, required: false

  condition(lambda do |resources:|
    # Active between specific dates
    launch_date = Date.parse("2024-01-15")
    end_date = Date.parse("2024-02-15")

    Date.current.between?(launch_date, end_date)
  end)

  feature :limited_campaign, description: "Limited-time campaign"
end

# Usage

# Check seasonal features (automatic based on current date)
SeasonalFeature.enabled? # => true in Nov/Dec, false otherwise

# Enable for specific user
SeasonalFeature.enable(user: user)

# Check scheduled features
ScheduledFeature.enabled? # => true during campaign window
```

## Next Steps

- Review [Best Practices](./best-practices.md) for recommended patterns
- Explore [Integration](./integration.md) for framework-specific examples
- Learn about [Actions](./actions.md) for custom action definitions
- See [Conditions](./conditions.md) for advanced conditional logic
