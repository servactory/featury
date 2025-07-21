<p align="center">
  <a href="https://servactory.com" target="_blank">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/servactory/featury/main/.github/logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/servactory/featury/main/.github/logo-light.svg">
      <img alt="Featury" src="https://raw.githubusercontent.com/servactory/featury/main/.github/logo-light.svg" width="350" height="70" style="max-width: 100%;">
    </picture>
  </a>
</p>

<p align="center">
  <a href="https://rubygems.org/gems/featury"><img src="https://img.shields.io/gem/v/featury?logo=rubygems&logoColor=fff" alt="Gem version"></a>
  <a href="https://github.com/servactory/featury/releases"><img src="https://img.shields.io/github/release-date/servactory/featury" alt="Release Date"></a>
</p>

## Purpose

Featury is designed to group and manage multiple features within a project.
It provides the flexibility to utilize any pre-existing solution or create your own.
It's easily adjustable to align with the unique needs and objectives of your project.

[//]: # (## Documentation)

[//]: # (See [featury.servactory.com]&#40;https://featury.servactory.com&#41; for documentation.)

## Quick Start

### Installation

```ruby
gem "featury"
```

### Usage

#### Basic class for your features

For instance, assume that you are utilizing Flipper for managing features.
In such a scenario, the base class could potentially be structured as follows:

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

  action :add do |features:, **options|
    features.all? { |feature| Flipper.add(feature, *options.values) }
  end

  before do |action:, features:|
    Slack::API::Notify.call!(action:, features:)
  end

  after :enabled?, :disabled? do |action:, features:|
    Slack::API::Notify.call!(action:, features:)
  end
end
```

#### About the `web:` key

The `web:` key in the action definition allows you to specify which method will be used for web interactions. This is useful for mapping internal action names to external endpoints or UI actions. For example:

- `enabled?` — the method that will be used in the web context to check the state of a feature flag;
- `enable` — the method that will be used in the web context to enable a feature flag;
- `disable` — the method that will be used in the web context to disable a feature flag.

This mapping helps you clearly separate internal logic from the interface exposed to web clients.

#### Features of your project

```ruby
class User::OnboardingFeature < ApplicationFeature
  prefix :user_onboarding

  resource :user, type: User

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  features :passage # => :user_onboarding_passage

  groups BillingFeature,
         PaymentSystemFeature
end
```

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  features :api,        # => :billing_api
           :webhooks    # => :billing_webhooks
end
```

```ruby
class PaymentSystemFeature < ApplicationFeature
  prefix :payment_system

  features :api,      # => :payment_system_api
           :webhooks  # => :payment_system_webhooks
end
```

The `resource` method provides an indication of how the transmitted information ought to be processed.
Besides the options provided by [Servactory](https://github.com/servactory/servactory), additional ones are available for stipulating the processing mode of the transmitted data.

If a resource needs to be conveyed as a feature flag option, utilize the `option` parameter:

```ruby 
resource :user, type: User, option: true
```

To transfer a resource to a nested group, utilize the `nested` option:

```ruby
resource :user, type: User, nested: true
```

#### Working with the features of your project

Each of these actions will be applied to every feature flag.
Subsequently, the outcome of these actions will be contingent upon the combined results of all feature flags.

```ruby
User::OnboardingFeature.enabled?(user:) # => true
User::OnboardingFeature.disabled?(user:) # => false
User::OnboardingFeature.enable(user:) # => true
User::OnboardingFeature.disable(user:) # => true
```

You can also utilize the `with` method to pass necessary arguments.

```ruby
feature = User::OnboardingFeature.with(user:)

feature.enabled? # => true
feature.disabled? # => false
feature.enable # => true
feature.disable # => true
```

If a feature flag is deactivated, possibly via automation processes,
the primary feature class subsequently responds with `false` when
queried about its enablement status.

In the preceding example, there might be a scenario where the payment system is
undergoing technical maintenance and therefore is temporarily shut down.
Consequently, the onboarding process for new users will be halted until further notice.

#### Information about features

```ruby
info = User::OnboardingFeature.info
```

```ruby
info.actions      # Feature actions (all, web) of the current class.
info.resources    # Feature resources of the current class.
info.features     # Feature flags of the current class.
info.groups       # Feature flag groups of the current class.
info.tree         # Tree of feature flags from the current class.
```

## Contributing

This project is intended to be a safe, welcoming space for collaboration. 
Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. 
We recommend reading the [contributing guide](./CONTRIBUTING.md) as well.

## License

Featury is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
