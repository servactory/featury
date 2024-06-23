<p align="center">
  <a href="https://rubygems.org/gems/featury"><img src="https://img.shields.io/gem/v/featury?logo=rubygems&logoColor=fff" alt="Gem version"></a>
  <a href="https://github.com/servactory/featury/releases"><img src="https://img.shields.io/github/release-date/servactory/featury" alt="Release Date"></a>
</p>

## For what?

Featury is designed for grouping and managing multiple features in projects.
You can use any ready-made solution or your own.
Feature is easily customizable to suit projects and their goals.

[//]: # (## Documentation)

[//]: # (See [featury.servactory.com]&#40;https://featury.servactory.com&#41; for documentation.)

## Quick Start

### Installation

```ruby
gem "featury"
```

### Usage

#### Basic class for your features

For example, you use Flipper for features.
In this case, the base class might look like this:

```ruby
class ApplicationFeature < Featury::Base
  action :enabled? do |features:, **options|
    features.all? { |feature| Flipper.enabled?(feature, *options.values) }
  end

  action :disabled? do |features:, **options|
    features.any? { |feature| !Flipper.enabled?(feature, *options.values) }
  end

  action :enable do |features:, **options|
    features.all? { |feature| Flipper.enable(feature, *options.values) }
  end

  action :disable do |features:, **options|
    features.all? { |feature| Flipper.disable(feature, *options.values) }
  end
end
```

#### Features of your project

```ruby
class UserFeature::Onboarding < ApplicationFeature
  resource :user, type: User

  condition ->(resources:) { resources.user.onboarding_awaiting? }

  prefix :user_onboarding

  features(
    :passage, # => :user_onboarding_passage
  )

  groups(
    BillingFeature,
    PaymentSystemFeature
  )
end
```

```ruby
class BillingFeature < ApplicationFeature
  prefix :billing

  features(
    :work # => :billing_work
  )
end
```

```ruby
class PaymentSystemFeature < ApplicationFeature
  prefix :payment_system

  features(
    :work # => :payment_system_work
  )
end
```

The `resource` method can indicate how the transmitted information should be processed.
In addition to the options that Servactory brings, there are options for specifying the processing mode of the transmitted data.

If it is necessary for a resource to be transferred as an option for a feature flag, then use the `option` option:

```ruby
resource :user, type: User, option: true
```

If it is necessary for a resource to be transferred to a nested group, then use the `nested` option:

```ruby
resource :user, type: User, nested: true
```

#### Working with the features of your project

Each of these actions will be applied to all feature flags.
And the result of these calls will be based on the result of all feature flags.

```ruby
UserFeature::Onboarding.enabled?(user:) # => true
UserFeature::Onboarding.disabled?(user:) # => false
UserFeature::Onboarding.enable(user:) # => true
UserFeature::Onboarding.disable(user:) # => false
```

You can also use the `with` method to pass arguments if needed.

```ruby
feature = UserFeature::Onboarding.with(user:)

feature.enabled? # => true
feature.disabled? # => false
feature.enable # => true
feature.disable # => false
```

If one of the feature flags is turned off, for example,
through your automation, then the main feature class will
return `false` when asked "is it enabled?".

In the example above, this could be the payment system and its shutdown due to technical work.
In this case, all onboarding of new users will be suspended.

## Contributing

This project is intended to be a safe, welcoming space for collaboration. 
Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. 
We recommend reading the [contributing guide](./CONTRIBUTING.md) as well.

## License

Featury is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
