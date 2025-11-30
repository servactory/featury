# Integration

This guide demonstrates how to integrate Featury with various backend storage systems. Featury is backend-agnostic - actions receive feature names and options, and you decide how to store and retrieve feature flag states.

## Table of Contents

- [Overview](#overview)
- [Flipper Integration](#flipper-integration)
- [Redis Integration](#redis-integration)
- [Database Integration](#database-integration)
- [External Service Integration](#external-service-integration)
- [Hybrid Approach](#hybrid-approach)

## Overview

Featury's actions abstract feature flag operations through a simple interface:

- **Actions receive `features:`** - An array of feature names (symbols)
- **Actions receive `**options`** - A hash with backend-specific parameters
- **Options can contain**: `actor`, `user_id`, `team_id`, `percentage`, `api_key`, etc.
- **Each backend implements actions differently** based on its storage mechanism

This design allows you to integrate with any backend by implementing actions that match your storage layer.

### Action Signature

All actions follow this signature:

```ruby
action :action_name do |features:, **options|
  # features => [:user_onboarding_passage, :user_onboarding_completion]
  # options  => { user: #<User>, team_id: 123, percentage: 50, ... }

  # Return true/false or perform operation
end
```

The `features` array contains fully-qualified feature names (with prefixes applied). The `options` hash contains any parameters passed when calling the action.

## Flipper Integration

[Flipper](https://github.com/jnunemaker/flipper) is a popular feature flag library for Ruby. Featury can wrap Flipper to provide organizational capabilities.

### Basic Flipper Actions

```ruby
class ApplicationFeature < Featury::Base
  # Check if all features are enabled for an actor
  action :enabled?, web: :enabled? do |features:, **options|
    actor = options[:actor]
    features.all? { |feature| Flipper.enabled?(feature, actor) }
  end

  # Check if any feature is disabled for an actor
  action :disabled?, web: :regular do |features:, **options|
    actor = options[:actor]
    features.any? { |feature| !Flipper.enabled?(feature, actor) }
  end

  # Enable all features globally
  action :enable, web: :enable do |features:, **options|
    features.all? { |feature| Flipper.enable(feature) }
  end

  # Disable all features globally
  action :disable, web: :disable do |features:, **options|
    features.all? { |feature| Flipper.disable(feature) }
  end

  # Add features to Flipper (initialize them)
  action :add, web: :regular do |features:, **options|
    features.all? { |feature| Flipper.add(feature) }
  end
end
```

### Advanced Flipper Actions

Flipper supports multiple activation strategies. Here's how to expose them through Featury actions:

```ruby
class ApplicationFeature < Featury::Base
  # Enable for specific actor (user, account, etc.)
  action :enable_for_actor do |features:, **options|
    actor = options[:actor]
    features.all? { |feature| Flipper.enable_actor(feature, actor) }
  end

  # Disable for specific actor
  action :disable_for_actor do |features:, **options|
    actor = options[:actor]
    features.all? { |feature| Flipper.disable_actor(feature, actor) }
  end

  # Enable for percentage of actors
  action :enable_percentage do |features:, **options|
    percentage = options[:percentage]
    features.all? { |feature| Flipper.enable_percentage_of_actors(feature, percentage) }
  end

  # Enable for a group (defined in Flipper)
  action :enable_group do |features:, **options|
    group = options[:group]
    features.all? { |feature| Flipper.enable_group(feature, group) }
  end

  # Disable for a group
  action :disable_group do |features:, **options|
    group = options[:group]
    features.all? { |feature| Flipper.disable_group(feature, group) }
  end

  # Enable for specific gate IDs
  action :enable_for_gate do |features:, **options|
    gate_name = options[:gate_name]
    gate_value = options[:gate_value]
    features.all? { |feature| Flipper.enable(feature, gate_name => gate_value) }
  end
end
```

### Flipper Usage Examples

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User

  feature :passage, description: "User onboarding passage feature"
  feature :completion, description: "User onboarding completion feature"
end

# Check if enabled for specific user
User::OnboardingFeature.enabled?(actor: current_user)
# => Checks: Flipper.enabled?(:user_onboarding_passage, current_user)
#            Flipper.enabled?(:user_onboarding_completion, current_user)

# Enable for specific user
User::OnboardingFeature.enable_for_actor(actor: current_user)

# Enable for 25% of users
User::OnboardingFeature.enable_percentage(percentage: 25)

# Enable for admin group
User::OnboardingFeature.enable_group(group: :admins)

# Using .with() for cleaner syntax
feature = User::OnboardingFeature.with(user: current_user)
feature.enabled? # Uses current_user as actor
```

### Flipper with Custom Adapter

```ruby
class ApplicationFeature < Featury::Base
  # Use custom Flipper instance with Redis adapter
  action :enabled? do |features:, **options|
    actor = options[:actor]
    flipper = Flipper.new(Flipper::Adapters::Redis.new(Redis.current))
    features.all? { |feature| flipper.enabled?(feature, actor) }
  end
end
```

## Redis Integration

For applications using Redis directly without Flipper, you can implement custom Redis-based feature flags.

### Basic Redis Actions

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    actor_id = options[:actor_id]
    namespace = options[:namespace] || "features"

    features.all? do |feature|
      key = "#{namespace}:#{feature}:#{actor_id}"
      Redis.current.get(key) == "true"
    end
  end

  action :enable, web: :enable do |features:, **options|
    actor_id = options[:actor_id]
    namespace = options[:namespace] || "features"
    ttl = options[:ttl] # Optional expiration in seconds

    features.all? do |feature|
      key = "#{namespace}:#{feature}:#{actor_id}"
      Redis.current.set(key, "true")
      Redis.current.expire(key, ttl) if ttl
      true
    end
  end

  action :disable, web: :disable do |features:, **options|
    actor_id = options[:actor_id]
    namespace = options[:namespace] || "features"

    features.all? do |feature|
      key = "#{namespace}:#{feature}:#{actor_id}"
      Redis.current.del(key)
      true
    end
  end
end
```

### Redis Usage Examples

```ruby
class PaymentFeature < ApplicationFeature
  prefix :payment

  feature :processing, description: "Payment processing"
  feature :refunds, description: "Payment refunds"
end

# Check if enabled for user
PaymentFeature.enabled?(actor_id: user.id)

# Enable with custom namespace
PaymentFeature.enable(actor_id: user.id, namespace: "app_features")

# Enable with 1-hour expiration
PaymentFeature.enable(actor_id: user.id, ttl: 3600)

# Disable for user
PaymentFeature.disable(actor_id: user.id)
```

### Redis with Hash Storage

Store multiple features per user in a single Redis hash:

```ruby
class ApplicationFeature < Featury::Base
  action :enabled? do |features:, **options|
    user_id = options[:user_id]
    key = "user_features:#{user_id}"

    features.all? do |feature|
      Redis.current.hget(key, feature.to_s) == "1"
    end
  end

  action :enable do |features:, **options|
    user_id = options[:user_id]
    key = "user_features:#{user_id}"

    Redis.current.pipelined do |pipeline|
      features.each do |feature|
        pipeline.hset(key, feature.to_s, "1")
      end
    end
    true
  end

  action :disable do |features:, **options|
    user_id = options[:user_id]
    key = "user_features:#{user_id}"

    Redis.current.pipelined do |pipeline|
      features.each do |feature|
        pipeline.hdel(key, feature.to_s)
      end
    end
    true
  end
end
```

### Redis with Percentage Rollout

```ruby
class ApplicationFeature < Featury::Base
  action :enabled? do |features:, **options|
    user_id = options[:user_id]

    features.all? do |feature|
      # Check global flag
      global_key = "feature:#{feature}:enabled"
      return false unless Redis.current.get(global_key) == "true"

      # Check percentage
      percentage_key = "feature:#{feature}:percentage"
      percentage = Redis.current.get(percentage_key).to_i

      return true if percentage >= 100
      return false if percentage <= 0

      # Consistent hashing for percentage rollout
      hash = Digest::MD5.hexdigest("#{feature}:#{user_id}").to_i(16)
      (hash % 100) < percentage
    end
  end

  action :set_percentage do |features:, **options|
    percentage = options[:percentage]

    features.all! do |feature|
      Redis.current.set("feature:#{feature}:percentage", percentage)
      true
    end
  end
end
```

## Database Integration

For applications that need persistence and complex querying, store feature flags in a database.

### ActiveRecord Integration

```ruby
# Migration
class CreateFeatureFlags < ActiveRecord::Migration[7.0]
  def change
    create_table :feature_flags do |t|
      t.string :name, null: false
      t.bigint :user_id
      t.bigint :organization_id
      t.boolean :enabled, default: false, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :feature_flags, [:name, :user_id, :organization_id], unique: true
    add_index :feature_flags, [:organization_id, :enabled]
  end
end

# Model
class FeatureFlag < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :organization, optional: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:user_id, :organization_id] }
end
```

### Database Actions

```ruby
class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]

    features.all? do |feature|
      FeatureFlag.exists?(
        name: feature,
        user_id: user_id,
        organization_id: organization_id,
        enabled: true
      )
    end
  end

  action :enable, web: :enable do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]
    metadata = options[:metadata] || {}

    features.all? do |feature|
      FeatureFlag.find_or_create_by!(
        name: feature,
        user_id: user_id,
        organization_id: organization_id
      ).update!(enabled: true, metadata: metadata)
    end
  end

  action :disable, web: :disable do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]

    features.all? do |feature|
      FeatureFlag.where(
        name: feature,
        user_id: user_id,
        organization_id: organization_id
      ).update_all(enabled: false)
      true
    end
  end

  action :remove do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]

    features.all? do |feature|
      FeatureFlag.where(
        name: feature,
        user_id: user_id,
        organization_id: organization_id
      ).destroy_all
      true
    end
  end
end
```

### Database Usage Examples

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  feature :api, description: "Billing API"
  feature :webhooks, description: "Billing webhooks"
end

# Check if enabled for user in organization
BillingFeature.enabled?(user_id: user.id, organization_id: org.id)

# Enable with metadata
BillingFeature.enable(
  user_id: user.id,
  organization_id: org.id,
  metadata: { enabled_by: admin.id, reason: "Upgrade to Pro plan" }
)

# Disable for user
BillingFeature.disable(user_id: user.id, organization_id: org.id)

# Remove feature flags
BillingFeature.remove(user_id: user.id, organization_id: org.id)
```

### Database with Scope-Based Checks

```ruby
class ApplicationFeature < Featury::Base
  # Check at organization level (all users)
  action :enabled_for_organization? do |features:, **options|
    organization_id = options[:organization_id]

    features.all? do |feature|
      FeatureFlag.exists?(
        name: feature,
        organization_id: organization_id,
        user_id: nil,
        enabled: true
      )
    end
  end

  # Enable for entire organization
  action :enable_for_organization do |features:, **options|
    organization_id = options[:organization_id]

    features.all? do |feature|
      FeatureFlag.find_or_create_by!(
        name: feature,
        organization_id: organization_id,
        user_id: nil
      ).update!(enabled: true)
    end
  end

  # Check for specific user (fallback to organization)
  action :enabled? do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]

    features.all? do |feature|
      # Check user-level first
      user_flag = FeatureFlag.find_by(
        name: feature,
        user_id: user_id,
        organization_id: organization_id
      )
      return user_flag.enabled if user_flag

      # Fallback to organization-level
      org_flag = FeatureFlag.find_by(
        name: feature,
        organization_id: organization_id,
        user_id: nil
      )
      org_flag&.enabled || false
    end
  end
end
```

## External Service Integration

For microservices or distributed systems, feature flags might be managed by an external HTTP API.

### HTTP API Integration

```ruby
require "http" # Using the http gem

class ApplicationFeature < Featury::Base
  action :enabled?, web: :enabled? do |features:, **options|
    tenant_id = options[:tenant_id]
    api_key = options[:api_key]

    features.all? do |feature|
      response = HTTP
        .auth("Bearer #{api_key}")
        .get("https://features-api.example.com/features/#{feature}/status",
             params: { tenant_id: tenant_id })

      response.parse["enabled"] == true
    rescue HTTP::Error => e
      Rails.logger.error("Feature check failed: #{e.message}")
      false # Fail closed
    end
  end

  action :enable, web: :enable do |features:, **options|
    tenant_id = options[:tenant_id]
    api_key = options[:api_key]
    user_id = options[:user_id]

    features.all? do |feature|
      response = HTTP
        .auth("Bearer #{api_key}")
        .post("https://features-api.example.com/features/#{feature}/enable",
              json: {
                tenant_id: tenant_id,
                user_id: user_id
              })

      response.status.success?
    rescue HTTP::Error => e
      Rails.logger.error("Feature enable failed: #{e.message}")
      false
    end
  end

  action :disable, web: :disable do |features:, **options|
    tenant_id = options[:tenant_id]
    api_key = options[:api_key]

    features.all? do |feature|
      response = HTTP
        .auth("Bearer #{api_key}")
        .post("https://features-api.example.com/features/#{feature}/disable",
              json: { tenant_id: tenant_id })

      response.status.success?
    rescue HTTP::Error => e
      Rails.logger.error("Feature disable failed: #{e.message}")
      false
    end
  end

  # Batch check for efficiency
  action :batch_enabled? do |features:, **options|
    tenant_id = options[:tenant_id]
    api_key = options[:api_key]

    response = HTTP
      .auth("Bearer #{api_key}")
      .post("https://features-api.example.com/features/batch-check",
            json: {
              tenant_id: tenant_id,
              features: features.map(&:to_s)
            })

    result = response.parse
    features.all? { |feature| result[feature.to_s] == true }
  rescue HTTP::Error => e
    Rails.logger.error("Batch feature check failed: #{e.message}")
    false
  end
end
```

### HTTP API Usage Examples

```ruby
class NotificationFeature < ApplicationFeature
  prefix :notification

  feature :email, description: "Email notifications"
  feature :sms, description: "SMS notifications"
  feature :push, description: "Push notifications"
end

# Check if enabled via API
NotificationFeature.enabled?(
  tenant_id: "acme-corp",
  api_key: ENV["FEATURES_API_KEY"]
)

# Enable for specific user
NotificationFeature.enable(
  tenant_id: "acme-corp",
  api_key: ENV["FEATURES_API_KEY"],
  user_id: user.id
)

# Batch check (single API call)
NotificationFeature.batch_enabled?(
  tenant_id: "acme-corp",
  api_key: ENV["FEATURES_API_KEY"]
)
```

### GraphQL API Integration

```ruby
class ApplicationFeature < Featury::Base
  action :enabled? do |features:, **options|
    tenant_id = options[:tenant_id]
    user_id = options[:user_id]

    query = <<~GRAPHQL
      query CheckFeatures($tenantId: ID!, $userId: ID!, $features: [String!]!) {
        featuresEnabled(tenantId: $tenantId, userId: $userId, features: $features) {
          name
          enabled
        }
      }
    GRAPHQL

    response = GraphQL::Client.execute(
      query,
      variables: {
        tenantId: tenant_id,
        userId: user_id,
        features: features.map(&:to_s)
      }
    )

    results = response.data.features_enabled
    features.all? { |feature| results.find { |r| r.name == feature.to_s }&.enabled }
  end
end
```

## Hybrid Approach

Combine multiple backends for optimal performance and reliability.

### Redis Cache + Database Fallback

```ruby
class ApplicationFeature < Featury::Base
  action :enabled? do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]
    cache_ttl = options[:cache_ttl] || 300 # 5 minutes default

    features.all? do |feature|
      cache_key = "feature:#{feature}:#{user_id}:#{organization_id}"

      # Try cache first
      cached = Redis.current.get(cache_key)
      if cached
        return cached == "true"
      end

      # Fallback to database
      result = FeatureFlag.exists?(
        name: feature,
        user_id: user_id,
        organization_id: organization_id,
        enabled: true
      )

      # Cache the result
      Redis.current.setex(cache_key, cache_ttl, result.to_s)
      result
    end
  end

  action :enable do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]

    features.all? do |feature|
      # Update database
      FeatureFlag.find_or_create_by!(
        name: feature,
        user_id: user_id,
        organization_id: organization_id
      ).update!(enabled: true)

      # Invalidate cache
      cache_key = "feature:#{feature}:#{user_id}:#{organization_id}"
      Redis.current.del(cache_key)

      true
    end
  end

  action :disable do |features:, **options|
    user_id = options[:user_id]
    organization_id = options[:organization_id]

    features.all? do |feature|
      # Update database
      FeatureFlag.where(
        name: feature,
        user_id: user_id,
        organization_id: organization_id
      ).update_all(enabled: false)

      # Invalidate cache
      cache_key = "feature:#{feature}:#{user_id}:#{organization_id}"
      Redis.current.del(cache_key)

      true
    end
  end
end
```

### Local Memory + Remote API

```ruby
class ApplicationFeature < Featury::Base
  # In-memory cache with TTL
  @feature_cache = Concurrent::Map.new
  @cache_timestamps = Concurrent::Map.new

  class << self
    attr_reader :feature_cache, :cache_timestamps
  end

  action :enabled? do |features:, **options|
    tenant_id = options[:tenant_id]
    api_key = options[:api_key]
    cache_ttl = options[:cache_ttl] || 60 # 1 minute default

    features.all? do |feature|
      cache_key = "#{tenant_id}:#{feature}"

      # Check memory cache
      timestamp = self.class.cache_timestamps[cache_key]
      if timestamp && (Time.current - timestamp) < cache_ttl
        return self.class.feature_cache[cache_key]
      end

      # Fetch from API
      response = HTTP
        .auth("Bearer #{api_key}")
        .get("https://features-api.example.com/features/#{feature}/status",
             params: { tenant_id: tenant_id })

      result = response.parse["enabled"] == true

      # Cache in memory
      self.class.feature_cache[cache_key] = result
      self.class.cache_timestamps[cache_key] = Time.current

      result
    rescue HTTP::Error
      # Return cached value if available, otherwise fail closed
      self.class.feature_cache[cache_key] || false
    end
  end
end
```

### Multi-Region with Fallback

```ruby
class ApplicationFeature < Featury::Base
  action :enabled? do |features:, **options|
    user_id = options[:user_id]
    region = options[:region] || ENV["AWS_REGION"]

    features.all? do |feature|
      # Try regional database first
      regional_flag = FeatureFlag.where(
        name: feature,
        user_id: user_id,
        region: region,
        enabled: true
      ).exists?

      return true if regional_flag

      # Fallback to global database
      FeatureFlag.where(
        name: feature,
        user_id: user_id,
        region: nil,
        enabled: true
      ).exists?
    end
  end
end
```

## Best Practices

### Error Handling

Always handle errors gracefully in actions:

```ruby
action :enabled? do |features:, **options|
  features.all? do |feature|
    begin
      check_feature(feature, options)
    rescue => e
      Rails.logger.error("Feature check failed: #{e.message}")
      false # Fail closed by default
    end
  end
end
```

### Performance Optimization

Batch operations when possible:

```ruby
action :enabled? do |features:, **options|
  user_id = options[:user_id]

  # Single query instead of N queries
  enabled_features = FeatureFlag.where(
    name: features,
    user_id: user_id,
    enabled: true
  ).pluck(:name)

  features.all? { |feature| enabled_features.include?(feature) }
end
```

### Timeout Protection

Set timeouts for external calls:

```ruby
action :enabled? do |features:, **options|
  features.all? do |feature|
    Timeout.timeout(1) do # 1 second timeout
      check_external_service(feature, options)
    end
  end
rescue Timeout::Error
  false # Fail closed on timeout
end
```

### Monitoring

Add monitoring to track feature flag usage:

```ruby
action :enabled? do |features:, **options|
  result = features.all? { |feature| Flipper.enabled?(feature, options[:actor]) }

  # Track metrics
  StatsD.increment("feature.check", tags: ["result:#{result}"])

  result
end
```

## Next Steps

- Review [Actions](./actions.md) for more on defining actions
- See [Examples](./examples.md) for complete integration examples
- Check [Best Practices](./best-practices.md) for recommended patterns
